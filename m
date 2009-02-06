From: akpm@linux-foundation.org
Subject: [merged] do_wp_page-fix-regression-with-execute-in-place.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:10 -0800
Message-ID: <200902061938.n16JcAYs012024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686AbZBFTji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:39:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cotte@de.ibm.com, heiko.carstens@de.ibm.com, npiggin@suse.de, stable@kernel.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     do_wp_page: fix regression with execute in place
has been removed from the -mm tree.  Its filename was
     do_wp_page-fix-regression-with-execute-in-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wp_page: fix regression with execute in place
From: Carsten Otte <cotte@de.ibm.com>

Fix do_wp_page for VM_MIXEDMAP mappings.

In the case where pfn_valid returns 0 for a pfn at the beginning of
do_wp_page and the mapping is not shared writable, the code branches to
label `gotten:' with old_page == NULL.

In case the vma is locked (vma->vm_flags & VM_LOCKED), lock_page,
clear_page_mlock, and unlock_page try to access the old_page.

This patch checks whether old_page is valid before it is dereferenced.

The regression was introduced by

commit b291f000393f5a0b679012b39d79fbc85c018233
Author:     Nick Piggin <npiggin@suse.de>
AuthorDate: Sat Oct 18 20:26:44 2008 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Mon Oct 20 08:52:30 2008 -0700

    mlock: mlocked pages are unevictable


Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~do_wp_page-fix-regression-with-execute-in-place mm/memory.c
--- a/mm/memory.c~do_wp_page-fix-regression-with-execute-in-place
+++ a/mm/memory.c
@@ -1999,7 +1999,7 @@ gotten:
 	 * Don't let another task, with possibly unlocked vma,
 	 * keep the mlocked page.
 	 */
-	if (vma->vm_flags & VM_LOCKED) {
+	if ((vma->vm_flags & VM_LOCKED) && old_page) {
 		lock_page(old_page);	/* for LRU manipulation */
 		clear_page_mlock(old_page);
 		unlock_page(old_page);
_

Patches currently in -mm which might be from cotte@de.ibm.com are

origin.patch
linux-next.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes-fix.patch

