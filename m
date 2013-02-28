From: akpm@linux-foundation.org
Subject: [merged] idr-add-idr_layer-prefix.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:17 -0800
Message-ID: <20130228201617.C4DBE5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:64089 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3B1UQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:18 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so245303vch.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: add idr_layer->prefix
has been removed from the -mm tree.  Its filename was
     idr-add-idr_layer-prefix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: add idr_layer->prefix

Add a field which carries the prefix of ID the idr_layer covers.  This
will be used to implement lookup hint.

This patch doesn't make use of the new field and doesn't introduce any
behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    1 +
 lib/idr.c           |   13 +++++++++++++
 2 files changed, 14 insertions(+)

diff -puN include/linux/idr.h~idr-add-idr_layer-prefix include/linux/idr.h
--- a/include/linux/idr.h~idr-add-idr_layer-prefix
+++ a/include/linux/idr.h
@@ -28,6 +28,7 @@
 #define IDR_MASK ((1 << IDR_BITS)-1)
 
 struct idr_layer {
+	int			prefix;	/* the ID prefix of this idr_layer */
 	DECLARE_BITMAP(bitmap, IDR_SIZE); /* A zero bit means "space here" */
 	struct idr_layer __rcu	*ary[1<<IDR_BITS];
 	int			count;	/* When zero, we can release it */
diff -puN lib/idr.c~idr-add-idr_layer-prefix lib/idr.c
--- a/lib/idr.c~idr-add-idr_layer-prefix
+++ a/lib/idr.c
@@ -60,6 +60,16 @@ static int idr_max(int layers)
 	return (1 << bits) - 1;
 }
 
+/*
+ * Prefix mask for an idr_layer at @layer.  For layer 0, the prefix mask is
+ * all bits except for the lower IDR_BITS.  For layer 1, 2 * IDR_BITS, and
+ * so on.
+ */
+static int idr_layer_prefix_mask(int layer)
+{
+	return ~idr_max(layer + 1);
+}
+
 static struct idr_layer *get_from_free_list(struct idr *idp)
 {
 	struct idr_layer *p;
@@ -272,6 +282,7 @@ static int sub_alloc(struct idr *idp, in
 			if (!new)
 				return -ENOMEM;
 			new->layer = l-1;
+			new->prefix = id & idr_layer_prefix_mask(new->layer);
 			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
 		}
@@ -313,6 +324,7 @@ build_up:
 			 * upwards.
 			 */
 			p->layer++;
+			WARN_ON_ONCE(p->prefix);
 			continue;
 		}
 		if (!(new = idr_layer_alloc(gfp_mask, layer_idr))) {
@@ -334,6 +346,7 @@ build_up:
 		new->ary[0] = p;
 		new->count = 1;
 		new->layer = layers-1;
+		new->prefix = id & idr_layer_prefix_mask(new->layer);
 		if (bitmap_full(p->bitmap, IDR_SIZE))
 			__set_bit(0, new->bitmap);
 		p = new;
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

