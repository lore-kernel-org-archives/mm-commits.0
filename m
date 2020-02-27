From: akpm@linux-foundation.org
Subject: + proc-annotate-close_pdeo-for-sparse.patch added to -mm
 tree
Date: Thu, 27 Feb 2020 15:09:07 -0800
Message-ID: <20200227230907.jGMf9tP1O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729656AbgB0XJJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 27 Feb 2020 18:09:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, jbi.octave@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/inode.c: annotate close_pdeo() for sparse
has been added to the -mm tree.  Its filename is
     proc-annotate-close_pdeo-for-sparse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-annotate-close_pdeo-for-sparse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-annotate-close_pdeo-for-sparse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: fs/proc/inode.c: annotate close_pdeo() for sparse

Fix sparse locking imbalance warning:

	warning: context imbalance in close_pdeo() - unexpected unlock

Link: http://lkml.kernel.org/r/20200227201538.GA30462@avx2
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/inode.c~proc-annotate-close_pdeo-for-sparse
+++ a/fs/proc/inode.c
@@ -139,6 +139,7 @@ static void unuse_pde(struct proc_dir_en
 
 /* pde is locked on entry, unlocked on exit */
 static void close_pdeo(struct proc_dir_entry *pde, struct pde_opener *pdeo)
+	__releases(&pde->pde_unload_lock)
 {
 	/*
 	 * close() (proc_reg_release()) can't delete an entry and proceed:
_

Patches currently in -mm which might be from jbi.octave@gmail.com are

ocfs2-add-missing-annotations-for-ocfs2_refcount_cache_lock-and-ocfs2_refcount_cache_unlock.patch
mm-memcontrol-add-missing-annotation-for-unlock_page_lru.patch
mm-memcontrol-add-missing-annotation-for-lock_page_lru.patch
mm-compaction-add-missing-annotation-for-compact_lock_irqsave.patch
mm-hugetlb-add-missing-annotation-for-gather_surplus_pages.patch
mm-mempolicy-add-missing-annotation-for-queue_pages_pmd.patch
mm-slub-add-missing-annotation-for-get_map.patch
mm-slub-add-missing-annotation-for-put_map.patch
mm-zsmalloc-add-missing-annotation-for-migrate_read_lock.patch
mm-zsmalloc-add-missing-annotation-for-migrate_read_unlock.patch
mm-zsmalloc-add-missing-annotation-for-pin_tag.patch
mm-zsmalloc-add-missing-annotation-for-unpin_tag.patch
proc-annotate-close_pdeo-for-sparse.patch
