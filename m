From: akpm@linux-foundation.org
Subject: [patch 009/117] debugobjects: correct the usage of fixup call
 results
Date: Thu, 19 May 2016 17:09:23 -0700
Message-ID: <573e55b3.42MWYnE6bz8oRTgV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbcETAJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org

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
