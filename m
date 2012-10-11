From: akpm@linux-foundation.org
Subject: [merged] lglock-remove-unused-define_lglock_lockdep.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:29 -0700
Message-ID: <20121011205930.174455C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:33382 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab2JKU7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:32 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so141759wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, ak@linux.intel.com, rusty@rustcorp.com.au, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lglock: remove unused DEFINE_LGLOCK_LOCKDEP()
has been removed from the -mm tree.  Its filename was
     lglock-remove-unused-define_lglock_lockdep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: lglock: remove unused DEFINE_LGLOCK_LOCKDEP()

struct lglocks use their own lock_key/lock_dep_map which are defined in
struct lglock.  DEFINE_LGLOCK_LOCKDEP() is unused, so remove it and save a
small piece of memory.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lglock.h |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN include/linux/lglock.h~lglock-remove-unused-define_lglock_lockdep include/linux/lglock.h
--- a/include/linux/lglock.h~lglock-remove-unused-define_lglock_lockdep
+++ a/include/linux/lglock.h
@@ -36,16 +36,8 @@
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
-
-#define DEFINE_LGLOCK_LOCKDEP(name)					\
- struct lock_class_key name##_lock_key;					\
- struct lockdep_map name##_lock_dep_map;				\
- EXPORT_SYMBOL(name##_lock_dep_map)
-
 #else
 #define LOCKDEP_INIT_MAP(a, b, c, d)
