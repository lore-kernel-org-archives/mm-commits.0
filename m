From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-do-not-include-rwlockh-directly.patch added
 to -mm tree
Date: Mon, 24 Feb 2020 13:57:51 -0800
Message-ID: <20200224215751.a0gDU8s5t%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbgBXV5w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 16:57:52 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, mm-commits@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, vitaly.wool@konsulko.com


The patch titled
     Subject: mm/z3fold.c: do not include rwlock.h directly
has been added to the -mm tree.  Its filename is
     mm-z3fold-do-not-include-rwlockh-directly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-do-not-include-rwlockh-directly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-do-not-include-rwlockh-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/z3fold.c: do not include rwlock.h directly

rwlock.h should not be included directly. Instead linux/splinlock.h
should be included. One thing it does is to break the RT build.

Link: http://lkml.kernel.org/r/20200224133631.1510569-1-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/z3fold.c~mm-z3fold-do-not-include-rwlockh-directly
+++ a/mm/z3fold.c
@@ -41,7 +41,6 @@
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/rwlock.h>
 #include <linux/zpool.h>
 #include <linux/magic.h>
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-z3fold-do-not-include-rwlockh-directly.patch
