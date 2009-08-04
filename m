From: akpm@linux-foundation.org
Subject: + kcore-proc-kcore-should-use-vread.patch added to -mm tree
Date: Tue, 04 Aug 2009 15:20:07 -0700
Message-ID: <200908042220.n74MK7OO013104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933443AbZHDWU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 18:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, scgtrp@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     kcore: /proc/kcore should use vread
has been added to the -mm tree.  Its filename is
     kcore-proc-kcore-should-use-vread.patch

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
Subject: kcore: /proc/kcore should use vread
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

/proc/kcore has its own routine to access vmallc area.  It can be replaced
with vread().  And by this, /proc/kcore can do safe access to vmalloc
area.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mike Smith <scgtrp@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff -puN fs/proc/kcore.c~kcore-proc-kcore-should-use-vread fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-proc-kcore-should-use-vread
+++ a/fs/proc/kcore.c
@@ -328,43 +328,12 @@ read_kcore(struct file *file, char __use
 				return -EFAULT;
 		} else if (is_vmalloc_addr((void *)start)) {
 			char * elf_buf;
-			struct vm_struct *m;
-			unsigned long curstart = start;
-			unsigned long cursize = tsz;
 
 			elf_buf = kzalloc(tsz, GFP_KERNEL);
 			if (!elf_buf)
 				return -ENOMEM;
-
-			read_lock(&vmlist_lock);
-			for (m=vmlist; m && cursize; m=m->next) {
-				unsigned long vmstart;
-				unsigned long vmsize;
-				unsigned long msize = m->size - PAGE_SIZE;
-
-				if (((unsigned long)m->addr + msize) < 
-								curstart)
-					continue;
-				if ((unsigned long)m->addr > (curstart + 
-								cursize))
-					break;
-				vmstart = (curstart < (unsigned long)m->addr ? 
-					(unsigned long)m->addr : curstart);
-				if (((unsigned long)m->addr + msize) > 
-							(curstart + cursize))
-					vmsize = curstart + cursize - vmstart;
-				else
-					vmsize = (unsigned long)m->addr + 
-							msize - vmstart;
-				curstart = vmstart + vmsize;
-				cursize -= vmsize;
-				/* don't dump ioremap'd stuff! (TA) */
-				if (m->flags & VM_IOREMAP)
-					continue;
-				memcpy(elf_buf + (vmstart - start),
-					(char *)vmstart, vmsize);
-			}
-			read_unlock(&vmlist_lock);
+			vread(elf_buf, (char *)start, tsz);
+			/* we have to zero-fill user buffer even if no read */
 			if (copy_to_user(buffer, elf_buf, tsz)) {
 				kfree(elf_buf);
 				return -EFAULT;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
mm-introduce-proc-pid-oom_adj_child.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-proc-kcore-should-use-vread.patch
kcore-fix-proc-kcores-statst_size.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch

