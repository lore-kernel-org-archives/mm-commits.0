Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD64C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24466619D8
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhCaFdX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 01:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233469AbhCaFdQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 01:33:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 184CE619D6;
        Wed, 31 Mar 2021 05:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617168792;
        bh=pESjC6V5kMRBKpfyX5Dwe99i3twQE7qC3s6arHcUpAY=;
        h=Date:From:To:Subject:From;
        b=j04Reca/QZggc61Pd0/GWJEY9dFYk1QCgaNAiG6JRRJkbEbyp1r0BVNlBbhl33FdP
         oivR/PtHv25aMThjhAZ+7YfrFLGrY36iLBXSqqBS3hgkLqGjx/V3tlXqbNi6U2RETw
         HqLmrZyUZ98UlwgIkR0Oym0EGiHPZbfrRNqRLPio=
Date:   Tue, 30 Mar 2021 22:33:11 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, mika.penttila@nextfour.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        sandipan@linux.ibm.com, shuah@kernel.org, shy828301@gmail.com,
        ziy@nvidia.com
Subject:  +
 mm-huge_memory-a-new-debugfs-interface-for-splitting-thp-tests.patch added
 to -mm tree
Message-ID: <20210331053311.hCdDuagm_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: a new debugfs interface for splitting THP tests
has been added to the -mm tree.  Its filename is
     mm-huge_memory-a-new-debugfs-interface-for-splitting-thp-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-a-new-debugfs-interface-for-splitting-thp-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-a-new-debugfs-interface-for-splitting-thp-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: huge_memory: a new debugfs interface for splitting THP tests

We did not have a direct user interface of splitting the compound page
backing a THP and there is no need unless we want to expose the THP
implementation details to users.  Make <debugfs>/split_huge_pages accept a
new command to do that.

By writing "<pid>,<vaddr_start>,<vaddr_end>" to
<debugfs>/split_huge_pages, THPs within the given virtual address range
from the process with the given pid are split.  It is used to test
split_huge_page function.  In addition, a selftest program is added to
tools/testing/selftests/vm to utilize the interface by splitting PMD THPs
and PTE-mapped THPs.

This does not change the old behavior, i.e., writing 1 to the interface to
split all THPs in the system.

Link: https://lkml.kernel.org/r/20210329153932.134510-1-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mika Penttila <mika.penttila@nextfour.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c                                  |  155 +++++
 tools/testing/selftests/vm/.gitignore             |    1 
 tools/testing/selftests/vm/Makefile               |    1 
 tools/testing/selftests/vm/split_huge_page_test.c |  318 ++++++++++++
 4 files changed, 467 insertions(+), 8 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-a-new-debugfs-interface-for-splitting-thp-tests
+++ a/mm/huge_memory.c
@@ -7,6 +7,7 @@
 
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/sched/coredump.h>
 #include <linux/sched/numa_balancing.h>
 #include <linux/highmem.h>
@@ -2927,16 +2928,14 @@ static struct shrinker deferred_split_sh
 };
 
 #ifdef CONFIG_DEBUG_FS
-static int split_huge_pages_set(void *data, u64 val)
+static void split_huge_pages_all(void)
 {
 	struct zone *zone;
 	struct page *page;
 	unsigned long pfn, max_zone_pfn;
 	unsigned long total = 0, split = 0;
 
-	if (val != 1)
-		return -EINVAL;
-
+	pr_debug("Split all THPs\n");
 	for_each_populated_zone(zone) {
 		max_zone_pfn = zone_end_pfn(zone);
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++) {
@@ -2960,15 +2959,155 @@ static int split_huge_pages_set(void *da
 			unlock_page(page);
 next:
 			put_page(page);
+			cond_resched();
 		}
 	}
 
-	pr_info("%lu of %lu THP split\n", split, total);
+	pr_debug("%lu of %lu THP split\n", split, total);
+}
 
