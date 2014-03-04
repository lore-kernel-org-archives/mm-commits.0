From: akpm@linux-foundation.org
Subject: +
 modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
 added to -mm tree
Date: Tue, 04 Mar 2014 14:27:06 -0800
Message-ID: <5316533a.wA5LSQ5HnjjpY0nb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbaCDW1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rusty@rustcorp.com.au, mingo@kernel.org, cl@linux.com

Subject: + modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch added to -mm tree
To: cl@linux.com,mingo@kernel.org,rusty@rustcorp.com.au,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:06 -0800


The patch titled
     Subject: modules: use raw_cpu_write for initialization of per cpu refcount.
has been added to the -mm tree.  Its filename is
     modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch

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
Subject: modules: use raw_cpu_write for initialization of per cpu refcount.

The initialization of a structure is not subject to synchronization.  The
use of __this_cpu would trigger a false positive with the additional
preemption checks for __this_cpu ops.

So simply disable the check through the use of raw_cpu ops.

Trace:

[    0.668066] __this_cpu_write operation in preemptible [00000000] code: modprobe/286
[    0.668108] caller is __this_cpu_preempt_check+0x38/0x60
[    0.668111] CPU: 3 PID: 286 Comm: modprobe Tainted: GF            3.12.0-rc4+ #187
[    0.668112] Hardware name: FUJITSU CELSIUS W530 Power/D3227-A1, BIOS V4.6.5.4 R1.10.0 for D3227-A1x 09/16/2013
[    0.668113]  0000000000000003 ffff8807edda1d18 ffffffff816d5a57 ffff8807edda1fd8
[    0.668117]  ffff8807edda1d48 ffffffff8137359c ffff8807edda1ef8 ffffffffa0002178
[    0.668121]  ffffc90000067730 ffff8807edda1e48 ffff8807edda1d88 ffffffff813735f8
[    0.668124] Call Trace:
[    0.668129]  [<ffffffff816d5a57>] dump_stack+0x4e/0x82
[    0.668132]  [<ffffffff8137359c>] check_preemption_disabled+0xec/0x110
[    0.668135]  [<ffffffff813735f8>] __this_cpu_preempt_check+0x38/0x60
[    0.668139]  [<ffffffff810c24fd>] load_module+0xcfd/0x2650
[    0.668143]  [<ffffffff816dd922>] ? page_fault+0x22/0x30
[    0.668146]  [<ffffffff810c3ef6>] SyS_init_module+0xa6/0xd0
[    0.668150]  [<ffffffff816e4fd3>] tracesys+0xe1/0xe6

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/module.c~modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount kernel/module.c
--- a/kernel/module.c~modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount
+++ a/kernel/module.c
@@ -640,7 +640,7 @@ static int module_unload_init(struct mod
 	INIT_LIST_HEAD(&mod->target_list);
 
 	/* Hold reference count during initialization. */
-	__this_cpu_write(mod->refptr->incs, 1);
+	raw_cpu_write(mod->refptr->incs, 1);
 
 	return 0;
 }
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

