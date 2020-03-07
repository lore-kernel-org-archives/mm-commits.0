From: akpm@linux-foundation.org
Subject: [merged] mm-z3fold-do-not-include-rwlockh-directly.patch
 removed from -mm tree
Date: Fri, 06 Mar 2020 20:01:25 -0800
Message-ID: <20200307040125.Ahuq0nTFI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCGEB0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Mar 2020 23:01:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, mm-commits@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, vitaly.wool@konsulko.com


The patch titled
     Subject: mm/z3fold.c: do not include rwlock.h directly
has been removed from the -mm tree.  Its filename was
     mm-z3fold-do-not-include-rwlockh-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

really-limit-compact_unevictable_allowed-to-0-and-1.patch
mm-compaction-disable-compact_unevictable_allowed-on-rt.patch
