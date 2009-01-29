From: akpm@linux-foundation.org
Subject: + do_wp_page-fix-regression-with-execute-in-place.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:25:18 -0800
Message-ID: <200901290825.n0T8PISW012609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869AbZA2IZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:25:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cotte@de.ibm.com, heiko.carstens@de.ibm.com, npiggin@suse.de, stable@kernel.org, torvalds@linux-foundation.org


The patch titled
     do_wp_page: fix regression with execute in place
has been added to the -mm tree.  Its filename is
     do_wp_page-fix-regression-with-execute-in-place.patch

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

linux-next.patch
do_wp_page-fix-regression-with-execute-in-place.patch

