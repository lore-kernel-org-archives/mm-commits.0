From: akpm@linux-foundation.org
Subject: + selftests-vm-add-tests-for-lock-on-fault-v4.patch added to -mm
 tree
Date: Tue, 21 Jul 2015 13:55:52 -0700
Message-ID: <55aeb1d8.bzCcSIqSh8wwg/Qw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbbGUUzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 16:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, corbet@lwn.net, mhocko@suse.cz, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-vm-add-tests-for-lock-on-fault-v4
has been added to the -mm tree.  Its filename is
     selftests-vm-add-tests-for-lock-on-fault-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-add-tests-for-lock-on-fault-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-add-tests-for-lock-on-fault-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: selftests-vm-add-tests-for-lock-on-fault-v4

Changes from V3:
Add tests for new mlock2 family of system calls

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile        |    1 
 tools/testing/selftests/vm/lock-on-fault.c |    6 
 tools/testing/selftests/vm/mlock2-tests.c  |  617 +++++++++++++++++++
 tools/testing/selftests/vm/run_vmtests     |   11 
 4 files changed, 633 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~selftests-vm-add-tests-for-lock-on-fault-v4 tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-add-tests-for-lock-on-fault-v4
+++ a/tools/testing/selftests/vm/Makefile
@@ -7,6 +7,7 @@ BINARIES += hugepage-shm
 BINARIES += hugetlbfstest
 BINARIES += lock-on-fault
 BINARIES += map_hugetlb
+BINARIES += mlock2-tests
 BINARIES += on-fault-limit
 BINARIES += thuge-gen
 BINARIES += transhuge-stress
diff -puN tools/testing/selftests/vm/lock-on-fault.c~selftests-vm-add-tests-for-lock-on-fault-v4 tools/testing/selftests/vm/lock-on-fault.c
--- a/tools/testing/selftests/vm/lock-on-fault.c~selftests-vm-add-tests-for-lock-on-fault-v4
+++ a/tools/testing/selftests/vm/lock-on-fault.c
@@ -4,6 +4,7 @@
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <errno.h>
 
 struct vm_boundaries {
 	unsigned long start;
@@ -144,7 +145,7 @@ static int test_mmap(int flags)
 	}
 
 	/* page1_flags should be present */
