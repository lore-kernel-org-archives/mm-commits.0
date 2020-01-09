From: akpm@linux-foundation.org
Subject: [to-be-updated]
 kernel-fork-set-vmas-mm-prev-next-right-after-vm_area_dup-in-dup_mmap.patch
 removed from -mm tree
Date: Thu, 09 Jan 2020 13:36:54 -0800
Message-ID: <20200109213654.mW9LBjpC9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgAIVgz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 16:36:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, riel@redhat.com


The patch titled
     Subject: kernel/fork: set VMA's mm/prev/next right after vm_area_dup in dup_mmap
has been removed from the -mm tree.  Its filename was
     kernel-fork-set-vmas-mm-prev-next-right-after-vm_area_dup-in-dup_mmap.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: kernel/fork: set VMA's mm/prev/next right after vm_area_dup in dup_mmap

Function vm_area_dup() makes exact copy of structure.  It's better to stop
referencing parent structures because various helpers use these pointers.

For example if VM_WIPEONFORK is set then anon_vma_prepare() will try to
merge anon_vma with previous and next VMA.  Poking parent VMAs and sharing
their anon_vma is safe for now but is not expected behavior.

Note: this will break commit 4e4a9eb92133 ("mm/rmap.c: reuse mergeable
anon_vma as parent when fork") without related fix because it contains
several flaws hidden by current initialization sequence in dup_mmap().

Link: http://lkml.kernel.org/r/157839239842.694.2288178566540902852.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reviewed-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/fork.c~kernel-fork-set-vmas-mm-prev-next-right-after-vm_area_dup-in-dup_mmap
+++ a/kernel/fork.c
@@ -544,10 +544,12 @@ static __latent_entropy int dup_mmap(str
 		tmp = vm_area_dup(mpnt);
 		if (!tmp)
 			goto fail_nomem;
+		tmp->vm_mm = mm;
+		tmp->vm_prev = prev;
+		tmp->vm_next = NULL;
 		retval = vma_dup_policy(mpnt, tmp);
 		if (retval)
 			goto fail_nomem_policy;
-		tmp->vm_mm = mm;
 		retval = dup_userfaultfd(tmp, &uf);
 		if (retval)
 			goto fail_nomem_anon_vma_fork;
@@ -559,7 +561,6 @@ static __latent_entropy int dup_mmap(str
 		} else if (anon_vma_fork(tmp, mpnt, prev))
 			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
-		tmp->vm_next = tmp->vm_prev = NULL;
 		file = tmp->vm_file;
 		if (file) {
 			struct inode *inode = file_inode(file);
@@ -592,7 +593,6 @@ static __latent_entropy int dup_mmap(str
 		 */
 		*pprev = tmp;
 		pprev = &tmp->vm_next;
-		tmp->vm_prev = prev;
 		prev = tmp;
 
 		__vma_link_rb(mm, tmp, rb_link, rb_parent);
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are
