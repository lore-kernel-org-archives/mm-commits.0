From: akpm@linux-foundation.org
Subject: + fb_defio-redo-fix-for-non-dirty-ptes.patch added to -mm tree
Date: Fri, 28 May 2010 15:44:18 -0700
Message-ID: <201005282244.o4SMiI6W018731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771Ab0E1WoX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 18:44:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albert_herranz@yahoo.es, jayakumar.lkml@gmail.com, npiggin@suse.de


The patch titled
     fb_defio: redo fix for non-dirty ptes
has been added to the -mm tree.  Its filename is
     fb_defio-redo-fix-for-non-dirty-ptes.patch

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
Subject: fb_defio: redo fix for non-dirty ptes
From: Albert Herranz <albert_herranz@yahoo.es>

As pointed by Nick Piggin, ->page_mkwrite provides a way to keep a page
locked until the associated PTE is marked dirty.

Re-implement the fix by using this mechanism.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fb_defio.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/video/fb_defio.c~fb_defio-redo-fix-for-non-dirty-ptes drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~fb_defio-redo-fix-for-non-dirty-ptes
+++ a/drivers/video/fb_defio.c
@@ -100,6 +100,16 @@ static int fb_deferred_io_mkwrite(struct
 	/* protect against the workqueue changing the page list */
 	mutex_lock(&fbdefio->lock);
 
+	/*
+	 * We want the page to remain locked from ->page_mkwrite until
+	 * the PTE is marked dirty to avoid page_mkclean() being called
+	 * before the PTE is updated, which would leave the page ignored
+	 * by defio.
+	 * Do this by locking the page here and informing the caller
+	 * about it with VM_FAULT_LOCKED.
+	 */
+	lock_page(page);
+
 	/* we loop through the pagelist before adding in order
 	to keep the pagelist sorted */
 	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
@@ -121,7 +131,7 @@ page_already_added:
 
 	/* come back after delay to process the deferred IO */
 	schedule_delayed_work(&info->deferred_work, fbdefio->delay);
-	return 0;
+	return VM_FAULT_LOCKED;
 }
 
 static const struct vm_operations_struct fb_deferred_io_vm_ops = {
_

Patches currently in -mm which might be from albert_herranz@yahoo.es are

origin.patch
revert-fb_defio-fix-for-non-dirty-ptes.patch
fb_defio-redo-fix-for-non-dirty-ptes.patch

