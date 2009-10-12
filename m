From: akpm@linux-foundation.org
Subject: [to-be-updated] munmap-dont-check-sysctl_max_mapcount.patch removed from -mm tree
Date: Mon, 12 Oct 2009 15:36:07 -0700
Message-ID: <200910122236.n9CMa82Q024020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933523AbZJLWhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     munmap(): don't check sysctl_max_mapcount
has been removed from the -mm tree.  Its filename was
     munmap-dont-check-sysctl_max_mapcount.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: munmap(): don't check sysctl_max_mapcount
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

On ia64, the following test program exits abnormally, because glibc thread
library called abort().

 ========================================================
 (gdb) bt
 #0  0xa000000000010620 in __kernel_syscall_via_break ()
 #1  0x20000000003208e0 in raise () from /lib/libc.so.6.1
 #2  0x2000000000324090 in abort () from /lib/libc.so.6.1
 #3  0x200000000027c3e0 in __deallocate_stack () from /lib/libpthread.so.0
 #4  0x200000000027f7c0 in start_thread () from /lib/libpthread.so.0
 #5  0x200000000047ef60 in __clone2 () from /lib/libc.so.6.1
 ========================================================

The fact is, glibc call munmap() when thread exitng time for freeing
stack, and it assume munlock() never fail.  However, munmap() often make
vma splitting and it with many mapcount make -ENOMEM.

Stack unfreeing is not reasonable option.  Also munlock() via free()
shouldn't fail.

Thus, munmap() shoudn't check max-mapcount. This patch does it.

 test_max_mapcount.c
 ==================================================================
  #include<stdio.h>
  #include<stdlib.h>
  #include<string.h>
  #include<pthread.h>
  #include<errno.h>
  #include<unistd.h>

  #define THREAD_NUM 30000
  #define MAL_SIZE (100*1024)

 void *wait_thread(void *args)
 {
 	void *addr;

 	addr = malloc(MAL_SIZE);
 	if(addr)
 		memset(addr, 1, MAL_SIZE);
 	sleep(1);

 	return NULL;
 }

 void *wait_thread2(void *args)
 {
 	sleep(60);

 	return NULL;
 }

 int main(int argc, char *argv[])
 {
 	int i;
 	pthread_t thread[THREAD_NUM], th;
 	int ret, count = 0;
 	pthread_attr_t attr;

 	ret = pthread_attr_init(&attr);
 	if(ret) {
 		perror("pthread_attr_init");
 	}

 	ret = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 	if(ret) {
 		perror("pthread_attr_setdetachstate");
 	}

 	for (i = 0; i < THREAD_NUM; i++) {
 		ret = pthread_create(&th, &attr, wait_thread, NULL);
 		if(ret) {
 			fprintf(stderr, "[%d] ", count);
 			perror("pthread_create");
 		} else {
 			printf("[%d] create OK.\n", count);
 		}
 		count++;

 		ret = pthread_create(&thread[i], &attr, wait_thread2, NULL);
 		if(ret) {
 			fprintf(stderr, "[%d] ", count);
 			perror("pthread_create");
 		} else {
 			printf("[%d] create OK.\n", count);
 		}
 		count++;
 	}

 	sleep(3600);
 	return 0;
 }
 ==================================================================

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/mmap.c~munmap-dont-check-sysctl_max_mapcount mm/mmap.c
--- a/mm/mmap.c~munmap-dont-check-sysctl_max_mapcount
+++ a/mm/mmap.c
@@ -1832,7 +1832,7 @@ detach_vmas_to_be_unmapped(struct mm_str
  * Split a vma into two pieces at address 'addr', a new vma is allocated
  * either for the first part or the tail.
  */
-int split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
+static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	      unsigned long addr, int new_below)
 {
 	struct mempolicy *pol;
@@ -1842,9 +1842,6 @@ int split_vma(struct mm_struct * mm, str
 					~(huge_page_mask(hstate_vma(vma)))))
 		return -EINVAL;
 
-	if (mm->map_count >= sysctl_max_map_count)
-		return -ENOMEM;
-
 	new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
@@ -1884,6 +1881,15 @@ int split_vma(struct mm_struct * mm, str
 	return 0;
 }
 
+int split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
+	      unsigned long addr, int new_below)
+{
+	if (mm->map_count >= sysctl_max_map_count)
+		return -ENOMEM;
+
+	return __split_vma(mm, vma, addr, new_below);
+}
+
 /* Munmap is split into 2 main parts -- this part which finds
  * what needs doing, and the areas themselves, which do the
  * work.  This now handles partial unmappings.
@@ -1919,7 +1925,7 @@ int do_munmap(struct mm_struct *mm, unsi
 	 * places tmp vma above, and higher split_vma places tmp vma below.
 	 */
 	if (start > vma->vm_start) {
-		int error = split_vma(mm, vma, start, 0);
+		int error = __split_vma(mm, vma, start, 0);
 		if (error)
 			return error;
 		prev = vma;
@@ -1928,7 +1934,7 @@ int do_munmap(struct mm_struct *mm, unsi
 	/* Does it split the last one? */
 	last = find_vma(mm, end);
 	if (last && end > last->vm_start) {
-		int error = split_vma(mm, last, end, 1);
+		int error = __split_vma(mm, last, end, 1);
 		if (error)
 			return error;
 	}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
congestion_wait-dont-use-write.patch
cgroup-fix-strstrip-misuse.patch
strstrip-mark-as-as-must_check.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
munmap-dont-check-sysctl_max_mapcount.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

