From: akpm@linux-foundation.org
Subject: [merged]
 workqueue-update-debugobjects-fixup-callbacks-return-type.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:02:40 -0700
Message-ID: <573f7b70.9AtWKYyDtDgJIeTi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: workqueue: update debugobjects fixup callbacks return type
has been removed from the -mm tree.  Its filename was
     workqueue-update-debugobjects-fixup-callbacks-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Du, Changbin" <changbin.du@intel.com>
Subject: workqueue: update debugobjects fixup callbacks return type

Update the return type to use bool instead of int, corresponding to
change (debugobjects: make fixup functions return bool instead of int)

Signed-off-by: Du, Changbin <changbin.du@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN kernel/workqueue.c~workqueue-update-debugobjects-fixup-callbacks-return-type kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-update-debugobjects-fixup-callbacks-return-type
+++ a/kernel/workqueue.c
@@ -437,7 +437,7 @@ static void *work_debug_hint(void *addr)
  * fixup_init is called when:
  * - an active object is initialized
  */
-static int work_fixup_init(void *addr, enum debug_obj_state state)
+static bool work_fixup_init(void *addr, enum debug_obj_state state)
 {
 	struct work_struct *work = addr;
 
@@ -445,9 +445,9 @@ static int work_fixup_init(void *addr, e
 	case ODEBUG_STATE_ACTIVE:
 		cancel_work_sync(work);
 		debug_object_init(work, &work_debug_descr);
-		return 1;
+		return true;
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -456,7 +456,7 @@ static int work_fixup_init(void *addr, e
  * - an active object is activated
  * - an unknown object is activated (might be a statically initialized object)
  */
-static int work_fixup_activate(void *addr, enum debug_obj_state state)
+static bool work_fixup_activate(void *addr, enum debug_obj_state state)
 {
 	struct work_struct *work = addr;
 
@@ -471,16 +471,16 @@ static int work_fixup_activate(void *add
 		if (test_bit(WORK_STRUCT_STATIC_BIT, work_data_bits(work))) {
 			debug_object_init(work, &work_debug_descr);
 			debug_object_activate(work, &work_debug_descr);
-			return 0;
+			return false;
 		}
 		WARN_ON_ONCE(1);
-		return 0;
+		return false;
 
 	case ODEBUG_STATE_ACTIVE:
 		WARN_ON(1);
 
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -488,7 +488,7 @@ static int work_fixup_activate(void *add
  * fixup_free is called when:
  * - an active object is freed
  */
-static int work_fixup_free(void *addr, enum debug_obj_state state)
+static bool work_fixup_free(void *addr, enum debug_obj_state state)
 {
 	struct work_struct *work = addr;
 
@@ -496,9 +496,9 @@ static int work_fixup_free(void *addr, e
 	case ODEBUG_STATE_ACTIVE:
 		cancel_work_sync(work);
 		debug_object_free(work, &work_debug_descr);
-		return 1;
+		return true;
 	default:
-		return 0;
+		return false;
 	}
 }
 
_

Patches currently in -mm which might be from changbin.du@intel.com are

checkpatch-add-support-to-check-already-applied-git-commits.patch

