From: akpm@linux-foundation.org
Subject: - idr-create-idr_layer_cache-at-boot-time.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:37 -0700
Message-ID: <200804300548.m3U5mbJe029894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758707AbYD3FtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     idr: create idr_layer_cache at boot time
has been removed from the -mm tree.  Its filename was
     idr-create-idr_layer_cache-at-boot-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: create idr_layer_cache at boot time
From: Akinobu Mita <akinobu.mita@gmail.com>

Avoid a possible kmem_cache_create() failure by creating idr_layer_cache
unconditionary at boot time rather than creating it on-demand when idr_init()
is called the first time.

This change also enables us to eliminate the check every time idr_init() is
called.

[akpm@linux-foundation.org: rename init_id_cache() to idr_init_cache()]
[akpm@linux-foundation.org: fix alpha build]
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    3 +++
 init/main.c         |    2 ++
 lib/idr.c           |   10 ++++------
 3 files changed, 9 insertions(+), 6 deletions(-)

diff -puN include/linux/idr.h~idr-create-idr_layer_cache-at-boot-time include/linux/idr.h
--- a/include/linux/idr.h~idr-create-idr_layer_cache-at-boot-time
+++ a/include/linux/idr.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/init.h>
 
 #if BITS_PER_LONG == 32
 # define IDR_BITS 5
@@ -115,4 +116,6 @@ void ida_remove(struct ida *ida, int id)
 void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
 
+void __init idr_init_cache(void);
+
 #endif /* __IDR_H__ */
diff -puN init/main.c~idr-create-idr_layer_cache-at-boot-time init/main.c
--- a/init/main.c~idr-create-idr_layer_cache-at-boot-time
+++ a/init/main.c
@@ -58,6 +58,7 @@
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
+#include <linux/idr.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -637,6 +638,7 @@ asmlinkage void __init start_kernel(void
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
 	kmem_cache_init();
+	idr_init_cache();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)
diff -puN lib/idr.c~idr-create-idr_layer_cache-at-boot-time lib/idr.c
--- a/lib/idr.c~idr-create-idr_layer_cache-at-boot-time
+++ a/lib/idr.c
@@ -585,12 +585,11 @@ static void idr_cache_ctor(struct kmem_c
 	memset(idr_layer, 0, sizeof(struct idr_layer));
 }
 
-static  int init_id_cache(void)
+void __init idr_init_cache(void)
 {
-	if (!idr_layer_cache)
-		idr_layer_cache = kmem_cache_create("idr_layer_cache",
-			sizeof(struct idr_layer), 0, 0, idr_cache_ctor);
-	return 0;
+	idr_layer_cache = kmem_cache_create("idr_layer_cache",
+				sizeof(struct idr_layer), 0, SLAB_PANIC,
+				idr_cache_ctor);
 }
 
 /**
@@ -602,7 +601,6 @@ static  int init_id_cache(void)
  */
 void idr_init(struct idr *idp)
 {
-	init_id_cache();
 	memset(idp, 0, sizeof(struct idr));
 	spin_lock_init(&idp->lock);
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

