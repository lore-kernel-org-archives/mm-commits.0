From: akpm@linux-foundation.org
Subject: +
 debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2.patch added to -mm tree
Date: Mon, 09 May 2016 14:46:59 -0700
Message-ID: <57310553.Asse95osWThnHkjT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbcEIVrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 17:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2
has been added to the -mm tree.  Its filename is
     debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Du, Changbin" <changbin.du@intel.com>
Subject: debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2

improve code comments where invoke the new is_static_object callback

Link: http://lkml.kernel.org/r/1462777431-8171-1-git-send-email-changbin.du@intel.com
Signed-off-by: "Du, Changbin" <changbin.du@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN lib/debugobjects.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2 lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2
+++ a/lib/debugobjects.c
@@ -431,12 +431,14 @@ int debug_object_activate(void *addr, st
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 	/*
-	 * This happens when a static object is activated. We
-	 * let the type specific code decide whether this is
-	 * true or not.
+	 * We are here when a static object is activated. We
+	 * let the type specific code confirm whether this is
+	 * true or not. if true, we just make sure that the
+	 * static object is tracked in the object tracker. If
+	 * not, this must be a bug, so we try to fix it up.
 	 */
 	if (descr->is_static_object && descr->is_static_object(addr)) {
-		/* Just make sure that it is tracked in the object tracker */
+		/* track this static object */
 		debug_object_init(addr, descr);
 		debug_object_activate(addr, descr);
 	} else {
@@ -607,11 +609,12 @@ void debug_object_assert_init(void *addr
 
 		raw_spin_unlock_irqrestore(&db->lock, flags);
 		/*
-		 * Maybe the object is static. Let the type specific
-		 * code decide what to do.
+		 * Maybe the object is static, and we let the type specific
+		 * code confirm. Track this static object if true, else invoke
+		 * fixup.
 		 */
 		if (descr->is_static_object && descr->is_static_object(addr)) {
-			/* Make sure that it is tracked in the object tracker */
+			/* Track this static object */
 			debug_object_init(addr, descr);
 		} else {
 			debug_print_object(&o, "assert_init");
_

Patches currently in -mm which might be from changbin.du@intel.com are

debugobjects-make-fixup-functions-return-bool-instead-of-int.patch
debugobjects-correct-the-usage-of-fixup-call-results.patch
workqueue-update-debugobjects-fixup-callbacks-return-type.patch
timer-update-debugobjects-fixup-callbacks-return-type.patch
rcu-update-debugobjects-fixup-callbacks-return-type.patch
percpu_counter-update-debugobjects-fixup-callbacks-return-type.patch
documentation-update-debugobjects-doc.patch
debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks.patch
debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2.patch
checkpatch-add-support-to-check-already-applied-git-commits.patch

