From: akpm@linux-foundation.org
Subject: + selftests-expanding-more-mlock-selftest.patch added to -mm tree
Date: Thu, 08 Sep 2016 15:38:19 -0700
Message-ID: <57d1e85b.6ibq109xcHkAfCd7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45791 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbcIHWiV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 18:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.guo.simon@gmail.com, aarcange@redhat.com, emunson@akamai.com, geert@linux-m68k.org, kirill.shutemov@linux.intel.com, klimov.linux@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, mike.kravetz@oracle.com, rientjes@google.com, shuah@kernel.org, treding@nvidia.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: expanding more mlock selftest
has been added to the -mm tree.  Its filename is
     selftests-expanding-more-mlock-selftest.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-expanding-more-mlock-selftest.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-expanding-more-mlock-selftest.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Simon Guo <wei.guo.simon@gmail.com>
Subject: selftests: expanding more mlock selftest

This patch will randomly perform mlock/mlock2 on a given memory region,
and verify the RLIMIT_MEMLOCK limitation works properly.

Suggested-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/1473325970-11393-4-git-send-email-wei.guo.simon@gmail.com
Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Simon Guo <wei.guo.simon@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Alexey Klimov <klimov.linux@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile               |    4 
 tools/testing/selftests/vm/mlock-intersect-test.c |   76 ---
 tools/testing/selftests/vm/mlock-random-test.c    |  293 ++++++++++++
 3 files changed, 295 insertions(+), 78 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~selftests-expanding-more-mlock-selftest tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~selftests-expanding-more-mlock-selftest
+++ a/tools/testing/selftests/vm/Makefile
@@ -10,7 +10,7 @@ BINARIES += on-fault-limit
 BINARIES += thuge-gen
 BINARIES += transhuge-stress
 BINARIES += userfaultfd
-BINARIES += mlock-intersect-test
+BINARIES += mlock-random-test
 
 all: $(BINARIES)
 %: %.c
@@ -18,7 +18,7 @@ all: $(BINARIES)
 userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
 	$(CC) $(CFLAGS) -O2 -o $@ $< -lpthread
 
-mlock-intersect-test: mlock-intersect-test.c
+mlock-random-test: mlock-random-test.c
 	$(CC) $(CFLAGS) -o $@ $< -lcap
 
 ../../../../usr/include/linux/kernel.h:
