From: akpm@osdl.org
Subject: - kill-install_file_ptes-pte_val.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:01 -0800
Message-ID: <200612072258.kB7Mw1Sn029347@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163597AbWLGW6G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, dcb314@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     kill install_file_pte's pte_val
has been removed from the -mm tree.  Its filename was
     kill-install_file_ptes-pte_val.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kill install_file_pte's pte_val
From: Hugh Dickins <hugh@veritas.com>

David Binderman and his Intel C compiler rightly observe that
install_file_pte no longer has any use for its pte_val.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: d binderman <dcb314@hotmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/fremap.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/fremap.c~kill-install_file_ptes-pte_val mm/fremap.c
--- a/mm/fremap.c~kill-install_file_ptes-pte_val
+++ a/mm/fremap.c
@@ -101,7 +101,6 @@ int install_file_pte(struct mm_struct *m
 {
 	int err = -ENOMEM;
 	pte_t *pte;
-	pte_t pte_val;
 	spinlock_t *ptl;
 
 	pte = get_locked_pte(mm, addr, &ptl);
@@ -114,7 +113,6 @@ int install_file_pte(struct mm_struct *m
 	}
 
 	set_pte_at(mm, addr, pte, pgoff_to_pte(pgoff));
-	pte_val = *pte;
 	/*
 	 * We don't need to run update_mmu_cache() here because the "file pte"
 	 * being installed by install_file_pte() is not a real pte - it's a
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
ext2-reservations.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
generic-bug-implementation.patch
generic-bug-implementation-handle-bug=n.patch
generic-bug-for-i386.patch
generic-bug-for-x86-64.patch
bug-test-1.patch
tty-switch-to-ktermios-powerpc-fix.patch

