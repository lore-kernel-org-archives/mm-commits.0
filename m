From: akpm@linux-foundation.org
Subject: + mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:37:52 -0700
Message-ID: <200910122237.n9CMbqeQ027513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933054AbZJLWjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hugh.dickins@tiscali.co.uk


The patch titled
     mmap: don't return ENOMEM when mapcount is temporarily exceeded in munmap()
has been added to the -mm tree.  Its filename is
     mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap: don't return ENOMEM when mapcount is temporarily exceeded in munmap()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

On ia64, the following test program exit abnormally, because glibc thread
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

Oh well, that's crazy, because stack unmapping never increase mapcount. 
The maxcount exceeding is only temporary.  internal temporary exceeding
shouldn't make ENOMEM.

This patch does it.

 test_max_mapcount.c
 ==================================================================
  #include<stdio.h>
  #include<stdlib.h>
  #include<string.h>
  #include<pthread.h>
  #include<errno.h>
  #include<unistd.h>

  #define THREAD_NUM 30000
  #define MAL_SIZE (8*1024*1024)

 void *wait_thread(void *args)
 {
 	void *addr;

 	addr = malloc(MAL_SIZE);
 	sleep(10);

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
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/mmap.c~mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap mm/mmap.c
--- a/mm/mmap.c~mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap
+++ a/mm/mmap.c
@@ -1829,10 +1829,10 @@ detach_vmas_to_be_unmapped(struct mm_str
 }
 
 /*
- * Split a vma into two pieces at address 'addr', a new vma is allocated
- * either for the first part or the tail.
+ * __split_vma() bypasses sysctl_max_map_count checking.  We use this on the
+ * munmap path where it doesn't make sense to fail.
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
@@ -1884,6 +1881,19 @@ int split_vma(struct mm_struct * mm, str
 	return 0;
 }
 
+/*
+ * Split a vma into two pieces at address 'addr', a new vma is allocated
+ * either for the first part or the tail.
+ */
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
@@ -1919,7 +1929,17 @@ int do_munmap(struct mm_struct *mm, unsi
 	 * places tmp vma above, and higher split_vma places tmp vma below.
 	 */
 	if (start > vma->vm_start) {
-		int error = split_vma(mm, vma, start, 0);
+		int error;
+
+		/*
+		 * Make sure that map_count on return from munmap() will
+		 * not exceed its limit; but let map_count go just above
+		 * its limit temporarily, to help free resources as expected.
+		 */
+		if (end < vma->vm_end && mm->map_count >= sysctl_max_map_count)
+			return -ENOMEM;
+
+		error = __split_vma(mm, vma, start, 0);
 		if (error)
 			return error;
 		prev = vma;
@@ -1928,7 +1948,7 @@ int do_munmap(struct mm_struct *mm, unsi
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
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

