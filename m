From: akpm@linux-foundation.org
Subject: - slub-more-documentation.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:06:23 -0700
Message-ID: <200706010706.l5176MV9004710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754455AbXFAHG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:06:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     SLUB: More documentation
has been removed from the -mm tree.  Its filename was
     slub-more-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: More documentation
From: Christoph Lameter <clameter@sgi.com>

Update documentation to describe how to read a SLUB error report.
Add slub parameters to Documentation/kernel-parameters.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   37 ++++++-
 Documentation/vm/slub.txt           |  133 ++++++++++++++++++++++++--
 2 files changed, 157 insertions(+), 13 deletions(-)

diff -puN Documentation/kernel-parameters.txt~slub-more-documentation Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~slub-more-documentation
+++ a/Documentation/kernel-parameters.txt
@@ -1132,9 +1132,9 @@ and is between 256 and 4096 characters. 
 			when set.
 			Format: <int>
 
-	noaliencache	[MM, NUMA] Disables the allcoation of alien caches in
-			the slab allocator.  Saves per-node memory, but will
-			impact performance on real NUMA hardware.
+	noaliencache	[MM, NUMA, SLAB] Disables the allocation of alien
+			caches in the slab allocator.  Saves per-node memory,
+			but will impact performance.
 
 	noalign		[KNL,ARM]
 
@@ -1613,6 +1613,37 @@ and is between 256 and 4096 characters. 
 
 	slram=		[HW,MTD]
 
+	slub_debug	[MM, SLUB]
+			Enabling slub_debug allows one to determine the culprit
+			if slab objects become corrupted. Enabling slub_debug
+			creates guard zones around objects and poisons objects
+			when not in use. Also tracks the last alloc / free.
+			For more information see Documentation/vm/slub.txt.
+
+	slub_max_order= [MM, SLUB]
+			Determines the maximum allowed order for slabs. Setting
+			this too high may cause fragmentation.
+			For more information see Documentation/vm/slub.txt.
+
+	slub_min_objects=	[MM, SLUB]
+			The minimum objects per slab. SLUB will increase the
+			slab order up to slub_max_order to generate a
+			sufficiently big slab to satisfy the number of objects.
+			The higher the number of objects the smaller the overhead
+			of tracking slabs.
+			For more information see Documentation/vm/slub.txt.
+
+	slub_min_order=	[MM, SLUB]
+			Determines the mininum page order for slabs. Must be
+			lower than slub_max_order
+			For more information see Documentation/vm/slub.txt.
+
+	slub_nomerge	[MM, SLUB]
+			Disable merging of slabs of similar size. May be
+			necessary if there is some reason to distinguish
+			allocs to different slabs.
+			For more information see Documentation/vm/slub.txt.
+
 	smart2=		[HW]
 			Format: <io1>[,<io2>[,...,<io8>]]
 
diff -puN Documentation/vm/slub.txt~slub-more-documentation Documentation/vm/slub.txt
--- a/Documentation/vm/slub.txt~slub-more-documentation
+++ a/Documentation/vm/slub.txt
@@ -1,13 +1,9 @@
 Short users guide for SLUB
 --------------------------
 
-First of all slub should transparently replace SLAB. If you enable
-SLUB then everything should work the same (Note the word "should".
-There is likely not much value in that word at this point).
-
 The basic philosophy of SLUB is very different from SLAB. SLAB
 requires rebuilding the kernel to activate debug options for all
-SLABS. SLUB always includes full debugging but its off by default.
+slab caches. SLUB always includes full debugging but it is off by default.
 SLUB can enable debugging only for selected slabs in order to avoid
 an impact on overall system performance which may make a bug more
 difficult to find.
@@ -76,13 +72,28 @@ of objects.
 Careful with tracing: It may spew out lots of information and never stop if
 used on the wrong slab.
 
-SLAB Merging
+Slab merging
 ------------
 
-If no debugging is specified then SLUB may merge similar slabs together
+If no debug options are specified then SLUB may merge similar slabs together
 in order to reduce overhead and increase cache hotness of objects.
 slabinfo -a displays which slabs were merged together.
 
+Slab validation
+---------------
+
+SLUB can validate all object if the kernel was booted with slub_debug. In
+order to do so you must have the slabinfo tool. Then you can do
+
+slabinfo -v
+
+which will test all objects. Output will be generated to the syslog.
+
+This also works in a more limited way if boot was without slab debug.
+In that case slabinfo -v simply tests all reachable objects. Usually
+these are in the cpu slabs and the partial slabs. Full slabs are not
+tracked by SLUB in a non debug situation.
+
 Getting more performance
 ------------------------
 
@@ -91,9 +102,9 @@ list_lock once in a while to deal with p
 governed by the order of the allocation for each slab. The allocations
 can be influenced by kernel parameters:
 
-slub_min_objects=x		(default 8)
+slub_min_objects=x		(default 4)
 slub_min_order=x		(default 0)
-slub_max_order=x		(default 4)
+slub_max_order=x		(default 1)
 
 slub_min_objects allows to specify how many objects must at least fit
 into one slab in order for the allocation order to be acceptable.
@@ -109,5 +120,107 @@ longer be checked. This is useful to avo
 super large order pages to fit slub_min_objects of a slab cache with
 large object sizes into one high order page.
 
+SLUB Debug output
+-----------------
+
+Here is a sample of slub debug output:
+
+*** SLUB kmalloc-8: Redzone Active@0xc90f6d20 slab 0xc528c530 offset=3360 flags=0x400000c3 inuse=61 freelist=0xc90f6d58
+  Bytes b4 0xc90f6d10:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
+    Object 0xc90f6d20:  31 30 31 39 2e 30 30 35                         1019.005
+   Redzone 0xc90f6d28:  00 cc cc cc                                     .
+FreePointer 0xc90f6d2c -> 0xc90f6d58
+Last alloc: get_modalias+0x61/0xf5 jiffies_ago=53 cpu=1 pid=554
+Filler 0xc90f6d50:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
+  [<c010523d>] dump_trace+0x63/0x1eb
+  [<c01053df>] show_trace_log_lvl+0x1a/0x2f
+  [<c010601d>] show_trace+0x12/0x14
+  [<c0106035>] dump_stack+0x16/0x18
+  [<c017e0fa>] object_err+0x143/0x14b
+  [<c017e2cc>] check_object+0x66/0x234
+  [<c017eb43>] __slab_free+0x239/0x384
+  [<c017f446>] kfree+0xa6/0xc6
+  [<c02e2335>] get_modalias+0xb9/0xf5
+  [<c02e23b7>] dmi_dev_uevent+0x27/0x3c
+  [<c027866a>] dev_uevent+0x1ad/0x1da
+  [<c0205024>] kobject_uevent_env+0x20a/0x45b
+  [<c020527f>] kobject_uevent+0xa/0xf
+  [<c02779f1>] store_uevent+0x4f/0x58
+  [<c027758e>] dev_attr_store+0x29/0x2f
+  [<c01bec4f>] sysfs_write_file+0x16e/0x19c
+  [<c0183ba7>] vfs_write+0xd1/0x15a
+  [<c01841d7>] sys_write+0x3d/0x72
+  [<c0104112>] sysenter_past_esp+0x5f/0x99
+  [<b7f7b410>] 0xb7f7b410
+  =======================
+@@@ SLUB kmalloc-8: Restoring redzone (0xcc) from 0xc90f6d28-0xc90f6d2b
+
+
+
+If SLUB encounters a corrupted object then it will perform the following
+actions:
+
+1. Isolation and report of the issue
+
+This will be a message in the system log starting with
+
+*** SLUB <slab cache affected>: <What went wrong>@<object address>
+offset=<offset of object into slab> flags=<slabflags>
+inuse=<objects in use in this slab> freelist=<first free object in slab>
+
+2. Report on how the problem was dealt with in order to ensure the continued
+operation of the system.
+
+These are messages in the system log beginning with
+
+@@@ SLUB <slab cache affected>: <corrective action taken>
+
+
+In the above sample SLUB found that the Redzone of an active object has
+been overwritten. Here a string of 8 characters was written into a slab that
+has the length of 8 characters. However, a 8 character string needs a
+terminating 0. That zero has overwritten the first byte of the Redzone field.
+After reporting the details of the issue encountered the @@@ SLUB message
+tell us that SLUB has restored the redzone to its proper value and then
+system operations continue.
+
+Various types of lines can follow the @@@ SLUB line:
+
+Bytes b4 <address> : <bytes>
+	Show a few bytes before the object where the problem was detected.
+	Can be useful if the corruption does not stop with the start of the
+	object.
+
+Object <address> : <bytes>
+	The bytes of the object. If the object is inactive then the bytes
+	typically contain poisoning values. Any non-poison value shows a
+	corruption by a write after free.
+
+Redzone <address> : <bytes>
+	The redzone following the object. The redzone is used to detect
+	writes after the object. All bytes should always have the same
+	value. If there is any deviation then it is due to a write after
+	the object boundary.
+
+Freepointer
+	The pointer to the next free object in the slab. May become
+	corrupted if overwriting continues after the red zone.
+
+Last alloc:
+Last free:
+	Shows the address from which the object was allocated/freed last.
+	We note the pid, the time and the CPU that did so. This is usually
+	the most useful information to figure out where things went wrong.
+	Here get_modalias() did an kmalloc(8) instead of a kmalloc(9).
+
+Filler <address> : <bytes>
+	Unused data to fill up the space in order to get the next object
+	properly aligned. In the debug case we make sure that there are
+	at least 4 bytes of filler. This allow for the detection of writes
+	before the object.
+
+Following the filler will be a stackdump. That stackdump describes the
+location where the error was detected. The cause of the corruption is more
+likely to be found by looking at the information about the last alloc / free.
 
-Christoph Lameter, <clameter@sgi.com>, April 10, 2007
+Christoph Lameter, <clameter@sgi.com>, May 23, 2007
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slub-fix-locking-for-hotplug-callbacks.patch
slab-fix-slab-debug-for-non-alien-caches.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
hexdump-more-output-formatting.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
