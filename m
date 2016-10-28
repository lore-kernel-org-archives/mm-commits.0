From: akpm@linux-foundation.org
Subject: + mm-add-locked-parameter-to-get_user_pages_remote.patch added to -mm tree
Date: Fri, 28 Oct 2016 15:54:00 -0700
Message-ID: <5813d708.jhNg5EdDUj3mOy8Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752824AbcJ1WyC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 18:54:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lstoakes@gmail.com, dave.hansen@linux.intel.com, hughd@google.com, jack@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, pbonzini@redhat.com, riel@redhat.com, rkrcmar@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add locked parameter to get_user_pages_remote()
has been added to the -mm tree.  Its filename is
     mm-add-locked-parameter-to-get_user_pages_remote.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-locked-parameter-to-get_user_pages_remote.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-locked-parameter-to-get_user_pages_remote.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: add locked parameter to get_user_pages_remote()

Patch series "mm: unexport __get_user_pages_unlocked()".

This patch series continues the cleanup of get_user_pages*() functions taking
advantage of the fact we can now pass gup_flags as we please.

It firstly adds an additional 'locked' parameter to get_user_pages_remote() to
allow for its callers to utilise VM_FAULT_RETRY functionality. This is necessary
as the invocation of __get_user_pages_unlocked() in process_vm_rw_single_vec()
makes use of this and no other existing higher level function would allow it to
do so.

Secondly existing callers of __get_user_pages_unlocked() are replaced with the
appropriate higher-level replacement - get_user_pages_unlocked() if the current
task and memory descriptor are referenced, or get_user_pages_remote() if other
task/memory descriptors are referenced (having acquiring mmap_sem.)


This patch (of 2):

Add a int *locked parameter to get_user_pages_remote() to allow
VM_FAULT_RETRY faulting behaviour similar to get_user_pages_[un]locked().

Taking into account the previous adjustments to get_user_pages*()
functions allowing for the passing of gup_flags, we are now in a position
where __get_user_pages_unlocked() need only be exported for his ability to
allow VM_FAULT_RETRY behaviour, this adjustment allows us to subsequently
unexport __get_user_pages_unlocked() as well as allowing for future
flexibility in the use of get_user_pages_remote().

Link: http://lkml.kernel.org/r/20161027095141.2569-2-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/etnaviv/etnaviv_gem.c   |    2 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c |    2 +-
 drivers/infiniband/core/umem_odp.c      |    2 +-
 fs/exec.c                               |    2 +-
 include/linux/mm.h                      |    2 +-
 kernel/events/uprobes.c                 |    4 ++--
 mm/gup.c                                |   12 ++++++++----
 mm/memory.c                             |    2 +-
 security/tomoyo/domain.c                |    2 +-
 9 files changed, 17 insertions(+), 13 deletions(-)

diff -puN drivers/gpu/drm/etnaviv/etnaviv_gem.c~mm-add-locked-parameter-to-get_user_pages_remote drivers/gpu/drm/etnaviv/etnaviv_gem.c
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c~mm-add-locked-parameter-to-get_user_pages_remote
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -763,7 +763,7 @@ static struct page **etnaviv_gem_userptr
 	down_read(&mm->mmap_sem);
 	while (pinned < npages) {
 		ret = get_user_pages_remote(task, mm, ptr, npages - pinned,
-					    flags, pvec + pinned, NULL);
+					    flags, pvec + pinned, NULL, NULL);
 		if (ret < 0)
 			break;
 
diff -puN drivers/gpu/drm/i915/i915_gem_userptr.c~mm-add-locked-parameter-to-get_user_pages_remote drivers/gpu/drm/i915/i915_gem_userptr.c
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c~mm-add-locked-parameter-to-get_user_pages_remote
+++ a/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -522,7 +522,7 @@ __i915_gem_userptr_get_pages_worker(stru
 					 obj->userptr.ptr + pinned * PAGE_SIZE,
 					 npages - pinned,
 					 flags,
-					 pvec + pinned, NULL);
+					 pvec + pinned, NULL, NULL);
 				if (ret < 0)
 					break;
 
diff -puN drivers/infiniband/core/umem_odp.c~mm-add-locked-parameter-to-get_user_pages_remote drivers/infiniband/core/umem_odp.c
--- a/drivers/infiniband/core/umem_odp.c~mm-add-locked-parameter-to-get_user_pages_remote
+++ a/drivers/infiniband/core/umem_odp.c
@@ -578,7 +578,7 @@ int ib_umem_odp_map_dma_pages(struct ib_
 		 */
 		npages = get_user_pages_remote(owning_process, owning_mm,
 				user_virt, gup_num_pages,
-				flags, local_page_list, NULL);
+				flags, local_page_list, NULL, NULL);
 		up_read(&owning_mm->mmap_sem);
 
 		if (npages < 0)
diff -puN fs/exec.c~mm-add-locked-parameter-to-get_user_pages_remote fs/exec.c
--- a/fs/exec.c~mm-add-locked-parameter-to-get_user_pages_remote
+++ a/fs/exec.c
@@ -209,7 +209,7 @@ static struct page *get_arg_page(struct
 	 * doing the exec and bprm->mm is the new process's mm.
 	 */
 	ret = get_user_pages_remote(current, bprm->mm, pos, 1, gup_flags,
-			&page, NULL);
+			&page, NULL, NULL);
 	if (ret <= 0)
 		return NULL;
 
diff -puN include/linux/mm.h~mm-add-locked-parameter-to-get_user_pages_remote include/linux/mm.h
--- a/include/linux/mm.h~mm-add-locked-parameter-to-get_user_pages_remote
+++ a/include/linux/mm.h
@@ -1274,7 +1274,7 @@ extern int access_remote_vm(struct mm_st
 long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
 			    unsigned long start, unsigned long nr_pages,
 			    unsigned int gup_flags, struct page **pages,
-			    struct vm_area_struct **vmas);
+			    struct vm_area_struct **vmas, int *locked);
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 			    unsigned int gup_flags, struct page **pages,
 			    struct vm_area_struct **vmas);
diff -puN kernel/events/uprobes.c~mm-add-locked-parameter-to-get_user_pages_remote kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-add-locked-parameter-to-get_user_pages_remote
+++ a/kernel/events/uprobes.c
@@ -301,7 +301,7 @@ int uprobe_write_opcode(struct mm_struct
 retry:
 	/* Read the page with vaddr into memory */
 	ret = get_user_pages_remote(NULL, mm, vaddr, 1, FOLL_FORCE, &old_page,
-			&vma);
+			&vma, NULL);
 	if (ret <= 0)
 		return ret;
 
@@ -1712,7 +1712,7 @@ static int is_trap_at_addr(struct mm_str
 	 * essentially a kernel access to the memory.
 	 */
 	result = get_user_pages_remote(NULL, mm, vaddr, 1, FOLL_FORCE, &page,
-			NULL);
+			NULL, NULL);
 	if (result < 0)
 		return result;
 
diff -puN mm/gup.c~mm-add-locked-parameter-to-get_user_pages_remote mm/gup.c
--- a/mm/gup.c~mm-add-locked-parameter-to-get_user_pages_remote
+++ a/mm/gup.c
@@ -917,6 +917,9 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  *		only intends to ensure the pages are faulted in.
  * @vmas:	array of pointers to vmas corresponding to each page.
  *		Or NULL if the caller does not require them.
+ * @locked:	pointer to lock flag indicating whether lock is held and
+ *		subsequently whether VM_FAULT_RETRY functionality can be
+ *		utilised. Lock must initially be held.
  *
  * Returns number of pages pinned. This may be fewer than the number
  * requested. If nr_pages is 0 or negative, returns 0. If no pages
@@ -960,10 +963,10 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
 long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long start, unsigned long nr_pages,
 		unsigned int gup_flags, struct page **pages,
-		struct vm_area_struct **vmas)
+		struct vm_area_struct **vmas, int *locked)
 {
 	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
-				       NULL, false,
+				       locked, true,
 				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 }
 EXPORT_SYMBOL(get_user_pages_remote);
@@ -971,8 +974,9 @@ EXPORT_SYMBOL(get_user_pages_remote);
 /*
  * This is the same as get_user_pages_remote(), just with a
  * less-flexible calling convention where we assume that the task
- * and mm being operated on are the current task's.  We also
- * obviously don't pass FOLL_REMOTE in here.
+ * and mm being operated on are the current task's and don't allow
+ * passing of a locked parameter.  We also obviously don't pass
+ * FOLL_REMOTE in here.
  */
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 		unsigned int gup_flags, struct page **pages,
diff -puN mm/memory.c~mm-add-locked-parameter-to-get_user_pages_remote mm/memory.c
--- a/mm/memory.c~mm-add-locked-parameter-to-get_user_pages_remote
+++ a/mm/memory.c
@@ -3879,7 +3879,7 @@ static int __access_remote_vm(struct tas
 		struct page *page = NULL;
 
 		ret = get_user_pages_remote(tsk, mm, addr, 1,
-				gup_flags, &page, &vma);
+				gup_flags, &page, &vma, NULL);
 		if (ret <= 0) {
 #ifndef CONFIG_HAVE_IOREMAP_PROT
 			break;
diff -puN security/tomoyo/domain.c~mm-add-locked-parameter-to-get_user_pages_remote security/tomoyo/domain.c
--- a/security/tomoyo/domain.c~mm-add-locked-parameter-to-get_user_pages_remote
+++ a/security/tomoyo/domain.c
@@ -881,7 +881,7 @@ bool tomoyo_dump_page(struct linux_binpr
 	 * the execve().
 	 */
 	if (get_user_pages_remote(current, bprm->mm, pos, 1,
-				FOLL_FORCE, &page, NULL) <= 0)
+				FOLL_FORCE, &page, NULL, NULL) <= 0)
 		return false;
 #else
 	page = bprm->page[pos / PAGE_SIZE];
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-fixup-get_user_pages-comments.patch
mm-add-locked-parameter-to-get_user_pages_remote.patch
mm-unexport-__get_user_pages_unlocked.patch

