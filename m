From: akpm@linux-foundation.org
Subject: [merged] idr-make-idr_layer-larger.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:14 -0800
Message-ID: <20130228201614.BB53E5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:38453 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3B1UQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:15 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so245320ggn.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: make idr_layer larger
has been removed from the -mm tree.  Its filename was
     idr-make-idr_layer-larger.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: make idr_layer larger

With recent preloading changes, idr no longer keeps full layer cache per
each idr instance (used to be ~6.5k per idr on 64bit) and the previous
patch removed restriction on the bitmap size.  Both now allow us to have
larger layers.

Increase IDR_BITS to 8 regardless of BITS_PER_LONG.  Each layer is
slightly larger than 2k on 64bit and 1k on 32bit and carries 256 entries. 
The size isn't too large, especially compared to what we used to waste on
per-idr caches, and 256 entries should be able to serve most use cases
with single layer.  The max tree depth is 4 which is much better than the
previous 6 on 64bit and 7 on 32bit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN include/linux/idr.h~idr-make-idr_layer-larger include/linux/idr.h
--- a/include/linux/idr.h~idr-make-idr_layer-larger
+++ a/include/linux/idr.h
@@ -17,14 +17,13 @@
 #include <linux/init.h>
 #include <linux/rcupdate.h>
 
-#if BITS_PER_LONG == 32
-# define IDR_BITS 5
-#elif BITS_PER_LONG == 64
-# define IDR_BITS 6
-#else
-# error "BITS_PER_LONG is not 32 or 64"
-#endif
-
+/*
+ * We want shallower trees and thus more bits covered at each layer.  8
+ * bits gives us large enough first layer for most use cases and maximum
+ * tree depth of 4.  Each idr_layer is slightly larger than 2k on 64bit and
+ * 1k on 32bit.
+ */
+#define IDR_BITS 8
 #define IDR_SIZE (1 << IDR_BITS)
 #define IDR_MASK ((1 << IDR_BITS)-1)
 
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

