From: akpm@linux-foundation.org
Subject: + rcu-update-debugobjects-fixup-callbacks-return-type.patch added to -mm tree
Date: Fri, 22 Apr 2016 13:02:08 -0700
Message-ID: <571a8340.+AUH607FNTkurKz8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbcDVUCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rcu: update debugobjects fixup callbacks return type
has been added to the -mm tree.  Its filename is
     rcu-update-debugobjects-fixup-callbacks-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rcu-update-debugobjects-fixup-callbacks-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rcu-update-debugobjects-fixup-callbacks-return-type.patch

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
Subject: rcu: update debugobjects fixup callbacks return type

Update the return type to use bool instead of int, corresponding to
cheange (debugobjects: make fixup functions return bool instead of int).

Signed-off-by: Du, Changbin <changbin.du@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcu/update.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/rcu/update.c~rcu-update-debugobjects-fixup-callbacks-return-type kernel/rcu/update.c
--- a/kernel/rcu/update.c~rcu-update-debugobjects-fixup-callbacks-return-type
+++ a/kernel/rcu/update.c
@@ -386,7 +386,7 @@ void destroy_rcu_head(struct rcu_head *h
  * - an unknown object is activated (might be a statically initialized object)
  * Activation is performed internally by call_rcu().
  */
-static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
+static bool rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
 {
 	struct rcu_head *head = addr;
 
@@ -399,9 +399,9 @@ static int rcuhead_fixup_activate(void *
 		 */
 		debug_object_init(head, &rcuhead_debug_descr);
 		debug_object_activate(head, &rcuhead_debug_descr);
-		return 0;
+		return false;
 	default:
-		return 1;
+		return true;
 	}
 }
 
_

Patches currently in -mm which might be from changbin.du@intel.com are

debugobjects-make-fixup-functions-return-bool-instead-of-int.patch
debugobjects-correct-the-usage-of-fixup-call-results.patch
workqueue-update-debugobjects-fixup-callbacks-return-type.patch
timer-update-debugobjects-fixup-callbacks-return-type.patch
rcu-update-debugobjects-fixup-callbacks-return-type.patch
percpu_counter-update-debugobjects-fixup-callbacks-return-type.patch
documentation-update-debugobjects-doc.patch