-	return 0;
+static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
+{
+	return vma_is_special_huge(vma) || (vma->vm_flags & VM_IO) ||
+		    is_vm_hugetlb_page(vma);
+}
+
+static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
+				unsigned long vaddr_end)
+{
+	int ret = 0;
+	struct task_struct *task;
+	struct mm_struct *mm;
+	unsigned long total = 0, split = 0;
+	unsigned long addr;
+
+	vaddr_start &= PAGE_MASK;
+	vaddr_end &= PAGE_MASK;
+
+	/* Find the task_struct from pid */
+	rcu_read_lock();
+	task = find_task_by_vpid(pid);
+	if (!task) {
+		rcu_read_unlock();
+		ret = -ESRCH;
+		goto out;
+	}
+	get_task_struct(task);
+	rcu_read_unlock();
+
+	/* Find the mm_struct */
+	mm = get_task_mm(task);
+	put_task_struct(task);
+
+	if (!mm) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
+		 pid, vaddr_start, vaddr_end);
+
+	mmap_read_lock(mm);
+	/*
+	 * always increase addr by PAGE_SIZE, since we could have a PTE page
+	 * table filled with PTE-mapped THPs, each of which is distinct.
+	 */
+	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
+		struct vm_area_struct *vma = find_vma(mm, addr);
+		unsigned int follflags;
+		struct page *page;
+
+		if (!vma || addr < vma->vm_start)
+			break;
+
+		/* skip special VMA and hugetlb VMA */
+		if (vma_not_suitable_for_thp_split(vma)) {
+			addr = vma->vm_end;
+			continue;
+		}
+
+		/* FOLL_DUMP to ignore special (like zero) pages */
+		follflags = FOLL_GET | FOLL_DUMP;
+		page = follow_page(vma, addr, follflags);
+
+		if (IS_ERR(page))
+			continue;
+		if (!page)
+			continue;
+
+		if (!is_transparent_hugepage(page))
+			goto next;
+
+		total++;
+		if (!can_split_huge_page(compound_head(page), NULL))
+			goto next;
+
+		if (!trylock_page(page))
+			goto next;
+
+		if (!split_huge_page(page))
+			split++;
+
+		unlock_page(page);
+next:
+		put_page(page);
+		cond_resched();
+	}
+	mmap_read_unlock(mm);
+	mmput(mm);
+
+	pr_debug("%lu of %lu THP split\n", split, total);
+
+out:
+	return ret;
 }
