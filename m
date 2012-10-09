From: akpm@linux-foundation.org
Subject: [merged] mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:10:59 -0700
Message-ID: <20121009181059.C75421E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:43146 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab2JISLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:00 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so574109yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, hughd@google.com, jslaby@suse.cz, levinsasha928@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm anon rmap: in mremap, set the new vma's position before anon_vma_clone()
has been removed from the -mm tree.  Its filename was
     mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm anon rmap: in mremap, set the new vma's position before anon_vma_clone()

anon_vma_clone() expects new_vma->vm_{start,end,pgoff} to be correctly set
so that the new vma can be indexed on the anon interval tree.

copy_vma() was failing to do that, which broke mremap().

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone mm/mmap.c
--- a/mm/mmap.c~mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone
+++ a/mm/mmap.c
@@ -2419,16 +2419,16 @@ struct vm_area_struct *copy_vma(struct v
 		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (new_vma) {
 			*new_vma = *vma;
+			new_vma->vm_start = addr;
+			new_vma->vm_end = addr + len;
+			new_vma->vm_pgoff = pgoff;
 			pol = mpol_dup(vma_policy(vma));
 			if (IS_ERR(pol))
 				goto out_free_vma;
+			vma_set_policy(new_vma, pol);
 			INIT_LIST_HEAD(&new_vma->anon_vma_chain);
 			if (anon_vma_clone(new_vma, vma))
 				goto out_free_mempol;
-			vma_set_policy(new_vma, pol);
-			new_vma->vm_start = addr;
-			new_vma->vm_end = addr + len;
-			new_vma->vm_pgoff = pgoff;
 			if (new_vma->vm_file)
 				get_file(new_vma->vm_file);
 			if (new_vma->vm_ops && new_vma->vm_ops->open)
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

