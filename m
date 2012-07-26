From: akpm@linux-foundation.org
Subject: + spinlock_debug-print-offset-in-addition-to-symbol-name.patch added to -mm tree
Date: Thu, 26 Jul 2012 13:21:25 -0700
Message-ID: <20120726202125.9878F1E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49122 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2GZUV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jul 2012 16:21:26 -0400
Received: by qabg24 with SMTP id g24so272269qab.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jul 2012 13:21:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org


The patch titled
     Subject: spinlock_debug: print offset in addition to symbol name
has been added to the -mm tree.  Its filename is
     spinlock_debug-print-offset-in-addition-to-symbol-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: spinlock_debug: print offset in addition to symbol name

If there are two spinlocks embedded in a structure that kallsyms knows
about and one of the spinlocks locks up we will print the name of the
containing structure instead of the address of the lock.  This is quite
bad, so let's use %pS instead of %ps so we get an offset in addition to
the symbol so we can determine which particular lock is having problems.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/spinlock_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/spinlock_debug.c~spinlock_debug-print-offset-in-addition-to-symbol-name lib/spinlock_debug.c
--- a/lib/spinlock_debug.c~spinlock_debug-print-offset-in-addition-to-symbol-name
+++ a/lib/spinlock_debug.c
@@ -58,7 +58,7 @@ static void spin_dump(raw_spinlock_t *lo
 	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
 		msg, raw_smp_processor_id(),
 		current->comm, task_pid_nr(current));
-	printk(KERN_EMERG " lock: %ps, .magic: %08x, .owner: %s/%d, "
+	printk(KERN_EMERG " lock: %pS, .magic: %08x, .owner: %s/%d, "
 			".owner_cpu: %d\n",
 		lock, lock->magic,
 		owner ? owner->comm : "<none>",
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch
panic-fix-a-possible-deadlock-in-panic.patch
spinlock_debug-print-offset-in-addition-to-symbol-name.patch

