From: akpm@linux-foundation.org
Subject: + debugobjects-correct-the-usage-of-fixup-call-results.patch
 added to -mm tree
Date: Fri, 22 Apr 2016 13:02:02 -0700
Message-ID: <571a833a.8JVw1pgXSEHuR3j2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbcDVUCD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:02:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects: correct the usage of fixup call results
has been added to the -mm tree.  Its filename is
     debugobjects-correct-the-usage-of-fixup-call-results.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/debugobjects-correct-the-usage-of-fixup-call-results.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/debugobjects-correct-the-usage-of-fixup-call-results.patch

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
Subject: debugobjects: correct the usage of fixup call results

If debug_object_fixup() return non-zero when problem has been fixed.  But
the code got it backwards, it taks 0 as fixup successfully.  So fix it.

Signed-off-by: Du, Changbin <changbin.du@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/debugobjects.c~debugobjects-correct-the-usage-of-fixup-call-results lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-correct-the-usage-of-fixup-call-results
+++ a/lib/debugobjects.c
@@ -415,7 +415,7 @@ int debug_object_activate(void *addr, st
 			state = obj->state;
 			raw_spin_unlock_irqrestore(&db->lock, flags);
 			ret = debug_object_fixup(descr->fixup_activate, addr, state);
-			return ret ? -EINVAL : 0;
+			return ret ? 0 : -EINVAL;
 
 		case ODEBUG_STATE_DESTROYED:
 			debug_print_object(obj, "activate");
_

Patches currently in -mm which might be from changbin.du@intel.com are

debugobjects-make-fixup-functions-return-bool-instead-of-int.patch
debugobjects-correct-the-usage-of-fixup-call-results.patch
workqueue-update-debugobjects-fixup-callbacks-return-type.patch
timer-update-debugobjects-fixup-callbacks-return-type.patch
rcu-update-debugobjects-fixup-callbacks-return-type.patch
percpu_counter-update-debugobjects-fixup-callbacks-return-type.patch
documentation-update-debugobjects-doc.patch

