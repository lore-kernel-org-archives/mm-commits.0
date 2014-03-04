From: akpm@linux-foundation.org
Subject: + mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
 added to -mm tree
Date: Tue, 04 Mar 2014 14:27:04 -0800
Message-ID: <53165338.E5vBdV+apnVLtMhs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaCDW1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mingo@kernel.org, alex.shi@intel.com, cl@linux.com

Subject: + mm-use-raw_cpu-ops-for-determining-current-numa-node.patch added to -mm tree
To: cl@linux.com,alex.shi@intel.com,mingo@kernel.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:04 -0800


The patch titled
     Subject: mm: use raw_cpu ops for determining current NUMA node
has been added to the -mm tree.  Its filename is
     mm-use-raw_cpu-ops-for-determining-current-numa-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-raw_cpu-ops-for-determining-current-numa-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: mm: use raw_cpu ops for determining current NUMA node

With the preempt checking logic for __this_cpu_ops we will get false
positives from locations in the code that use numa_node_id.

Before the  __this_cpu ops where introduced there were
no checks for preemption present either. smp_raw_processor_id()
was used. See http://www.spinics.net/lists/linux-numa/msg00641.html

Therefore we need to use raw_cpu_read here to avoid false postives.

Note that this issue has been discussed in prior years.
If the process changes nodes after retrieving the current numa node then
that is acceptable since most uses of numa_node etc are for optimization
and not for correctness.

There were suggestions to implement a raw_numa_node_id in order to
do preempt checks for numa_node_id as well. But I think we better
defer that to another patch since that would mean investigating
how numa_node_id() is used throughout the kernel which would increase
the scope of this patchset significantly. After all preemption was never
checked before when numa_node_id() was used.

Some sample traces:

__this_cpu_read operation in preemptible [00000000] code: login/1456
caller is __this_cpu_preempt_check+0x2b/0x2d
CPU: 0 PID: 1456 Comm: login Not tainted 3.12.0-rc4-cl-00062-g2fe80d3-dirty #185
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 000000000000013c ffff88001f31ba58 ffffffff8147cf5e ffff88001f31bfd8
 ffff88001f31ba88 ffffffff8127eea9 0000000000000000 ffff88001f3975c0
 00000000f7707000 ffff88001f3975c0 ffff88001f31bac0 ffffffff8127eeef
Call Trace:
 [<ffffffff8147cf5e>] dump_stack+0x4e/0x82
 [<ffffffff8127eea9>] check_preemption_disabled+0xc5/0xe0
 [<ffffffff8127eeef>] __this_cpu_preempt_check+0x2b/0x2d
 [<ffffffff81030ff5>] ? show_stack+0x3b/0x3d
 [<ffffffff810ebee3>] get_task_policy+0x1d/0x49
 [<ffffffff810ed705>] get_vma_policy+0x14/0x76
 [<ffffffff810ed8ff>] alloc_pages_vma+0x35/0xff
 [<ffffffff810dad97>] handle_mm_fault+0x290/0x73b
 [<ffffffff810503da>] __do_page_fault+0x3fe/0x44d
 [<ffffffff8109b360>] ? trace_hardirqs_on_caller+0x142/0x19e
 [<ffffffff8109b3c9>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff81278bed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff810be97f>] ? find_get_pages_contig+0x18e/0x18e
 [<ffffffff810be97f>] ? find_get_pages_contig+0x18e/0x18e
 [<ffffffff81050451>] do_page_fault+0x9/0xc
 [<ffffffff81483602>] page_fault+0x22/0x30
 [<ffffffff810be97f>] ? find_get_pages_contig+0x18e/0x18e
 [<ffffffff810be97f>] ? find_get_pages_contig+0x18e/0x18e
 [<ffffffff810be4c3>] ? file_read_actor+0x3a/0x15a
 [<ffffffff810be97f>] ? find_get_pages_contig+0x18e/0x18e
 [<ffffffff810bffab>] generic_file_aio_read+0x38e/0x624
 [<ffffffff810f6d69>] do_sync_read+0x54/0x73
 [<ffffffff810f7890>] vfs_read+0x9d/0x12a
 [<ffffffff810f7a59>] SyS_read+0x47/0x7e
 [<ffffffff81484f21>] cstar_dispatch+0x7/0x23

