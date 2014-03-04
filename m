From: akpm@linux-foundation.org
Subject: + net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
 added to -mm tree
Date: Tue, 04 Mar 2014 14:27:07 -0800
Message-ID: <5316533b.mdiDPiXXL5af7ajD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbaCDW1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mingo@kernel.org, edumazet@google.com, davem@davemloft.net, cl@linux.com

Subject: + net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch added to -mm tree
To: cl@linux.com,davem@davemloft.net,edumazet@google.com,mingo@kernel.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:07 -0800


The patch titled
     Subject: net: replace __this_cpu_inc in route.c with raw_cpu_inc
has been added to the -mm tree.  Its filename is
     net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch

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
Subject: net: replace __this_cpu_inc in route.c with raw_cpu_inc

The RT_CACHE_STAT_INC macro triggers the new preemption checks
for __this_cpu ops.

I do not see any other synchronization that would allow the use
of a __this_cpu operation here however in commit
dbd2915ce87e811165da0717f8e159276ebb803e Andrew justifies
the use of raw_smp_processor_id() here because "we do not care"
about races. In the past we agreed that the price of disabling
interrupts here to get consistent counters would be too high.
These counters may be inaccurate due to race conditions.

The use of __this_cpu op improves the situation already from what commit
dbd2915ce87e811165da0717f8e159276ebb803e did since the single instruction
emitted on x86 does not allow the race to occur anymore. However,
non x86 platforms could still experience a race here.

Trace:

[ 1277.189084] __this_cpu_add operation in preemptible [00000000] code: avahi-daemon/1193
[ 1277.189085] caller is __this_cpu_preempt_check+0x38/0x60
[ 1277.189086] CPU: 1 PID: 1193 Comm: avahi-daemon Tainted: GF            3.12.0-rc4+ #187
[ 1277.189087] Hardware name: FUJITSU CELSIUS W530 Power/D3227-A1, BIOS V4.6.5.4 R1.10.0 for D3227-A1x 09/16/2013
[ 1277.189088]  0000000000000001 ffff8807ef78fa00 ffffffff816d5a57 ffff8807ef78ffd8
[ 1277.189089]  ffff8807ef78fa30 ffffffff8137359c ffff8807ef78fba0 ffff88079f822b40
[ 1277.189091]  0000000020000000 ffff8807ee32c800 ffff8807ef78fa70 ffffffff813735f8
[ 1277.189093] Call Trace:
[ 1277.189094]  [<ffffffff816d5a57>] dump_stack+0x4e/0x82
[ 1277.189096]  [<ffffffff8137359c>] check_preemption_disabled+0xec/0x110
[ 1277.189097]  [<ffffffff813735f8>] __this_cpu_preempt_check+0x38/0x60
[ 1277.189098]  [<ffffffff81610d65>] __ip_route_output_key+0x575/0x8c0
[ 1277.189100]  [<ffffffff816110d7>] ip_route_output_flow+0x27/0x70
[ 1277.189101]  [<ffffffff81616c80>] ? ip_copy_metadata+0x1a0/0x1a0
[ 1277.189102]  [<ffffffff81640b15>] udp_sendmsg+0x825/0xa20
[ 1277.189104]  [<ffffffff811b4aa9>] ? do_sys_poll+0x449/0x5d0
[ 1277.189105]  [<ffffffff8164c695>] inet_sendmsg+0x85/0xc0
[ 1277.189106]  [<ffffffff815c6e3c>] sock_sendmsg+0x9c/0xd0
[ 1277.189108]  [<ffffffff813735f8>] ? __this_cpu_preempt_check+0x38/0x60
[ 1277.189109]  [<ffffffff815c7550>] ? move_addr_to_kernel+0x40/0xa0
[ 1277.189111]  [<ffffffff815c71ec>] ___sys_sendmsg+0x37c/0x390
[ 1277.189112]  [<ffffffff8136613a>] ? string.isra.3+0x3a/0xd0
[ 1277.189113]  [<ffffffff8136613a>] ? string.isra.3+0x3a/0xd0
[ 1277.189115]  [<ffffffff81367b54>] ? vsnprintf+0x364/0x650
[ 1277.189116]  [<ffffffff81367ee9>] ? snprintf+0x39/0x40
[ 1277.189118]  [<ffffffff813735f8>] ? __this_cpu_preempt_check+0x38/0x60
[ 1277.189119]  [<ffffffff815c7ff9>] __sys_sendmsg+0x49/0x90
[ 1277.189121]  [<ffffffff815c8052>] SyS_sendmsg+0x12/0x20
[ 1277.189122]  [<ffffffff816e4fd3>] tracesys+0xe1/0xe6

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/route.c~net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc net/ipv4/route.c
--- a/net/ipv4/route.c~net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc
+++ a/net/ipv4/route.c
@@ -194,7 +194,7 @@ const __u8 ip_tos2prio[16] = {
 EXPORT_SYMBOL(ip_tos2prio);
 
 static DEFINE_PER_CPU(struct rt_cache_stat, rt_cache_stat);
-#define RT_CACHE_STAT_INC(field) __this_cpu_inc(rt_cache_stat.field)
+#define RT_CACHE_STAT_INC(field) raw_cpu_inc(rt_cache_stat.field)
 
 #ifdef CONFIG_PROC_FS
 static void *rt_cache_seq_start(struct seq_file *seq, loff_t *pos)
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

