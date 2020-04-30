From: akpm@linux-foundation.org
Subject: + khugepaged-add-self-test-fix-2.patch added to -mm tree
Date: Wed, 29 Apr 2020 17:41:27 -0700
Message-ID: <20200430004127.XgIvUphyn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgD3Al3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 20:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: replace the usage of system(3) in the test
has been added to the -mm tree.  Its filename is
     khugepaged-add-self-test-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-add-self-test-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-add-self-test-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: khugepaged: replace the usage of system(3) in the test

Some glibc version doesn't use CLONE_VM | CLONE_VFORK for system(3)
implementation and on such system, we find the test case fails.  This is
due to fork() marking all the parent page table pages read-only to do a
COW.

Avoid the usage of system(3) in the test.

Link: http://lkml.kernel.org/r/20200429110727.89388-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |  105 ++++++++++++++++------
 1 file changed, 77 insertions(+), 28 deletions(-)

--- a/tools/testing/selftests/vm/khugepaged.c~khugepaged-add-self-test-fix-2
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -21,6 +21,7 @@ static unsigned long page_size;
 static int hpage_pmd_nr;
 
 #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
+#define PID_SMAPS "/proc/self/smaps"
 
 enum thp_enabled {
 	THP_ALWAYS,
@@ -330,56 +331,104 @@ static void adjust_settings(void)
 	success("OK");
 }
 
-#define CHECK_HUGE_FMT "sed -ne " \
-	"'/^%lx/,/^AnonHugePages/{/^AnonHugePages:\\s*%ld kB/ q1}' " \
-	"/proc/%d/smaps"
+#define MAX_LINE_LENGTH 500
 
-static bool check_huge(void *p)
+static bool check_for_pattern(FILE *fp, char *pattern, char *buf)
 {
-	char *cmd;
+	while (fgets(buf, MAX_LINE_LENGTH, fp) != NULL) {
+		if (!strncmp(buf, pattern, strlen(pattern)))
+			return true;
+	}
+	return false;
+}
+
+static bool check_huge(char *addr)
+{
+	bool thp = false;
 	int ret;
+	FILE *fp;
+	char buffer[MAX_LINE_LENGTH];
+	char addr_pattern[MAX_LINE_LENGTH];
 
-	ret = asprintf(&cmd, CHECK_HUGE_FMT,
-			(unsigned long)p, hpage_pmd_size >> 10, getpid());
-	if (ret < 0) {
-		perror("asprintf(CHECK_FMT)");
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08llx-", addr);
+	if (ret >= MAX_LINE_LENGTH) {
+		printf("%s: Pattern is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+
+
+	fp = fopen(PID_SMAPS, "r");
+	if (!fp) {
+		printf("%s: Failed to open file %s\n", __func__, PID_SMAPS);
 		exit(EXIT_FAILURE);
 	}
+	if (!check_for_pattern(fp, addr_pattern, buffer))
+		goto err_out;
 
-	ret = system(cmd);
-	free(cmd);
-	if (ret < 0 || !WIFEXITED(ret)) {
-		perror("system(check_huge)");
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "AnonHugePages:%10lld kB", hpage_pmd_size >> 10);
+	if (ret >= MAX_LINE_LENGTH) {
+		printf("%s: Pattern is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
+	/*
+	 * Fetch the AnonHugePages: in the same block and check whether it got
+	 * the expected number of hugeepages next.
+	 */
+	if (!check_for_pattern(fp, "AnonHugePages:", buffer))
+		goto err_out;
+
+	if (strncmp(buffer, addr_pattern, strlen(addr_pattern)))
+		goto err_out;
 
-	return WEXITSTATUS(ret);
+	thp = true;
+err_out:
+	fclose(fp);
+	return thp;
 }
 
-#define CHECK_SWAP_FMT "sed -ne " \
-	"'/^%lx/,/^Swap:/{/^Swap:\\s*%ld kB/ q1}' " \
-	"/proc/%d/smaps"
 
-static bool check_swap(void *p, unsigned long size)
+static bool check_swap(void *addr, unsigned long size)
 {
-	char *cmd;
+	bool swap = false;
 	int ret;
+	FILE *fp;
+	char buffer[MAX_LINE_LENGTH];
+	char addr_pattern[MAX_LINE_LENGTH];
 
-	ret = asprintf(&cmd, CHECK_SWAP_FMT,
-			(unsigned long)p, size >> 10, getpid());
-	if (ret < 0) {
-		perror("asprintf(CHECK_SWAP)");
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08llx-", addr);
+	if (ret >= MAX_LINE_LENGTH) {
+		printf("%s: Pattern is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+
+
+	fp = fopen(PID_SMAPS, "r");
+	if (!fp) {
+		printf("%s: Failed to open file %s\n", __func__, PID_SMAPS);
 		exit(EXIT_FAILURE);
 	}
+	if (!check_for_pattern(fp, addr_pattern, buffer))
+		goto err_out;
 
-	ret = system(cmd);
-	free(cmd);
-	if (ret < 0 || !WIFEXITED(ret)) {
-		perror("system(check_swap)");
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "Swap:%19lld kB", size >> 10);
+	if (ret >= MAX_LINE_LENGTH) {
+		printf("%s: Pattern is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
+	/*
+	 * Fetch the Swap: in the same block and check whether it got
+	 * the expected number of hugeepages next.
+	 */
+	if (!check_for_pattern(fp, "Swap:", buffer))
+		goto err_out;
+
+	if (strncmp(buffer, addr_pattern, strlen(addr_pattern)))
+		goto err_out;
 
-	return WEXITSTATUS(ret);
+	swap = true;
+err_out:
+	fclose(fp);
+	return swap;
 }
 
 static void *alloc_mapping(void)
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

khugepaged-add-self-test-fix-2.patch
