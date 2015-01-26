From: akpm@linux-foundation.org
Subject: +
 cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions.patch
 added to -mm tree
Date: Mon, 26 Jan 2015 15:06:39 -0800
Message-ID: <54c6c87f.8seA7QSaeyKjHy+k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbAZXGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 18:06:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org, chris@zankel.net, cl@linux.com, cmetcalf@tilera.com, davem@davemloft.net, dmitry.torokhov@gmail.com, fenghua.yu@intel.com, gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, linux@arm.linux.org.uk, linville@tuxdriver.com, lizefan@huawei.com, mingo@redhat.com, paulmck@linux.vnet.ibm.com, penberg@kernel.org, peterz@infradead.org, rostedt@goodmis.org, rusty@rustcorp.com.au, steffen.klassert@secunet.com, tglx@linutronix.de, tony.luck@intel.com, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: always use nr_cpu_ids in formatting and parsing functions
has been added to the -mm tree.  Its filename is
     cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions.patch

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
Subject: cpumask: always use nr_cpu_ids in formatting and parsing functions

bitmap implements two variants of scnprintf functions to format a bitmap
into a string and cpumask and nodemask wrap them to provide equivalent
interfaces.  The scnprintf family of functions require a string buffer as
an output target which complicates code paths which just want to print out
the mask through printk for informational or debug purposes as they have
to worry about how large the buffer should be and whether it's too large
to allocate on stack.

Neither cpumask or nodemask provides a guildeline on how large the target
buffer should be forcing users come up with their own solutions - some
allocate an arbitrarily sized buffer which is small enough to allocate on
stack but may be too short in corner cases, other come up with a custom
upper limit calculation considering the output format, some allocate the
buffer dynamically while one resorted to using lock to synchronize access
to a static buffer.

This is an artificial problem which is being solved repeatedly for no
benefit.  In a lot of cases, the output area already exists and can be
targeted directly making the intermediate buffer unnecessary.  This
patchset teaches printf family of functions how to format bitmaps and
replace the dedicated formatting functions with it.

Pointer formatting is extended to cover bitmap formatting.  It uses the
field width for the number of bits instead of precision.  The format used
is '%*pb[l]', with the optional trailing 'l' specifying list format
instead of hex masks.  For more details, please see 0002.



This patch (of 31):

Currently, the formatting and parsing functions in cpumask.h use
nr_cpumask_bits like other cpumask functions; however, nr_cpumask_bits
is either NR_CPUS or nr_cpu_ids depending on CONFIG_CPUMASK_OFFSTACK.
This leads to inconsistent behaviors.

With CONFIG_NR_CPUS=512 and !CONFIG_CPUMASK_OFFSTACK

  # cat /sys/devices/virtual/net/lo/queues/rx-0/rps_cpus
  00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000
  # cat /proc/self/status | grep Cpus_allowed:
  Cpus_allowed:   f

With CONFIG_NR_CPUS=1024 and CONFIG_CPUMASK_OFFSTACK (fedora default)

  # cat /sys/devices/virtual/net/lo/queues/rx-0/rps_cpus
  0
  # cat /proc/self/status | grep Cpus_allowed:
  Cpus_allowed:   f

Note that /proc/self/status is always using nr_cpu_ids regardless of
config.  This is because seq cpumask formattings functions always use
nr_cpu_ids.

Given that the same output fields may switch between the two forms,
converging on nr_cpu_ids always isn't too likely to surprise userland.
This patch updates the formatting and parsing functions in cpumask.h
to always use nr_cpu_ids.  There's no point in dealing with CPUs which
aren't even possible on the machine.

Signed-off-by: Tejun Heo <tj@kernel.org>
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
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/cpumask.h~cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions
+++ a/include/linux/cpumask.h
@@ -550,7 +550,7 @@ static inline void cpumask_copy(struct c
 static inline int cpumask_scnprintf(char *buf, int len,
 				    const struct cpumask *srcp)
 {
-	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpumask_bits);
+	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpu_ids);
 }
 
 /**
@@ -564,7 +564,7 @@ static inline int cpumask_scnprintf(char
 static inline int cpumask_parse_user(const char __user *buf, int len,
 				     struct cpumask *dstp)
 {
-	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
+	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpu_ids);
 }
 
 /**
@@ -579,7 +579,7 @@ static inline int cpumask_parselist_user
 				     struct cpumask *dstp)
 {
 	return bitmap_parselist_user(buf, len, cpumask_bits(dstp),
-							nr_cpumask_bits);
+				     nr_cpu_ids);
 }
 
 /**
@@ -595,7 +595,7 @@ static inline int cpulist_scnprintf(char
 				    const struct cpumask *srcp)
 {
 	return bitmap_scnlistprintf(buf, len, cpumask_bits(srcp),
-				    nr_cpumask_bits);
+				    nr_cpu_ids);
 }
 
 /**
@@ -610,7 +610,7 @@ static inline int cpumask_parse(const ch
 	char *nl = strchr(buf, '\n');
 	unsigned int len = nl ? (unsigned int)(nl - buf) : strlen(buf);
 
-	return bitmap_parse(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
+	return bitmap_parse(buf, len, cpumask_bits(dstp), nr_cpu_ids);
 }
 
 /**
@@ -622,7 +622,7 @@ static inline int cpumask_parse(const ch
  */
 static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
 {
-	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
+	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpu_ids);
 }
 
 /**
@@ -817,7 +817,7 @@ static inline ssize_t
 cpumap_print_to_pagebuf(bool list, char *buf, const struct cpumask *mask)
 {
 	return bitmap_print_to_pagebuf(list, buf, cpumask_bits(mask),
-				      nr_cpumask_bits);
+				      nr_cpu_ids);
 }
 
 /*
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

