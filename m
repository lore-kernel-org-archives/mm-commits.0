From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 5/7] mm/z3fold.c: do not include rwlock.h directly
Date: Thu, 05 Mar 2020 22:28:39 -0800
Message-ID: <20200306062839.zZD64tHTn%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgCFG2k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Mar 2020 01:28:40 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bigeasy@linutronix.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, vitaly.wool@konsulko.com

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
