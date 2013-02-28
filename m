From: akpm@linux-foundation.org
Subject: [merged] idr-cosmetic-updates-to-struct-initializer-definitions.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:57 -0800
Message-ID: <20130228201258.1432031C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:56885 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab3B1UM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:59 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so244967qea.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: cosmetic updates to struct / initializer definitions
has been removed from the -mm tree.  Its filename was
     idr-cosmetic-updates-to-struct-initializer-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: cosmetic updates to struct / initializer definitions

* Tab align fields like a normal person.

* Drop the unnecessary 0 inits from IDR_INIT().

This patch is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN include/linux/idr.h~idr-cosmetic-updates-to-struct-initializer-definitions include/linux/idr.h
--- a/include/linux/idr.h~idr-cosmetic-updates-to-struct-initializer-definitions
+++ a/include/linux/idr.h
@@ -49,28 +49,24 @@
 #define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
 
 struct idr_layer {
-	unsigned long		 bitmap; /* A zero bit means "space here" */
+	unsigned long		bitmap;	/* A zero bit means "space here" */
 	struct idr_layer __rcu	*ary[1<<IDR_BITS];
-	int			 count;	 /* When zero, we can release it */
-	int			 layer;	 /* distance from leaf */
-	struct rcu_head		 rcu_head;
+	int			count;	/* When zero, we can release it */
+	int			layer;	/* distance from leaf */
+	struct rcu_head		rcu_head;
 };
 
 struct idr {
-	struct idr_layer __rcu *top;
-	struct idr_layer *id_free;
-	int		  layers; /* only valid without concurrent changes */
-	int		  id_free_cnt;
-	spinlock_t	  lock;
+	struct idr_layer __rcu	*top;
+	struct idr_layer	*id_free;
+	int			layers;	/* only valid w/o concurrent changes */
+	int			id_free_cnt;
+	spinlock_t		lock;
 };
 
-#define IDR_INIT(name)						\
-{								\
-	.top		= NULL,					\
-	.id_free	= NULL,					\
-	.layers 	= 0,					\
-	.id_free_cnt	= 0,					\
-	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+#define IDR_INIT(name)							\
+{									\
+	.lock			= __SPIN_LOCK_UNLOCKED(name.lock),	\
 }
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

