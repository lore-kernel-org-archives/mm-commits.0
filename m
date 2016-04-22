From: akpm@linux-foundation.org
Subject: +
 percpu_counter-update-debugobjects-fixup-callbacks-return-type.patch added
 to -mm tree
Date: Fri, 22 Apr 2016 13:02:10 -0700
Message-ID: <571a8342.5YvF6Ug2Q0HXgmVS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbcDVUCL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:02:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: percpu_counter: update debugobjects fixup callbacks return type
has been added to the -mm tree.  Its filename is
     percpu_counter-update-debugobjects-fixup-callbacks-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/percpu_counter-update-debugobjects-fixup-callbacks-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/percpu_counter-update-debugobjects-fixup-callbacks-return-type.patch

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
Subject: percpu_counter: update debugobjects fixup callbacks return type

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

 lib/percpu_counter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/percpu_counter.c~percpu_counter-update-debugobjects-fixup-callbacks-return-type lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu_counter-update-debugobjects-fixup-callbacks-return-type
+++ a/lib/percpu_counter.c
@@ -19,7 +19,7 @@ static DEFINE_SPINLOCK(percpu_counters_l
 
 static struct debug_obj_descr percpu_counter_debug_descr;
 
-static int percpu_counter_fixup_free(void *addr, enum debug_obj_state state)
+static bool percpu_counter_fixup_free(void *addr, enum debug_obj_state state)
 {
 	struct percpu_counter *fbc = addr;
 
@@ -27,9 +27,9 @@ static int percpu_counter_fixup_free(voi
 	case ODEBUG_STATE_ACTIVE:
 		percpu_counter_destroy(fbc);
 		debug_object_free(fbc, &percpu_counter_debug_descr);
-		return 1;
+		return true;
 	default:
-		return 0;
+		return false;
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