-DEFINE_DEBUGFS_ATTRIBUTE(split_huge_pages_fops, NULL, split_huge_pages_set,
-		"%llu\n");
+
+#define MAX_INPUT_BUF_SZ 255
+
+static ssize_t split_huge_pages_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppops)
+{
+	static DEFINE_MUTEX(split_debug_mutex);
+	ssize_t ret;
+	char input_buf[MAX_INPUT_BUF_SZ]; /* hold pid, start_vaddr, end_vaddr */
+	int pid;
+	unsigned long vaddr_start, vaddr_end;
+
+	ret = mutex_lock_interruptible(&split_debug_mutex);
+	if (ret)
+		return ret;
+
+	ret = -EFAULT;
+
+	memset(input_buf, 0, MAX_INPUT_BUF_SZ);
+	if (copy_from_user(input_buf, buf, min_t(size_t, count, MAX_INPUT_BUF_SZ)))
+		goto out;
+
+	input_buf[MAX_INPUT_BUF_SZ - 1] = '\0';
+	ret = sscanf(input_buf, "%d,0x%lx,0x%lx", &pid, &vaddr_start, &vaddr_end);
+	if (ret == 1 && pid == 1) {
+		split_huge_pages_all();
+		ret = strlen(input_buf);
+		goto out;
+	} else if (ret != 3) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = split_huge_pages_pid(pid, vaddr_start, vaddr_end);
+	if (!ret)
+		ret = strlen(input_buf);
+out:
+	mutex_unlock(&split_debug_mutex);
+	return ret;
+
+}
+
+static const struct file_operations split_huge_pages_fops = {
+	.owner	 = THIS_MODULE,
+	.write	 = split_huge_pages_write,
+	.llseek  = no_llseek,
+};
 
 static int __init split_huge_pages_debugfs(void)
 {
--- a/tools/testing/selftests/vm/.gitignore~mm-huge_memory-a-new-debugfs-interface-for-splitting-thp-tests
+++ a/tools/testing/selftests/vm/.gitignore
@@ -22,3 +22,4 @@ map_fixed_noreplace
 write_to_hugetlbfs
 hmm-tests
 local_config.*
+split_huge_page_test
--- a/tools/testing/selftests/vm/Makefile~mm-huge_memory-a-new-debugfs-interface-for-splitting-thp-tests
+++ a/tools/testing/selftests/vm/Makefile
@@ -42,6 +42,7 @@ TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
+TEST_GEN_FILES += split_huge_page_test
 
 ifeq ($(MACHINE),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_32bit_program.c -m32)
--- /dev/null
+++ a/tools/testing/selftests/vm/split_huge_page_test.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A test of splitting PMD THPs and PTE-mapped THPs from a specified virtual
+ * address range in a process via <debugfs>/split_huge_pages interface.
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <inttypes.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <malloc.h>
+#include <stdbool.h>
+
+uint64_t pagesize;
+unsigned int pageshift;
+uint64_t pmd_pagesize;
+
+#define PMD_SIZE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
+#define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
+#define SMAP_PATH "/proc/self/smaps"
+#define INPUT_MAX 80
+
+#define PFN_MASK     ((1UL<<55)-1)
+#define KPF_THP      (1UL<<22)
+
+int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
+{
+	uint64_t paddr;
+	uint64_t page_flags;
+
+	if (pagemap_file) {
+		pread(pagemap_file, &paddr, sizeof(paddr),
+			((long)vaddr >> pageshift) * sizeof(paddr));
+
+		if (kpageflags_file) {
+			pread(kpageflags_file, &page_flags, sizeof(page_flags),
+				(paddr & PFN_MASK) * sizeof(page_flags));
+
+			return !!(page_flags & KPF_THP);
+		}
+	}
+	return 0;
+}
+
+
+static uint64_t read_pmd_pagesize(void)
+{
+	int fd;
+	char buf[20];
+	ssize_t num_read;
+
+	fd = open(PMD_SIZE_PATH, O_RDONLY);
+	if (fd == -1) {
+		perror("Open hpage_pmd_size failed");
+		exit(EXIT_FAILURE);
+	}
+	num_read = read(fd, buf, 19);
+	if (num_read < 1) {
+		close(fd);
+		perror("Read hpage_pmd_size failed");
+		exit(EXIT_FAILURE);
+	}
+	buf[num_read] = '\0';
+	close(fd);
+
+	return strtoul(buf, NULL, 10);
+}
+
+static int write_file(const char *path, const char *buf, size_t buflen)
+{
+	int fd;
+	ssize_t numwritten;
+
+	fd = open(path, O_WRONLY);
+	if (fd == -1)
+		return 0;
+
+	numwritten = write(fd, buf, buflen - 1);
+	close(fd);
+	if (numwritten < 1)
+		return 0;
+
+	return (unsigned int) numwritten;
+}
+
+static void write_debugfs(int pid, uint64_t vaddr_start, uint64_t vaddr_end)
+{
+	char input[INPUT_MAX];
+	int ret;
+
+	ret = snprintf(input, INPUT_MAX, "%d,0x%lx,0x%lx", pid, vaddr_start,
+			vaddr_end);
+	if (ret >= INPUT_MAX) {
+		printf("%s: Debugfs input is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+
+	if (!write_file(SPLIT_DEBUGFS, input, ret + 1)) {
+		perror(SPLIT_DEBUGFS);
+		exit(EXIT_FAILURE);
+	}
+}
+
+#define MAX_LINE_LENGTH 500
+
+static bool check_for_pattern(FILE *fp, const char *pattern, char *buf)
+{
+	while (fgets(buf, MAX_LINE_LENGTH, fp) != NULL) {
+		if (!strncmp(buf, pattern, strlen(pattern)))
+			return true;
+	}
+	return false;
+}
+
+static uint64_t check_huge(void *addr)
+{
+	uint64_t thp = 0;
+	int ret;
+	FILE *fp;
+	char buffer[MAX_LINE_LENGTH];
+	char addr_pattern[MAX_LINE_LENGTH];
+
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
+		       (unsigned long) addr);
+	if (ret >= MAX_LINE_LENGTH) {
+		printf("%s: Pattern is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+
+
+	fp = fopen(SMAP_PATH, "r");
+	if (!fp) {
+		printf("%s: Failed to open file %s\n", __func__, SMAP_PATH);
+		exit(EXIT_FAILURE);
+	}
+	if (!check_for_pattern(fp, addr_pattern, buffer))
+		goto err_out;
+
+	/*
+	 * Fetch the AnonHugePages: in the same block and check the number of
+	 * hugepages.
+	 */
+	if (!check_for_pattern(fp, "AnonHugePages:", buffer))
+		goto err_out;
+
+	if (sscanf(buffer, "AnonHugePages:%10ld kB", &thp) != 1) {
+		printf("Reading smap error\n");
+		exit(EXIT_FAILURE);
+	}
+
+err_out:
+	fclose(fp);
+	return thp;
+}
+
+void split_pmd_thp(void)
+{
+	char *one_page;
+	size_t len = 4 * pmd_pagesize;
+	uint64_t thp_size;
+	size_t i;
+
+	one_page = memalign(pmd_pagesize, len);
+
+	if (!one_page) {
+		printf("Fail to allocate memory\n");
+		exit(EXIT_FAILURE);
+	}
+
+	madvise(one_page, len, MADV_HUGEPAGE);
+
+	for (i = 0; i < len; i++)
+		one_page[i] = (char)i;
+
+	thp_size = check_huge(one_page);
+	if (!thp_size) {
+		printf("No THP is allocated\n");
+		exit(EXIT_FAILURE);
+	}
+
+	/* split all THPs */
+	write_debugfs(getpid(), (uint64_t)one_page, (uint64_t)one_page + len);
+
+	for (i = 0; i < len; i++)
+		if (one_page[i] != (char)i) {
+			printf("%ld byte corrupted\n", i);
+			exit(EXIT_FAILURE);
+		}
+
+
+	thp_size = check_huge(one_page);
+	if (thp_size) {
+		printf("Still %ld kB AnonHugePages not split\n", thp_size);
+		exit(EXIT_FAILURE);
+	}
+
+	printf("Split huge pages successful\n");
+	free(one_page);
+}
+
+void split_pte_mapped_thp(void)
+{
+	char *one_page, *pte_mapped, *pte_mapped2;
+	size_t len = 4 * pmd_pagesize;
+	uint64_t thp_size;
+	size_t i;
+	const char *pagemap_template = "/proc/%d/pagemap";
+	const char *kpageflags_proc = "/proc/kpageflags";
+	char pagemap_proc[255];
+	int pagemap_fd;
+	int kpageflags_fd;
+
+	if (snprintf(pagemap_proc, 255, pagemap_template, getpid()) < 0) {
+		perror("get pagemap proc error");
+		exit(EXIT_FAILURE);
+	}
+	pagemap_fd = open(pagemap_proc, O_RDONLY);
+
+	if (pagemap_fd == -1) {
+		perror("read pagemap:");
+		exit(EXIT_FAILURE);
+	}
+
+	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
+
+	if (kpageflags_fd == -1) {
+		perror("read kpageflags:");
+		exit(EXIT_FAILURE);
+	}
+
+	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+
+	madvise(one_page, len, MADV_HUGEPAGE);
+
+	for (i = 0; i < len; i++)
+		one_page[i] = (char)i;
+
+	thp_size = check_huge(one_page);
+	if (!thp_size) {
+		printf("No THP is allocated\n");
+		exit(EXIT_FAILURE);
+	}
+
+	/* remap the first pagesize of first THP */
+	pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
+
+	/* remap the Nth pagesize of Nth THP */
+	for (i = 1; i < 4; i++) {
+		pte_mapped2 = mremap(one_page + pmd_pagesize * i + pagesize * i,
+				     pagesize, pagesize,
+				     MREMAP_MAYMOVE|MREMAP_FIXED,
+				     pte_mapped + pagesize * i);
+		if (pte_mapped2 == (char *)-1) {
+			perror("mremap failed");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	/* smap does not show THPs after mremap, use kpageflags instead */
+	thp_size = 0;
+	for (i = 0; i < pagesize * 4; i++)
+		if (i % pagesize == 0 &&
+		    is_backed_by_thp(&pte_mapped[i], pagemap_fd, kpageflags_fd))
+			thp_size++;
+
+	if (thp_size != 4) {
+		printf("Some THPs are missing during mremap\n");
+		exit(EXIT_FAILURE);
+	}
+
+	/* split all remapped THPs */
+	write_debugfs(getpid(), (uint64_t)pte_mapped,
+		      (uint64_t)pte_mapped + pagesize * 4);
+
+	/* smap does not show THPs after mremap, use kpageflags instead */
+	thp_size = 0;
+	for (i = 0; i < pagesize * 4; i++) {
+		if (pte_mapped[i] != (char)i) {
+			printf("%ld byte corrupted\n", i);
+			exit(EXIT_FAILURE);
+		}
+		if (i % pagesize == 0 &&
+		    is_backed_by_thp(&pte_mapped[i], pagemap_fd, kpageflags_fd))
+			thp_size++;
+	}
+
+	if (thp_size) {
+		printf("Still %ld THPs not split\n", thp_size);
+		exit(EXIT_FAILURE);
+	}
+
+	printf("Split PTE-mapped huge pages successful\n");
+	munmap(one_page, len);
+	close(pagemap_fd);
+	close(kpageflags_fd);
+}
+
+int main(int argc, char **argv)
+{
+	if (geteuid() != 0) {
+		printf("Please run the benchmark as root\n");
+		exit(EXIT_FAILURE);
+	}
+
+	pagesize = getpagesize();
+	pageshift = ffs(pagesize) - 1;
+	pmd_pagesize = read_pmd_pagesize();
+
+	split_pmd_thp();
+	split_pte_mapped_thp();
+
+	return 0;
+}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-a-new-debugfs-interface-for-splitting-thp-tests.patch
mm-huge_memory-debugfs-for-file-backed-thp-split.patch

