From: akpm@linux-foundation.org
Subject: + idr-fix-a-printk-call.patch added to -mm tree
Date: Wed, 07 May 2008 13:40:26 -0700
Message-ID: <200805072040.m47KeQKh015465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbYEGUlq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 16:41:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: fix a printk call
has been added to the -mm tree.  Its filename is
     idr-fix-a-printk-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: fix a printk call
From: Nadia Derbey <Nadia.Derbey@bull.net>

Fix the incomplete printk call.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/idr.c~idr-fix-a-printk-call lib/idr.c
--- a/lib/idr.c~idr-fix-a-printk-call
+++ a/lib/idr.c
@@ -326,7 +326,8 @@ EXPORT_SYMBOL(idr_get_new);
 
 static void idr_remove_warning(int id)
 {
-	printk("idr_remove called for id=%d which is not allocated.\n", id);
+	printk(KERN_WARNING
+		"idr_remove called for id=%d which is not allocated.\n", id);
 	dump_stack();
 }
 
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch

