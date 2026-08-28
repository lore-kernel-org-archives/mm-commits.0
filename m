Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6B71C69D
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 04:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787891183; cv=none; b=lfoZfPWaT4eg02Dvsrvj41rPTqOYTLX0H/gg+gmeS4kFAn5Re+r5M/vIjvL+nqA54NpgE8diKPC8ANlB6m+VmuCVjoYzCPpd7mfaonq7Fa0pAmhYhZQ120Ak/MWzlwXoRAatfqtoH+D10SBoub04AX+rnFnNle4Q9PImr4h8ngM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787891183; c=relaxed/simple;
	bh=AdNWU8UrpCuP1BBso2OKN0f4uNTEruYYt/A7QJSaIDs=;
	h=Date:To:From:Subject:Message-Id; b=hMDBac23Bt9eHnydWEP1HSHPbDPDnfyElqstCMs5rNBJMbogc3RUq7JZgfXliVkGNFfQkSBDKopkIzvR2uuiFPLZE+DCNcB0jX+vKxqbJlILcZ1MFMXNUlfQYikeqxrfjQ5WOTlVDkJzDHcSe5HcVwfT8fLV3caqrZ95CKfjyOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjZNxljb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjZNxljb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437201F000E9;
	Fri, 28 Aug 2026 04:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787891181;
	bh=Dp8FQGO62NVEA7fr35kzAaIZzd1ybVaWHtHueQ2Gm+o=;
	h=Date:To:From:Subject;
	b=GjZNxljbfQ/7g1V3Sb7rYAiHmhWu7YYIYMh5buJm4FDeae+1TVA1Ix/vYNMet71pt
	 b84MQb4fO9THexJaQm1uvFTwXZHHHtjVEzeUoh7RS5ocDggODbwCi3IqFovr2FN6r8
	 hCoF0XpPNsr5x1KY17k2TD9RQogbqh+yhaOyxiwM=
Date: Thu, 27 Aug 2026 21:26:20 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline.patch added to mm-new branch
Message-Id: <20260828042621.437201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: restore enable_soft_offline in hugetlb-soft-offline
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: selftests/mm: restore enable_soft_offline in hugetlb-soft-offline
Date: Tue, 25 Aug 2026 16:57:56 +0800

hugetlb-soft-offline toggles /proc/sys/vm/enable_soft_offline between 1
and 0 (test_soft_offline_common(1) then (0)) and leaves it at 0 when it
finishes, silently disabling soft offlining for the whole system after the
run.

Save the original value before the test and restore it from an atexit()
handler, as hugepage_restore_settings_atexit() in hugepage_settings.c
already does.  Use read_num()/write_num() from vm_util instead of
hand-rolled popen()/fopen() helpers.

The restore handler must not call write_num(): on failure it re-enters
exit() through ksft_exit_fail_msg(), which is undefined behavior from
inside an atexit handler.  A non-root run hits it directly - the restore
write fails the same way the write that triggered the exit did.  Restore
with plain open()/write(), best effort.

Link: https://lore.kernel.org/20260825085756.63030-4-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-soft-offline.c |   49 ++++++------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c~selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline
+++ a/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -11,6 +11,7 @@
 
 #define _GNU_SOURCE
 #include <errno.h>
+#include <fcntl.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
@@ -23,6 +24,7 @@
 #include <sys/types.h>
 
 #include "kselftest.h"
+#include "vm_util.h"
 #include "hugepage_settings.h"
 
 #ifndef MADV_SOFT_OFFLINE
@@ -31,6 +33,8 @@
 
 #define EPREFIX " !!! "
 
+#define ENABLE_SOFT_OFFLINE_PATH "/proc/sys/vm/enable_soft_offline"
+
 static int do_soft_offline(int fd, size_t len, int expect_errno)
 {
 	char *filemap = NULL;
@@ -77,26 +81,29 @@ untruncate:
 	return ret;
 }
 
-static int set_enable_soft_offline(int value)
-{
-	char cmd[256] = {0};
-	FILE *cmdfile = NULL;
-
-	if (value != 0 && value != 1)
-		return -EINVAL;
+static unsigned long orig_enable_soft_offline = -1UL;
 
-	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
-	cmdfile = popen(cmd, "r");
+/*
+ * Runs from an atexit handler, so it must not call anything that
+ * exits on failure: write_num() would re-enter exit() through
+ * ksft_exit_fail_msg().
+ */
+static void restore_enable_soft_offline(void)
+{
+	char buf[24];
+	int fd, len;
 
-	if (cmdfile)
-		ksft_print_msg("enable_soft_offline => %d\n", value);
-	else {
-		ksft_perror(EPREFIX "failed to set enable_soft_offline");
-		return errno;
-	}
+	if (orig_enable_soft_offline == -1UL)
+		return;
 
-	pclose(cmdfile);
-	return 0;
+	len = snprintf(buf, sizeof(buf), "%lu", orig_enable_soft_offline);
+	fd = open(ENABLE_SOFT_OFFLINE_PATH, O_WRONLY);
+	if (fd < 0)
+		return;
+	if (write(fd, buf, len) != len)
+		ksft_print_msg("failed to restore enable_soft_offline: %s\n",
+			       strerror(errno));
+	close(fd);
 }
 
 static int create_hugetlbfs_file(struct statfs *file_stat)
@@ -145,10 +152,7 @@ static void test_soft_offline_common(int
 	hugepagesize_kb = file_stat.f_bsize / 1024;
 	ksft_print_msg("Hugepagesize is %ldkB\n", hugepagesize_kb);
 
-	if (set_enable_soft_offline(enable_soft_offline) != 0) {
-		close(fd);
-		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
-	}
+	write_num(ENABLE_SOFT_OFFLINE_PATH, enable_soft_offline);
 
 	nr_hugepages_before = hugetlb_nr_default_pages();
 
@@ -192,6 +196,9 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(2);
 
+	orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);
+	atexit(restore_enable_soft_offline);
+
 	test_soft_offline_common(1);
 	test_soft_offline_common(0);
 
_

Patches currently in -mm which might be from husong@kylinos.cn are

selftests-mm-emit-tap-header-in-uffd-wp-mremap.patch
selftests-mm-emit-tap-header-and-use-tap-skip-in-mremap_test.patch
selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline.patch

