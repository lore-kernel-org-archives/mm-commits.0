From: akpm@linux-foundation.org
Subject: + proc-fix-inconsistent-lock-state.patch added to -mm tree
Date: Wed, 19 Dec 2012 14:22:47 -0800
Message-ID: <20121219222248.215D082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:55413 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2LSWWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 17:22:49 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so293163ggm.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 14:22:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xtfeng@gmail.com, dannyfeng@tencent.com, ebiederm@xmission.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: fix inconsistent lock state
has been added to the -mm tree.  Its filename is
     proc-fix-inconsistent-lock-state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaotian Feng <xtfeng@gmail.com>
Subject: proc: fix inconsistent lock state

Lockdep found an inconsistent lock state when rcu is processing delayed
work in softirq.  Currently, kernel is using spin_lock/spin_unlock to
protect proc_inum_ida, but proc_free_inum is called by rcu in softirq
context.

Use spin_lock_bh/spin_unlock_bh fix following lockdep warning.

[   49.709127] =================================
[   49.709360] [ INFO: inconsistent lock state ]
[   49.709593] 3.7.0 #36 Not tainted
[   49.709846] ---------------------------------
[   49.710080] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[   49.710377] swapper/1/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
[   49.710640]  (proc_inum_lock){+.?...}, at: [<ffffffff8124280c>]
proc_free_inum+0x1c/0x50
[   49.711287] {SOFTIRQ-ON-W} state was registered at:
[   49.711540]   [<ffffffff8110dc4e>] __lock_acquire+0x8ae/0xca0
[   49.711896]   [<ffffffff8110e1d9>] lock_acquire+0x199/0x200
[   49.712242]   [<ffffffff81b295e1>] _raw_spin_lock+0x41/0x50
[   49.712590]   [<ffffffff81242efc>] proc_alloc_inum+0x4c/0xd0
[   49.712941]   [<ffffffff811f1799>] alloc_mnt_ns+0x49/0xc0
[   49.713282]   [<ffffffff811f3365>] create_mnt_ns+0x25/0x70
[   49.713625]   [<ffffffff82115443>] mnt_init+0x161/0x1c7
[   49.713962]   [<ffffffff82114f51>] vfs_caches_init+0x107/0x11a
[   49.714392]   [<ffffffff820f3c67>] start_kernel+0x348/0x38c
[   49.714815]   [<ffffffff820f3335>] x86_64_start_reservations+0x131/0x136
[   49.715279]   [<ffffffff820f343d>] x86_64_start_kernel+0x103/0x112
[   49.715728] irq event stamp: 2993422
[   49.716006] hardirqs last  enabled at (2993422):
[<ffffffff81b29f75>] _raw_spin_unlock_irqrestore+0x55/0x80
[   49.716661] hardirqs last disabled at (2993421):
[<ffffffff81b296f9>] _raw_spin_lock_irqsave+0x29/0x70
[   49.717300] softirqs last  enabled at (2993394):
[<ffffffff810ab0b3>] _local_bh_enable+0x13/0x20
[   49.717920] softirqs last disabled at (2993395):
[<ffffffff81b2c33c>] call_softirq+0x1c/0x30
[   49.718528]
[   49.718528] other info that might help us debug this:
[   49.718992]  Possible unsafe locking scenario:
[   49.718992]
[   49.719433]        CPU0
[   49.719669]        ----
[   49.719902]   lock(proc_inum_lock);
[   49.720308]   <Interrupt>
[   49.720548]     lock(proc_inum_lock);
[   49.720961]
[   49.720961]  *** DEADLOCK ***
[   49.720961]
[   49.721477] no locks held by swapper/1/0.
[   49.721769]
[   49.721769] stack backtrace:
[   49.722150] Pid: 0, comm: swapper/1 Not tainted 3.7.0 #36
[   49.722555] Call Trace:
[   49.722787]  <IRQ>  [<ffffffff810a40f1>] ? vprintk_emit+0x471/0x510
[   49.723307]  [<ffffffff81109ce5>] print_usage_bug+0x2a5/0x2c0
[   49.723671]  [<ffffffff8110a03b>] mark_lock+0x33b/0x5e0
[   49.724014]  [<ffffffff8110dbb3>] __lock_acquire+0x813/0xca0
[   49.724374]  [<ffffffff8110a8ad>] ? trace_hardirqs_on+0xd/0x10
[   49.724741]  [<ffffffff8110e1d9>] lock_acquire+0x199/0x200
[   49.725095]  [<ffffffff8124280c>] ? proc_free_inum+0x1c/0x50
[   49.725455]  [<ffffffff81b295e1>] _raw_spin_lock+0x41/0x50
[   49.725806]  [<ffffffff8124280c>] ? proc_free_inum+0x1c/0x50
[   49.726165]  [<ffffffff8124280c>] proc_free_inum+0x1c/0x50
[   49.726519]  [<ffffffff810c76a2>] ? put_pid+0x42/0x60
[   49.726857]  [<ffffffff81128cac>] free_pid_ns+0x1c/0x50
[   49.727201]  [<ffffffff81128d0e>] put_pid_ns+0x2e/0x50
[   49.727540]  [<ffffffff810c76aa>] put_pid+0x4a/0x60
[   49.727868]  [<ffffffff810c76d2>] delayed_put_pid+0x12/0x20
[   49.728225]  [<ffffffff81132ed2>] rcu_process_callbacks+0x462/0x790
[   49.728606]  [<ffffffff810ab4e4>] __do_softirq+0x1b4/0x3b0
[   49.728959]  [<ffffffff81104132>] ? clockevents_program_event+0xc2/0xf0
[   49.729354]  [<ffffffff81b2c33c>] call_softirq+0x1c/0x30
[   49.729702]  [<ffffffff81057bf9>] do_softirq+0x59/0xd0
[   49.730039]  [<ffffffff810ab024>] irq_exit+0x54/0xd0
[   49.730370]  [<ffffffff81b2ca05>] smp_apic_timer_interrupt+0x95/0xa3
[   49.730755]  [<ffffffff81b2bbf2>] apic_timer_interrupt+0x72/0x80
[   49.731124]  <EOI>  [<ffffffff81b2a473>] ? retint_restore_args+0x13/0x13
[   49.731658]  [<ffffffff8199d125>] ? cpuidle_wrap_enter+0x55/0xa0
[   49.732029]  [<ffffffff8199d121>] ? cpuidle_wrap_enter+0x51/0xa0
[   49.732399]  [<ffffffff8199d180>] cpuidle_enter_tk+0x10/0x20
[   49.732759]  [<ffffffff8199cb57>] cpuidle_enter_state+0x17/0x50
[   49.733128]  [<ffffffff8199d507>] cpuidle_idle_call+0x287/0x520
[   49.733496]  [<ffffffff8105feca>] cpu_idle+0xba/0x130
[   49.733830]  [<ffffffff81b2059f>] start_secondary+0x2b3/0x2bc

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/proc/generic.c~proc-fix-inconsistent-lock-state fs/proc/generic.c
--- a/fs/proc/generic.c~proc-fix-inconsistent-lock-state
+++ a/fs/proc/generic.c
@@ -359,18 +359,18 @@ retry:
 	if (!ida_pre_get(&proc_inum_ida, GFP_KERNEL))
 		return -ENOMEM;
 