caller is __this_cpu_preempt_check+0x2b/0x2d
CPU: 0 PID: 1456 Comm: login Not tainted 3.12.0-rc4-cl-00062-g2fe80d3-dirty #185
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 00000000000000e8 ffff88001f31bbf8 ffffffff8147cf5e ffff88001f31bfd8
 ffff88001f31bc28 ffffffff8127eea9 ffffffff823c5c40 00000000000213da
 0000000000000000 0000000000000000 ffff88001f31bc60 ffffffff8127eeef
Call Trace:
 [<ffffffff8147cf5e>] dump_stack+0x4e/0x82
 [<ffffffff8127eea9>] check_preemption_disabled+0xc5/0xe0
 [<ffffffff8127eeef>] __this_cpu_preempt_check+0x2b/0x2d
 [<ffffffff810e006e>] ? install_special_mapping+0x11/0xe4
 [<ffffffff810ec8a8>] alloc_pages_current+0x8f/0xbc
 [<ffffffff810bec6b>] __page_cache_alloc+0xb/0xd
 [<ffffffff810c7e90>] __do_page_cache_readahead+0xf4/0x219
 [<ffffffff810c7e0e>] ? __do_page_cache_readahead+0x72/0x219
 [<ffffffff810c827c>] ra_submit+0x1c/0x20
 [<ffffffff810c850c>] ondemand_readahead+0x28c/0x2b4
 [<ffffffff810c85e9>] page_cache_sync_readahead+0x38/0x3a
 [<ffffffff810bfe7e>] generic_file_aio_read+0x261/0x624
 [<ffffffff810f6d69>] do_sync_read+0x54/0x73
 [<ffffffff810f7890>] vfs_read+0x9d/0x12a
 [<ffffffff810f7a59>] SyS_read+0x47/0x7e
 [<ffffffff81484f21>] cstar_dispatch+0x7/0x23

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Alex Shi <alex.shi@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/topology.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/topology.h~mm-use-raw_cpu-ops-for-determining-current-numa-node include/linux/topology.h
--- a/include/linux/topology.h~mm-use-raw_cpu-ops-for-determining-current-numa-node
+++ a/include/linux/topology.h
@@ -188,7 +188,7 @@ DECLARE_PER_CPU(int, numa_node);
 /* Returns the number of the current Node. */
 static inline int numa_node_id(void)
 {
-	return __this_cpu_read(numa_node);
+	return raw_cpu_read(numa_node);
 }
 #endif
 
@@ -245,7 +245,7 @@ static inline void set_numa_mem(int node
 /* Returns the number of the nearest Node with memory */
 static inline int numa_mem_id(void)
 {
-	return __this_cpu_read(_numa_mem_);
+	return raw_cpu_read(_numa_mem_);
 }
 #endif
 
_

Patches currently in -mm which might be from cl@linux.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
tracing-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
percpu-replace-__get_cpu_var-with-this_cpu_ptr.patch
kernel-misc-replace-__get_cpu_var-uses.patch
drivers-char-random-replace-__get_cpu_var-uses.patch
drivers-cpuidle-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-oprofile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-leds-replace-__get_cpu_var-use-through-this_cpu_ptr.patch
drivers-clocksource-replace-__get_cpu_var-used-for-address-calculation.patch
parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
metag-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
tilegx-another-case-of-get_cpu_var.patch
time-replace-__get_cpu_var-uses.patch
scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
tick-sched-fix-two-new-uses-of-__get_cpu_ptr.patch
block-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
watchdog-replace-__raw_get_cpu_var-uses.patch
net-replace-get_cpu_var-through-this_cpu_ptr.patch
md-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
irqchips-replace-__this_cpu_ptr-uses.patch
x86-replace-__get_cpu_var-uses.patch
x86-change-__get_cpu_var-calls-introduced-in-314.patch
uv-replace-__get_cpu_var.patch
arm-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
mips-replace-__get_cpu_var-uses.patch
s390-rename-__this_cpu_ptr-to-raw_cpu_ptr.patch
s390-replace-__get_cpu_var-uses.patch
s390-handle-new-__get_cpu_var-calls-added-in-314.patch
ia64-replace-__get_cpu_var-uses.patch
powerpc-replace-__get_cpu_var-uses.patch
powerpc-handle-new-__get_cpu_var-calls-in-314.patch
sparc-replace-__get_cpu_var-uses.patch
tile-replace-__get_cpu_var-uses.patch
blackfin-replace-__get_cpu_var-uses.patch
avr32-replace-__get_cpu_var-with-__this_cpu_write.patch
alpha-replace-__get_cpu_var.patch
sh-replace-__get_cpu_var-uses.patch

