From: akpm@linux-foundation.org
Subject: [patch 012/117] rcu: update debugobjects fixup callbacks return
 type
Date: Thu, 19 May 2016 17:09:32 -0700
Message-ID: <573e55bc.ZoQCPLSyp+J/LKj2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbcETAJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org

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
