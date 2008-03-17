From: akpm@linux-foundation.org
Subject: + idr-create-idr_layer_cache-at-boot-time.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:36:17 -0700
Message-ID: <200803172236.m2HMaH9x001896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374AbYCQWgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     idr: create idr_layer_cache at boot time
has been added to the -mm tree.  Its filename is
     idr-create-idr_layer_cache-at-boot-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: create idr_layer_cache at boot time
From: Akinobu Mita <akinobu.mita@gmail.com>

Avoid a possible kmem_cache_create() failure by creating idr_layer_cache
unconditionary at boot time rather than creating it on-demand when idr_init()
is called the first time.

This change also enables us to eliminate the check every time idr_init() is
called.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    2 ++
 init/main.c         |    2 ++
 lib/idr.c           |   10 ++++------
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/idr.h~idr-create-idr_layer_cache-at-boot-time include/linux/idr.h
--- a/include/linux/idr.h~idr-create-idr_layer_cache-at-boot-time
+++ a/include/linux/idr.h
@@ -115,4 +115,6 @@ void ida_remove(struct ida *ida, int id)
 void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
 
+void __init init_id_cache(void);
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
@@ -610,6 +611,7 @@ asmlinkage void __init start_kernel(void
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
 	kmem_cache_init();
+	init_id_cache();
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
+void __init init_id_cache(void)
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

block-fix-blk_register_queue-return-value.patch
ext2-improve-ext2_readdir-return-value.patch
ext2-use-ext2_group_first_block_no.patch
ext2-use-ext2_fsblk_t-type.patch
ext3-use-ext3_group_first_block_no.patch
ext3-add-missing-ext3_journal_stop.patch
ext3-use-ext3_get_group_desc.patch
ext3-check-ext3_journal_get_write_access-errors.patch
idr-create-idr_layer_cache-at-boot-time.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch

