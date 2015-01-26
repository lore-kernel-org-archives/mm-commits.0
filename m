From: akpm@linux-foundation.org
Subject: + cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch added to -mm tree
Date: Mon, 26 Jan 2015 15:06:45 -0800
Message-ID: <54c6c885.F9bjZ4LBzxLTU49N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbAZXGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 18:06:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org, chris@zankel.net, cl@linux.com, cmetcalf@tilera.com, davem@davemloft.net, dmitry.torokhov@gmail.com, fenghua.yu@intel.com, gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, linux@arm.linux.org.uk, linville@tuxdriver.com, lizefan@huawei.com, mingo@redhat.com, paulmck@linux.vnet.ibm.com, penberg@kernel.org, peterz@infradead.org, rostedt@goodmis.org, rusty@rustcorp.com.au, steffen.klassert@secunet.com, tglx@linutronix.de, tony.luck@intel.com, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask, nodemask: implement cpumask/nodemask_pr_args()
has been added to the -mm tree.  Its filename is
     cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: cpumask, nodemask: implement cpumask/nodemask_pr_args()

printf family of functions can now format bitmaps using '%*pb[l]' and
all cpumask and nodemask formatting will be converted to use it.  To
ease printing these masks with '%*pb[l]' which require two params -
the number of bits and the actual bitmap, this patch implement
cpumask_pr_args() and nodemask_pr_args() which can be used to provide
arguments for '%*pb[l]'

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h  |    8 ++++++++
 include/linux/nodemask.h |    8 ++++++++
 2 files changed, 16 insertions(+)

diff -puN include/linux/cpumask.h~cpumask-nodemask-implement-cpumask-nodemask_pr_args include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-nodemask-implement-cpumask-nodemask_pr_args
+++ a/include/linux/cpumask.h
@@ -22,6 +22,14 @@ typedef struct cpumask { DECLARE_BITMAP(
  */
 #define cpumask_bits(maskp) ((maskp)->bits)
 
+/**
+ * cpumask_pr_args - printf args to output a cpumask
+ * @maskp: cpumask to be printed
+ *
+ * Can be used to provide arguments for '%*pb[l]' when printing a cpumask.
+ */
+#define cpumask_pr_args(maskp)		nr_cpu_ids, cpumask_bits(maskp)
+
 #if NR_CPUS == 1
 #define nr_cpu_ids		1
 #else
diff -puN include/linux/nodemask.h~cpumask-nodemask-implement-cpumask-nodemask_pr_args include/linux/nodemask.h
--- a/include/linux/nodemask.h~cpumask-nodemask-implement-cpumask-nodemask_pr_args
+++ a/include/linux/nodemask.h
@@ -98,6 +98,14 @@
 typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
 extern nodemask_t _unused_nodemask_arg_;
 
+/**
+ * nodemask_pr_args - printf args to output a nodemask
+ * @maskp: nodemask to be printed
+ *
+ * Can be used to provide arguments for '%*pb[l]' when printing a nodemask.
+ */
+#define nodemask_pr_args(maskp)		MAX_NUMNODES, (maskp)->bits
+
 /*
  * The inline keyword gives the compiler room to decide to inline, or
  * not inline a function as it sees best.  However, as these functions
_

Patches currently in -mm which might be from tj@kernel.org are

block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
kernfs-remove-kernfs_static_name.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions.patch
lib-vsprintf-implement-bitmap-printing-through-%pb.patch
cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch
bitmap-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
ia64-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
xtensa-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
arm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
rcu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
sched-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
time-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
percpu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
workqueue-use-%pb-to-format-bitmaps-including-cpumasks-and-nodemasks.patch
tracing-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
input-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
scsi-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
drivers-base-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
slub-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
mm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
padata-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
proc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
irq-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
profile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
bitmap-cpumask-nodemask-remove-dedicated-formatting-functions.patch
linux-next.patch