-	spin_lock(&proc_inum_lock);
+	spin_lock_bh(&proc_inum_lock);
 	error = ida_get_new(&proc_inum_ida, &i);
-	spin_unlock(&proc_inum_lock);
+	spin_unlock_bh(&proc_inum_lock);
 	if (error == -EAGAIN)
 		goto retry;
 	else if (error)
 		return error;
 
 	if (i > UINT_MAX - PROC_DYNAMIC_FIRST) {
-		spin_lock(&proc_inum_lock);
+		spin_lock_bh(&proc_inum_lock);
 		ida_remove(&proc_inum_ida, i);
-		spin_unlock(&proc_inum_lock);
+		spin_unlock_bh(&proc_inum_lock);
 		return -ENOSPC;
 	}
 	*inum = PROC_DYNAMIC_FIRST + i;
@@ -379,9 +379,9 @@ retry:
 
 void proc_free_inum(unsigned int inum)
 {
-	spin_lock(&proc_inum_lock);
+	spin_lock_bh(&proc_inum_lock);
 	ida_remove(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
-	spin_unlock(&proc_inum_lock);
+	spin_unlock_bh(&proc_inum_lock);
 }
 
 static void *proc_follow_link(struct dentry *dentry, struct nameidata *nd)
_

Patches currently in -mm which might be from xtfeng@gmail.com are

origin.patch
proc-fix-inconsistent-lock-state.patch