diff -puN tools/testing/selftests/vm/mlock-intersect-test.c~selftests-expanding-more-mlock-selftest /dev/null
--- a/tools/testing/selftests/vm/mlock-intersect-test.c
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * It tests the duplicate mlock result:
- * - the ulimit of lock page is 64k
- * - allocate address area 64k starting from p
- * - mlock   [p -- p + 30k]
- * - Then mlock address  [ p -- p + 40k ]
- *
- * It should succeed since totally we locked
- * 40k < 64k limitation.
- *
- * It should not be run with CAP_IPC_LOCK.
- */
-#include <stdlib.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/resource.h>
-#include <sys/capability.h>
-#include <sys/mman.h>
-#include "mlock2.h"
-
-int main(int argc, char **argv)
-{
-	struct rlimit new;
-	char *p = NULL;
-	cap_t cap = cap_init();
-	int i;
-
-	/* drop capabilities including CAP_IPC_LOCK */
-	if (cap_set_proc(cap))
-		return -1;
-
-	/* set mlock limits to 64k */
-	new.rlim_cur = 65536;
-	new.rlim_max = 65536;
-	setrlimit(RLIMIT_MEMLOCK, &new);
-
-	/* test VM_LOCK */
-	p = malloc(1024 * 64);
-	if (mlock(p, 1024 * 30)) {
-		printf("mlock() 30k return failure.\n");
-		return -1;
-	}
-	for (i = 0; i < 10; i++) {
-		if (mlock(p, 1024 * 40)) {
-			printf("mlock() #%d 40k returns failure.\n", i);
-			return -1;
-		}
-	}
-	for (i = 0; i < 10; i++) {
-		if (mlock2_(p, 1024 * 40, MLOCK_ONFAULT)) {
-			printf("mlock2_() #%d 40k returns failure.\n", i);
-			return -1;
-		}
-	}
-	free(p);
-
-	/* Test VM_LOCKONFAULT */
-	p = malloc(1024 * 64);
-	if (mlock2_(p, 1024 * 30, MLOCK_ONFAULT)) {
-		printf("mlock2_() 30k return failure.\n");
-		return -1;
-	}
-	for (i = 0; i < 10; i++) {
-		if (mlock2_(p, 1024 * 40, MLOCK_ONFAULT)) {
-			printf("mlock2_() #%d 40k returns failure.\n", i);
-			return -1;
-		}
-	}
-	for (i = 0; i < 10; i++) {
-		if (mlock(p, 1024 * 40)) {
-			printf("mlock() #%d 40k returns failure.\n", i);
-			return -1;
-		}
-	}
-	return 0;
-}
diff -puN /dev/null tools/testing/selftests/vm/mlock-random-test.c
--- /dev/null
+++ a/tools/testing/selftests/vm/mlock-random-test.c
@@ -0,0 +1,293 @@
+/*
+ * It tests the mlock/mlock2() when they are invoked
+ * on randomly memory region.
+ */
+#include <unistd.h>
+#include <sys/resource.h>
+#include <sys/capability.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+#include <string.h>
+#include <sys/ipc.h>
+#include <sys/shm.h>
+#include <time.h>
+#include "mlock2.h"
+
+#define CHUNK_UNIT (128 * 1024)
+#define MLOCK_RLIMIT_SIZE (CHUNK_UNIT * 2)
+#define MLOCK_WITHIN_LIMIT_SIZE CHUNK_UNIT
+#define MLOCK_OUTOF_LIMIT_SIZE (CHUNK_UNIT * 3)
+
+#define TEST_LOOP 100
+#define PAGE_ALIGN(size, ps) (((size) + ((ps) - 1)) & ~((ps) - 1))
+
+int set_cap_limits(rlim_t max)
+{
+	struct rlimit new;
+	cap_t cap = cap_init();
+
+	new.rlim_cur = max;
+	new.rlim_max = max;
+	if (setrlimit(RLIMIT_MEMLOCK, &new)) {
+		perror("setrlimit() returns error\n");
+		return -1;
+	}
+
+	/* drop capabilities including CAP_IPC_LOCK */
+	if (cap_set_proc(cap)) {
+		perror("cap_set_proc() returns error\n");
+		return -2;
+	}
+
+	return 0;
+}
+
+int get_proc_locked_vm_size(void)
+{
+	FILE *f;
+	int ret = -1;
+	char line[1024] = {0};
+	unsigned long lock_size = 0;
+
+	f = fopen("/proc/self/status", "r");
+	if (!f) {
+		perror("fopen");
+		return -1;
+	}
+
+	while (fgets(line, 1024, f)) {
+		if (strstr(line, "VmLck")) {
+			ret = sscanf(line, "VmLck:\t%8lu kB", &lock_size);
+			if (ret <= 0) {
+				printf("sscanf() on VmLck error: %s: %d\n",
+						line, ret);
+				fclose(f);
+				return -1;
+			}
+			fclose(f);
+			return (int)(lock_size << 10);
+		}
+	}
+
+	perror("cann't parse VmLck in /proc/self/status\n");
+	fclose(f);
+	return -1;
+}
+
+/*
+ * Get the MMUPageSize of the memory region including input
+ * address from proc file.
+ *
+ * return value: on error case, 0 will be returned.
+ * Otherwise the page size(in bytes) is returned.
+ */
+int get_proc_page_size(unsigned long addr)
+{
+	FILE *smaps;
+	char *line;
+	unsigned long mmupage_size = 0;
+	size_t size;
+
+	smaps = seek_to_smaps_entry(addr);
+	if (!smaps) {
+		printf("Unable to parse /proc/self/smaps\n");
+		return 0;
+	}
+
+	while (getline(&line, &size, smaps) > 0) {
+		if (!strstr(line, "MMUPageSize")) {
+			free(line);
+			line = NULL;
+			size = 0;
+			continue;
+		}
+
+		/* found the MMUPageSize of this section */
+		if (sscanf(line, "MMUPageSize:    %8lu kB",
+					&mmupage_size) < 1) {
+			printf("Unable to parse smaps entry for Size:%s\n",
+					line);
+			break;
+		}
+
+	}
+	free(line);
+	if (smaps)
+		fclose(smaps);
+	return mmupage_size << 10;
+}
+
+/*
+ * Test mlock/mlock2() on provided memory chunk.
+ * It expects the mlock/mlock2() to be successful (within rlimit)
+ *
+ * With allocated memory chunk [p, p + alloc_size), this
+ * test will choose start/len randomly to perform mlock/mlock2
+ * [start, start +  len] memory range. The range is within range
+ * of the allocated chunk.
+ *
+ * The memory region size alloc_size is within the rlimit.
+ * So we always expect a success of mlock/mlock2.
+ *
+ * VmLck is assumed to be 0 before this test.
+ *
+ *    return value: 0 - success
+ *    else: failure
+ */
+int test_mlock_within_limit(char *p, int alloc_size)
+{
+	int i;
+	int ret = 0;
+	int locked_vm_size = 0;
+	struct rlimit cur;
+	int page_size = 0;
+
+	getrlimit(RLIMIT_MEMLOCK, &cur);
+	if (cur.rlim_cur < alloc_size) {
+		printf("alloc_size[%d] < %u rlimit,lead to mlock failure\n",
+				alloc_size, (unsigned int)cur.rlim_cur);
+		return -1;
+	}
+
+	srand(time(NULL));
+	for (i = 0; i < TEST_LOOP; i++) {
+		/*
+		 * - choose mlock/mlock2 randomly
+		 * - choose lock_size randomly but lock_size < alloc_size
+		 * - choose start_offset randomly but p+start_offset+lock_size
+		 *   < p+alloc_size
+		 */
+		int is_mlock = !!(rand() % 2);
+		int lock_size = rand() % alloc_size;
+		int start_offset = rand() % (alloc_size - lock_size);
+
+		if (is_mlock)
+			ret = mlock(p + start_offset, lock_size);
+		else
+			ret = mlock2_(p + start_offset, lock_size,
+				       MLOCK_ONFAULT);
+
+		if (ret) {
+			printf("%s() failure at |%p(%d)| mlock:|%p(%d)|\n",
+					is_mlock ? "mlock" : "mlock2",
+					p, alloc_size,
+					p + start_offset, lock_size);
+			return ret;
+		}
+	}
+
+	/*
+	 * Check VmLck left by the tests.
+	 */
+	locked_vm_size = get_proc_locked_vm_size();
+	page_size = get_proc_page_size((unsigned long)p);
+	if (page_size == 0) {
+		printf("cannot get proc MMUPageSize\n");
+		return -1;
+	}
+
+	if (locked_vm_size > PAGE_ALIGN(alloc_size, page_size) + page_size) {
+		printf("test_mlock_within_limit() left VmLck:%d on %d chunk\n",
+				locked_vm_size, alloc_size);
+		return -1;
+	}
+
+	return 0;
+}
+
+
+/*
+ * We expect the mlock/mlock2() to be fail (outof limitation)
+ *
+ * With allocated memory chunk [p, p + alloc_size), this
+ * test will randomly choose start/len and perform mlock/mlock2
+ * on [start, start+len] range.
+ *
+ * The memory region size alloc_size is above the rlimit.
+ * And the len to be locked is higher than rlimit.
+ * So we always expect a failure of mlock/mlock2.
+ * No locked page number should be increased as a side effect.
+ *
+ *    return value: 0 - success
+ *    else: failure
+ */
+int test_mlock_outof_limit(char *p, int alloc_size)
+{
+	int i;
+	int ret = 0;
+	int locked_vm_size = 0, old_locked_vm_size = 0;
+	struct rlimit cur;
+
+	getrlimit(RLIMIT_MEMLOCK, &cur);
+	if (cur.rlim_cur >= alloc_size) {
+		printf("alloc_size[%d] >%u rlimit, violates test condition\n",
+				alloc_size, (unsigned int)cur.rlim_cur);
+		return -1;
+	}
+
+	old_locked_vm_size = get_proc_locked_vm_size();
+	srand(time(NULL));
+	for (i = 0; i < TEST_LOOP; i++) {
+		int is_mlock = !!(rand() % 2);
+		int lock_size = (rand() % (alloc_size - cur.rlim_cur))
+			+ cur.rlim_cur;
+		int start_offset = rand() % (alloc_size - lock_size);
+
+		if (is_mlock)
+			ret = mlock(p + start_offset, lock_size);
+		else
+			ret = mlock2_(p + start_offset, lock_size,
+					MLOCK_ONFAULT);
+		if (ret == 0) {
+			printf("%s() succeeds? on %p(%d) mlock%p(%d)\n",
+					is_mlock ? "mlock" : "mlock2",
+					p, alloc_size,
+					p + start_offset, lock_size);
+			return -1;
+		}
+	}
+
+	locked_vm_size = get_proc_locked_vm_size();
+	if (locked_vm_size != old_locked_vm_size) {
+		printf("tests leads to new mlocked page: old[%d], new[%d]\n",
+				old_locked_vm_size,
+				locked_vm_size);
+		return -1;
+	}
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	char *p = NULL;
+	int ret = 0;
+
+	if (set_cap_limits(MLOCK_RLIMIT_SIZE))
+		return -1;
+
+	p = malloc(MLOCK_WITHIN_LIMIT_SIZE);
+	if (p == NULL) {
+		perror("malloc() failure\n");
+		return -1;
+	}
+	ret = test_mlock_within_limit(p, MLOCK_WITHIN_LIMIT_SIZE);
+	if (ret)
+		return ret;
+	munlock(p, MLOCK_WITHIN_LIMIT_SIZE);
+	free(p);
+
+
+	p = malloc(MLOCK_OUTOF_LIMIT_SIZE);
+	if (p == NULL) {
+		perror("malloc() failure\n");
+		return -1;
+	}
+	ret = test_mlock_outof_limit(p, MLOCK_OUTOF_LIMIT_SIZE);
+	if (ret)
+		return ret;
+	munlock(p, MLOCK_OUTOF_LIMIT_SIZE);
+	free(p);
+
+	return 0;
+}
_

Patches currently in -mm which might be from wei.guo.simon@gmail.com are

mm-mlock-check-against-vma-for-actual-mlock-size.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix-2.patch
mm-mlock-avoid-increase-mm-locked_vm-on-mlock-when-already-mlock2mlock_onfault.patch
selftest-split-mlock2_-funcs-into-separate-mlock2h.patch
selftests-vm-add-test-for-mlock-when-areas-are-intersected.patch
selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc.patch
selftests-expanding-more-mlock-selftest.patch

