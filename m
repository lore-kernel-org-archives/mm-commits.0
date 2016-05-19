From: akpm@linux-foundation.org
Subject: [folded-merged]
 debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2.patch removed from -mm tree
Date: Thu, 19 May 2016 16:35:49 -0700
Message-ID: <573e4dd5.zCSZCWmIUOZ3OQta%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbcESXfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2
has been removed from the -mm tree.  Its filename was
     debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks-v2.patch

This patch was dropped because it was folded into debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks.patch

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

