From: akpm@linux-foundation.org
Subject: + lockdep-dont-print-lockdep-taint-message-for-lockdep.patch added to -mm tree
Date: Wed, 22 Apr 2009 14:01:51 -0700
Message-ID: <200904222101.n3ML1p68019237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbZDVVFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 17:05:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, a.p.zijlstra@chello.nl, ak@linux.intel.com, mingo@elte.hu


The patch titled
     lockdep: don't print lockdep taint message for !LOCKDEP
has been added to the -mm tree.  Its filename is
     lockdep-dont-print-lockdep-taint-message-for-lockdep.patch

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
Subject: lockdep: don't print lockdep taint message for !LOCKDEP
From: Andi Kleen <andi@firstfloor.org>

I was surprised to see a

Disabling lockdep due to kernel taint

message in my lockdep disabled kernel. This patch ifdefs this message
to not be printed when lockdep is not enabled.

BTW in my case it was due to a thermal event.  I'm not sure it's really
needed to disable lockdep on thermal events, but I left this alone for
now.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/panic.c~lockdep-dont-print-lockdep-taint-message-for-lockdep kernel/panic.c
--- a/kernel/panic.c~lockdep-dont-print-lockdep-taint-message-for-lockdep
+++ a/kernel/panic.c
@@ -213,6 +213,7 @@ unsigned long get_taint(void)
 
 void add_taint(unsigned flag)
 {
+#ifdef CONFIG_LOCKDEP
 	/*
 	 * Can't trust the integrity of the kernel anymore.
 	 * We don't call directly debug_locks_off() because the issue
@@ -222,6 +223,7 @@ void add_taint(unsigned flag)
 	 */
 	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
 		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
+#endif
 
 	set_bit(flag, &tainted_mask);
 }
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
x86-simplify-highmem-related-kconfig-entries.patch
lockdep-dont-print-lockdep-taint-message-for-lockdep.patch

