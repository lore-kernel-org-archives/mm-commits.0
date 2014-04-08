From: akpm@linux-foundation.org
Subject: [merged]
 net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 14:47:13 -0700
Message-ID: <53446e61.JKgb0lZ1hESuc9Nr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbaDHVrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mingo@kernel.org, edumazet@google.com, davem@davemloft.net, cl@linux.com

Subject: [merged] net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch removed from -mm tree
To: cl@linux.com,davem@davemloft.net,edumazet@google.com,mingo@kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:47:13 -0700


The patch titled
     Subject: net: replace __this_cpu_inc in route.c with raw_cpu_inc
has been removed from the -mm tree.  Its filename was
     net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -188,7 +188,7 @@ const __u8 ip_tos2prio[16] = {
 EXPORT_SYMBOL(ip_tos2prio);
 
 static DEFINE_PER_CPU(struct rt_cache_stat, rt_cache_stat);
-#define RT_CACHE_STAT_INC(field) __this_cpu_inc(rt_cache_stat.field)
+#define RT_CACHE_STAT_INC(field) raw_cpu_inc(rt_cache_stat.field)
 
 #ifdef CONFIG_PROC_FS
 static void *rt_cache_seq_start(struct seq_file *seq, loff_t *pos)
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch

