From: akpm@linux-foundation.org
Subject: + printk-avoid-double-lock-acquire.patch added to -mm tree
Date: Mon, 28 Nov 2011 15:54:42 -0800
Message-ID: <201111282354.pASNsgsm015654@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:36125 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1K1Xys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 18:54:48 -0500
Received: by eeuu44 with SMTP id u44so50260eeu.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 15:54:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, aarcange@redhat.com, mingo@elte.hu


The patch titled
     Subject: printk: avoid double lock acquire
has been added to the -mm tree.  Its filename is
     printk-avoid-double-lock-acquire.patch

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
From: Peter Zijlstra <peterz@infradead.org>
Subject: printk: avoid double lock acquire

Commit 4f2a8d3cf5e ("printk: Fix console_sem vs logbuf_lock unlock race")
introduced another silly bug where we would want to acquire an already
held lock.  Avoid this.

Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-avoid-double-lock-acquire kernel/printk.c
--- a/kernel/printk.c~printk-avoid-double-lock-acquire
+++ a/kernel/printk.c
@@ -1292,10 +1292,11 @@ again:
 	raw_spin_lock(&logbuf_lock);
 	if (con_start != log_end)
 		retry = 1;
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
 	if (retry && console_trylock())
 		goto again;
 
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 	if (wake_klogd)
 		wake_up_klogd();
 }
_
Subject: Subject: printk: avoid double lock acquire

Patches currently in -mm which might be from peterz@infradead.org are

linux-next.patch
printk-avoid-double-lock-acquire.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch

