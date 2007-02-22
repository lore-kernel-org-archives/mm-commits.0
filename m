From: akpm@linux-foundation.org
Subject: + kernel-doc-fixes-for-2620-git15-non-drivers.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:33:36 -0800
Message-ID: <200702220033.l1M0Xaua031369@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59565 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965134AbXBVAdk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:33:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc fixes for 2.6.20-git15 (non-drivers)
has been added to the -mm tree.  Its filename is
     kernel-doc-fixes-for-2620-git15-non-drivers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc fixes for 2.6.20-git15 (non-drivers)
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in 2.6.20-git15 (lib/, mm/, kernel/, include/).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |    1 +
 kernel/relay.c          |    3 +--
 kernel/timer.c          |    1 +
 lib/bitmap.c            |   16 ++++++++--------
 mm/slab.c               |    2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

diff -puN include/linux/hrtimer.h~kernel-doc-fixes-for-2620-git15-non-drivers include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~kernel-doc-fixes-for-2620-git15-non-drivers
+++ a/include/linux/hrtimer.h
@@ -140,6 +140,7 @@ struct hrtimer_sleeper {
 
 /**
  * struct hrtimer_base - the timer base for a specific clock
+ * @cpu_base:		per cpu clock base
  * @index:		clock type index for per_cpu support when moving a
  *			timer to a base on another cpu.
  * @active:		red black tree root node for the active timers
diff -puN kernel/relay.c~kernel-doc-fixes-for-2620-git15-non-drivers kernel/relay.c
--- a/kernel/relay.c~kernel-doc-fixes-for-2620-git15-non-drivers
+++ a/kernel/relay.c
@@ -474,13 +474,12 @@ static void setup_callbacks(struct rchan
 }
 
 /**
- *
  * 	relay_hotcpu_callback - CPU hotplug callback
  * 	@nb: notifier block
  * 	@action: hotplug action to take
  * 	@hcpu: CPU number
  *
- * 	Returns the success/failure of the operation. (NOTIFY_OK, NOTIFY_BAD)
+ * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
  */
 static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
 				unsigned long action,
diff -puN kernel/timer.c~kernel-doc-fixes-for-2620-git15-non-drivers kernel/timer.c
--- a/kernel/timer.c~kernel-doc-fixes-for-2620-git15-non-drivers
+++ a/kernel/timer.c
@@ -711,6 +711,7 @@ static unsigned long cmp_next_hrtimer_ev
 
 /**
  * next_timer_interrupt - return the jiffy of the next pending timer
+ * @now: current time (in jiffies)
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
diff -puN lib/bitmap.c~kernel-doc-fixes-for-2620-git15-non-drivers lib/bitmap.c
--- a/lib/bitmap.c~kernel-doc-fixes-for-2620-git15-non-drivers
+++ a/lib/bitmap.c
@@ -97,10 +97,10 @@ EXPORT_SYMBOL(__bitmap_complement);
 
 /**
  * __bitmap_shift_right - logical right shift of the bits in a bitmap
- *   @dst - destination bitmap
- *   @src - source bitmap
- *   @nbits - shift by this many bits
- *   @bits - bitmap size, in bits
+ *   @dst : destination bitmap
+ *   @src : source bitmap
+ *   @shift : shift by this many bits
+ *   @bits : bitmap size, in bits
  *
  * Shifting right (dividing) means moving bits in the MS -> LS bit
  * direction.  Zeros are fed into the vacated MS positions and the
@@ -141,10 +141,10 @@ EXPORT_SYMBOL(__bitmap_shift_right);
 
 /**
  * __bitmap_shift_left - logical left shift of the bits in a bitmap
- *   @dst - destination bitmap
- *   @src - source bitmap
- *   @nbits - shift by this many bits
- *   @bits - bitmap size, in bits
+ *   @dst : destination bitmap
+ *   @src : source bitmap
+ *   @shift : shift by this many bits
+ *   @bits : bitmap size, in bits
  *
  * Shifting left (multiplying) means moving bits in the LS -> MS
  * direction.  Zeros are fed into the vacated LS bit positions
diff -puN mm/slab.c~kernel-doc-fixes-for-2620-git15-non-drivers mm/slab.c
--- a/mm/slab.c~kernel-doc-fixes-for-2620-git15-non-drivers
+++ a/mm/slab.c
@@ -4026,7 +4026,7 @@ void drain_array(struct kmem_cache *cach
 
 /**
  * cache_reap - Reclaim memory from caches.
- * @unused: unused parameter
+ * @w: work descriptor
  *
  * Called from workqueue/eventd every few seconds.
  * Purpose:
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-allow-space-after-__attribute__.patch
kernel-doc-fixes-for-2620-git15-non-drivers.patch
fusion-kernel-doc-warning-fixes.patch
git-drm.patch
git-libata-all.patch
phy-layer-add-kernel-doc-docbook.patch
git-parisc.patch
x86-dont-probe-for-ddc-on-vbe12.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