-	if (page1_flags & PRESENT_BIT == 0) {
+	if ((page1_flags & PRESENT_BIT) == 0) {
 		printf("page map says 0x%lx\n", page1_flags);
 		printf("present is    0x%lx\n", PRESENT_BIT);
 		return 1;
@@ -154,7 +155,7 @@ static int test_mmap(int flags)
 
 	/* page1_flags now contains the entry from kpageflags for the first
 	 * page, the unevictable bit should be set */
-	if (page1_flags & UNEVICTABLE_BIT == 0) {
+	if ((page1_flags & UNEVICTABLE_BIT) == 0) {
 		printf("kpageflags says 0x%lx\n", page1_flags);
 		printf("unevictable is  0x%lx\n", UNEVICTABLE_BIT);
 		return 1;
@@ -340,3 +341,4 @@ int main(int argc, char **argv)
 	ret += test_mlockall(test_vma_management);
 	return ret;
 }
+
diff -puN /dev/null tools/testing/selftests/vm/mlock2-tests.c
--- /dev/null
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -0,0 +1,617 @@
+#include <sys/mman.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <errno.h>
+#include <stdbool.h>
+
+#ifndef MLOCK_LOCK
+#define MLOCK_LOCK 1
+#endif
+
+#ifndef MLOCK_ONFAULT
+#define MLOCK_ONFAULT 2
+#endif
+
+#ifndef MCL_ONFAULT
+#define MCL_ONFAULT (MCL_FUTURE << 1)
+#endif
+
+static int mlock2_(void *start, size_t len, int flags)
+{
+#ifdef __NR_mlock2
+	return syscall(__NR_mlock2, start, len, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+
+static int munlock2_(void *start, size_t len, int flags)
+{
+#ifdef __NR_munlock2
+	return syscall(__NR_munlock2, start, len, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+
+static int munlockall2_(int flags)
+{
+#ifdef __NR_munlockall2
+	return syscall(__NR_munlockall2, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+
+static unsigned long get_pageflags(unsigned long addr)
+{
+	FILE *file;
+	unsigned long pfn;
+	unsigned long offset;
+
+	file = fopen("/proc/self/pagemap", "r");
+	if (!file) {
+		perror("fopen pagemap");
+		_exit(1);
+	}
+
+	offset = addr / getpagesize() * sizeof(unsigned long);
+	if (fseek(file, offset, SEEK_SET)) {
+		perror("fseek pagemap");
+		_exit(1);
+	}
+
+	if (fread(&pfn, sizeof(unsigned long), 1, file) != 1) {
+		perror("fread pagemap");
+		_exit(1);
+	}
+
+	fclose(file);
+	return pfn;
+}
+
+static unsigned long get_kpageflags(unsigned long pfn)
+{
+	unsigned long flags;
+	FILE *file;
+
+	file = fopen("/proc/kpageflags", "r");
+	if (!file) {
+		perror("fopen kpageflags");
+		_exit(1);
+	}
+
+	if (fseek(file, pfn * sizeof(unsigned long), SEEK_SET)) {
+		perror("fseek kpageflags");
+		_exit(1);
+	}
+
+	if (fread(&flags, sizeof(unsigned long), 1, file) != 1) {
+		perror("fread kpageflags");
+		_exit(1);
+	}
+
+	fclose(file);
+	return flags;
+}
+
+#define VMFLAGS "VmFlags:"
+
+static bool find_flag(FILE *file, const char *vmflag)
+{
+	char *line = NULL;
+	char *flags;
+	size_t size = 0;
+	bool ret = false;
+
+	while (getline(&line, &size, file) > 0) {
+		if (!strstr(line, VMFLAGS)) {
+			free(line);
+			line = NULL;
+			size = 0;
+			continue;
+		}
+
+		flags = line + strlen(VMFLAGS);
+		ret = (strstr(flags, vmflag) != NULL);
+		goto out;
+	}
+
+out:
+	free(line);
+	return ret;
+}
+
+static bool is_vmflag_set(unsigned long addr, const char *vmflag)
+{
+	FILE *file;
+	char *line = NULL;
+	size_t size = 0;
+	bool ret = false;
+	unsigned long start, end;
+	char perms[5];
+	unsigned long offset;
+	char dev[32];
+	unsigned long inode;
+	char path[BUFSIZ];
+
+	file = fopen("/proc/self/smaps", "r");
+	if (!file) {
+		perror("fopen smaps");
+		_exit(1);
+	}
+
+	while (getline(&line, &size, file) > 0) {
+		if (sscanf(line, "%lx-%lx %s %lx %s %lu %s\n",
+			   &start, &end, perms, &offset, dev, &inode, path) < 6)
+			goto next;
+
+		if (start <= addr && addr < end) {
+			ret = find_flag(file, vmflag);
+			goto out;
+		}
+
+next:
+		free(line);
+		line = NULL;
+		size = 0;
+	}
+
+out:
+	free(line);
+	fclose(file);
+	return ret;
+}
+
+#define PRESENT_BIT     0x8000000000000000
+#define PFN_MASK        0x007FFFFFFFFFFFFF
+#define UNEVICTABLE_BIT (1UL << 18)
+
+#define LOCKED "lo"
+#define LOCKEDONFAULT "lf"
+
+static int lock_check(char *map)
+{
+	unsigned long page1_flags;
+	unsigned long page2_flags;
+	unsigned long page_size = getpagesize();
+
+	page1_flags = get_pageflags((unsigned long)map);
+	page2_flags = get_pageflags((unsigned long)map + page_size);
+
+	/* Both pages should be present */
+	if (((page1_flags & PRESENT_BIT) == 0) ||
+	    ((page2_flags & PRESENT_BIT) == 0)) {
+		printf("Failed to make both pages present\n");
+		return 1;
+	}
+
+	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
+	page2_flags = get_kpageflags(page2_flags & PFN_MASK);
+
+	/* Both pages should be unevictable */
+	if (((page1_flags & UNEVICTABLE_BIT) == 0) ||
+	    ((page2_flags & UNEVICTABLE_BIT) == 0)) {
+		printf("Failed to make both pages unevictable\n");
+		return 1;
+	}
+
+	if (!is_vmflag_set((unsigned long)map, LOCKED) ||
+	    !is_vmflag_set((unsigned long)map + page_size, LOCKED)) {
+		printf("VMA flag %s is missing\n", LOCKED);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int unlock_lock_check(char *map)
+{
+	unsigned long page1_flags;
+	unsigned long page2_flags;
+	unsigned long page_size = getpagesize();
+
+	page1_flags = get_pageflags((unsigned long)map);
+	page2_flags = get_pageflags((unsigned long)map + page_size);
+	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
+	page2_flags = get_kpageflags(page2_flags & PFN_MASK);
+
+	if ((page1_flags & UNEVICTABLE_BIT) || (page2_flags & UNEVICTABLE_BIT)) {
+		printf("A page is still marked unevictable after unlock\n");
+		return 1;
+	}
+
+	if (is_vmflag_set((unsigned long)map, LOCKED) ||
+	    is_vmflag_set((unsigned long)map + page_size, LOCKED)) {
+		printf("VMA flag %s is still set after unlock\n", LOCKED);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int test_mlock_lock()
+{
+	char *map;
+	int ret = 1;
+	unsigned long page_size = getpagesize();
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (map == MAP_FAILED) {
+		perror("test_mlock_locked mmap");
+		goto out;
+	}
+
+	if (mlock2_(map, 2 * page_size, MLOCK_LOCK)) {
+		if (errno == ENOSYS) {
+			printf("Cannot call new mlock family, skipping test\n");
+			_exit(0);
+		}
+		perror("mlock2(MLOCK_LOCK)");
+		goto unmap;
+	}
+
+	if (lock_check(map))
+		goto unmap;
+
+	/* Now clear the MLOCK_LOCK flag and recheck attributes */
+	if (munlock2_(map, 2 * page_size, MLOCK_LOCK)) {
+		if (errno == ENOSYS) {
+			printf("Cannot call new mlock family, skipping test\n");
+			_exit(0);
+		}
+		perror("munlock2(MLOCK_LOCK)");
+		goto unmap;
+	}
+
+	ret = unlock_lock_check(map);
+
+unmap:
+	munmap(map, 2 * page_size);
+out:
+	return ret;
+}
+
+static int onfault_check(char *map)
+{
+	unsigned long page1_flags;
+	unsigned long page2_flags;
+	unsigned long page_size = getpagesize();
+
+	page1_flags = get_pageflags((unsigned long)map);
+	page2_flags = get_pageflags((unsigned long)map + page_size);
+
+	/* Neither page should be present */
+	if ((page1_flags & PRESENT_BIT) || (page2_flags & PRESENT_BIT)) {
+		printf("Pages were made present by MLOCK_ONFAULT\n");
+		return 1;
+	}
+
+	*map = 'a';
+	page1_flags = get_pageflags((unsigned long)map);
+	page2_flags = get_pageflags((unsigned long)map + page_size);
+
+	/* Only page 1 should be present */
+	if ((page1_flags & PRESENT_BIT) == 0) {
+		printf("Page 1 is not present after fault\n");
+		return 1;
+	} else if (page2_flags & PRESENT_BIT) {
+		printf("Page 2 was made present\n");
+		return 1;
+	}
+
+	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
+
+	/* Page 1 should be unevictable */
+	if ((page1_flags & UNEVICTABLE_BIT) == 0) {
+		printf("Failed to make faulted page unevictable\n");
+		return 1;
+	}
+
+	if (!is_vmflag_set((unsigned long)map, LOCKEDONFAULT) ||
+	    !is_vmflag_set((unsigned long)map + page_size, LOCKEDONFAULT)) {
+		printf("VMA flag %s is missing\n", LOCKEDONFAULT);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int unlock_onfault_check(char *map)
+{
+	unsigned long page1_flags;
+	unsigned long page2_flags;
+	unsigned long page_size = getpagesize();
+
+	page1_flags = get_pageflags((unsigned long)map);
+	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
+
+	if (page1_flags & UNEVICTABLE_BIT) {
+		printf("Page 1 is still marked unevictable after unlock\n");
+		return 1;
+	}
+
+	if (is_vmflag_set((unsigned long)map, LOCKEDONFAULT) ||
+	    is_vmflag_set((unsigned long)map + page_size, LOCKEDONFAULT)) {
+		printf("VMA flag %s is still set after unlock\n", LOCKEDONFAULT);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int test_mlock_onfault()
+{
+	char *map;
+	int ret = 1;
+	unsigned long page_size = getpagesize();
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (map == MAP_FAILED) {
+		perror("test_mlock_locked mmap");
+		goto out;
+	}
+
+	if (mlock2_(map, 2 * page_size, MLOCK_ONFAULT)) {
+		if (errno == ENOSYS) {
+			printf("Cannot call new mlock family, skipping test\n");
+			_exit(0);
+		}
+		perror("mlock2(MLOCK_ONFAULT)");
+		goto unmap;
+	}
+
+	if (onfault_check(map))
+		goto unmap;
+
+	/* Now clear the MLOCK_ONFAULT flag and recheck attributes */
+	if (munlock2_(map, 2 * page_size, MLOCK_ONFAULT)) {
+		if (errno == ENOSYS) {
+			printf("Cannot call new mlock family, skipping test\n");
+			_exit(0);
+		}
+		perror("munlock2(MLOCK_LOCK)");
+		goto unmap;
+	}
+
+	ret = unlock_onfault_check(map);
+unmap:
+	munmap(map, 2 * page_size);
+out:
+	return ret;
+}
+
+static int test_lock_onfault_of_present()
+{
+	char *map;
+	int ret = 1;
+	unsigned long page1_flags;
+	unsigned long page2_flags;
+	unsigned long page_size = getpagesize();
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (map == MAP_FAILED) {
+		perror("test_mlock_locked mmap");
+		goto out;
+	}
+
+	*map = 'a';
+
+	if (mlock2_(map, 2 * page_size, MLOCK_ONFAULT)) {
+		if (errno == ENOSYS) {
+			printf("Cannot call new mlock family, skipping test\n");
+			_exit(0);
+		}
+		perror("mlock2(MLOCK_ONFAULT)");
+		goto unmap;
+	}
+
+	page1_flags = get_pageflags((unsigned long)map);
+	page2_flags = get_pageflags((unsigned long)map + page_size);
+	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
+	page2_flags = get_kpageflags(page2_flags & PFN_MASK);
+
+	/* Page 1 should be unevictable */
+	if ((page1_flags & UNEVICTABLE_BIT) == 0) {
+		printf("Failed to make present page unevictable\n");
+		goto unmap;
+	}
+
+	if (!is_vmflag_set((unsigned long)map, LOCKEDONFAULT) ||
+	    !is_vmflag_set((unsigned long)map + page_size, LOCKEDONFAULT)) {
+		printf("VMA flag %s is missing for one of the pages\n", LOCKEDONFAULT);
+		goto unmap;
+	}
+	ret = 0;
+unmap:
+	munmap(map, 2 * page_size);
+out:
+	return ret;
+}
+
+static int test_munlock_mismatch()
+{
+	char *map;
+	int ret = 1;
+	unsigned long page1_flags;
+	unsigned long page2_flags;
+	unsigned long page_size = getpagesize();
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (map == MAP_FAILED) {
+		perror("test_mlock_locked mmap");
+		goto out;
+	}
+
+	if (mlock2_(map, 2 * page_size, MLOCK_LOCK)) {
+		if (errno == ENOSYS) {
+			printf("Cannot call new mlock family, skipping test\n");
+			_exit(0);
+		}
+		perror("mlock2(MLOCK_LOCK)");
+		goto unmap;
+	}
+
+	page1_flags = get_pageflags((unsigned long)map);
+	page2_flags = get_pageflags((unsigned long)map + page_size);
+
+	/* Both pages should be present */
+	if (((page1_flags & PRESENT_BIT) == 0) ||
+	    ((page2_flags & PRESENT_BIT) == 0)) {
+		printf("Failed to make both pages present\n");
+		goto unmap;
+	}
+
+	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
+	page2_flags = get_kpageflags(page2_flags & PFN_MASK);
+
+	/* Both pages should be unevictable */
+	if (((page1_flags & UNEVICTABLE_BIT) == 0) ||
+	    ((page2_flags & UNEVICTABLE_BIT) == 0)) {
+		printf("Failed to make both pages unevictable\n");
+		goto unmap;
+	}
+
+	if (!is_vmflag_set((unsigned long)map, LOCKED) ||
+	    !is_vmflag_set((unsigned long)map + page_size, LOCKED)) {
+		printf("VMA flag %s is missing\n", LOCKED);
+		goto unmap;
+	}
+
+	/* Now clear the MLOCK_ONFAULT flag and recheck attributes */
+	if (munlock2_(map, 2 * page_size, MLOCK_ONFAULT)) {
+		if (errno == ENOSYS) {
+			printf("Cannot call new mlock family, skipping test\n");
+			_exit(0);
+		}
+		perror("munlock2(MLOCK_ONFAULT)");
+		goto unmap;
+	}
+
+	page1_flags = get_pageflags((unsigned long)map);
+	page2_flags = get_pageflags((unsigned long)map + page_size);
+	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
+	page2_flags = get_kpageflags(page2_flags & PFN_MASK);
+
+	if ((page1_flags & UNEVICTABLE_BIT) == 0 ||
+	    (page2_flags & UNEVICTABLE_BIT) == 0) {
+		printf("Both pages should still be unevictable but are not\n");
+		goto unmap;
+	}
+
+	if (!is_vmflag_set((unsigned long)map, LOCKED) ||
+	    !is_vmflag_set((unsigned long)map + page_size, LOCKED)) {
+		printf("VMA flag %s is not set set after unlock\n", LOCKED);
+		goto unmap;
+	}
+
+	ret = 0;
+unmap:
+	munmap(map, 2 * page_size);
+out:
+	return ret;
+
+}
+
+static int test_munlockall()
+{
+	char *map;
+	int ret = 1;
+	unsigned long page1_flags;
+	unsigned long page2_flags;
+	unsigned long page_size = getpagesize();
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+
+	if (map == MAP_FAILED) {
+		perror("test_munlockall mmap");
+		goto out;
+	}
+
+	if (mlockall(MCL_CURRENT)) {
+		perror("mlockall(MCL_CURRENT)");
+		goto out;
+	}
+
+	if (lock_check(map))
+		goto unmap;
+
+	if (munlockall2_(MCL_CURRENT)) {
+		perror("munlockall2(MCL_CURRENT)");
+		goto unmap;
+	}
+
+	if (unlock_lock_check(map))
+		goto unmap;
+
+	munmap(map, 2 * page_size);
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+
+	if (map == MAP_FAILED) {
+		perror("test_munlockall second mmap");
+		goto out;
+	}
+
+	if (mlockall(MCL_ONFAULT)) {
+		perror("mlockall(MCL_ONFAULT)");
+		goto unmap;
+	}
+
+	if (onfault_check(map))
+		goto unmap;
+
+	if (munlockall2_(MCL_ONFAULT)) {
+		perror("munlockall2(MCL_ONFAULT)");
+		goto unmap;
+	}
+
+	if (unlock_onfault_check(map))
+		goto unmap;
+
+	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
+		perror("mlockall(MCL_CURRENT | MCL_FUTURE)");
+		goto out;
+	}
+
+	if (lock_check(map))
+		goto unmap;
+
+	if (munlockall2_(MCL_FUTURE | MCL_ONFAULT)) {
+		perror("munlockall2(MCL_FUTURE | MCL_ONFAULT)");
+		goto unmap;
+	}
+
+	ret = lock_check(map);
+
+unmap:
+	munmap(map, 2 * page_size);
+out:
+	munlockall2_(MCL_CURRENT | MCL_FUTURE | MCL_ONFAULT);
+	return ret;
+}
+
+int main(char **argv, int argc)
+{
+	int ret = 0;
+	ret += test_mlock_lock();
+	ret += test_mlock_onfault();
+	ret += test_munlockall();
+	ret += test_munlock_mismatch();
+	ret += test_lock_onfault_of_present();
+	return ret;
+}
+
diff -puN tools/testing/selftests/vm/run_vmtests~selftests-vm-add-tests-for-lock-on-fault-v4 tools/testing/selftests/vm/run_vmtests
--- a/tools/testing/selftests/vm/run_vmtests~selftests-vm-add-tests-for-lock-on-fault-v4
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -135,4 +135,15 @@ else
 	echo "[PASS]"
 fi
 
+echo "--------------------"
+echo "running mlock2-tests"
+echo "--------------------"
+./mlock2-tests
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
 exit $exitcode
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
mm-gup-add-mm_lock_present.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v4.patch

