Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C8D44606A;
	Wed, 14 Oct 2026 21:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792014825; cv=none; b=MrpBtStFY4zVKIf+MINUHl4S9475KpYLDqLCTOiVoLHoRNYjV8/jBKmluUin14BxPgjQu3TKEqgoktYsvqvslqUb78VCh/olh+p0X3UcgYroMLKyz7YB4F3WCKjwjM7B8fWjVQ5Lv/kvTTMkYxPkz8Zm2ChW9X4Q6LDERwXmJjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792014825; c=relaxed/simple;
	bh=BoKSXVAp0+ntxt7DyCcP41ZB+JowPpFzj30iD4UYmC4=;
	h=Date:To:From:Subject:Message-Id; b=o19SMUSyGBqG17tG3TCcg28NBv0bUV/oSbRQJSD8sgeEkut+FYWQU+6u1QKJiuZfEqMmqAdCqZFYAaz/kmD2unK3lOLAw6zBbm0KRqPhbf9MzBgTE3qRoghxKAKvjsFryPciXSVCwbPOEjvuYMq2fPBvwjEFXaFeutHiZm2e+MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ShMjSHpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ShMjSHpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7995B1F000C4;
	Wed, 14 Oct 2026 21:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792014823;
	bh=+DhrZbziWQXtPzIGpL227cF8P5MzJg7wVNaikj73cfU=;
	h=Date:To:From:Subject;
	b=ShMjSHpM0tO2N00jzx+PgnoXXEQNuwI8JBKk9BQf/kzwQ9kZ35q139VR8EF13g+lJ
	 7VykOUfD/M0b8EtKj9HCwItanAHKqCQQSLk+T/RF1Czp0Mha2ScVeT3DrrQxM2EMLk
	 s3M5ZGK2qWHEJDrNY4yOSQ4uSd7M9ahMynFgZVS8=
Date: Wed, 14 Oct 2026 14:53:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,jack@suse.cz,heming.zhao@suse.com,chao@kernel.org,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cancel-quota-sync-work-before-freeing-quota-info.patch added to mm-nonmm-unstable branch
Message-Id: <20261014215343.7995B1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: cancel quota sync work before freeing quota info
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-cancel-quota-sync-work-before-freeing-quota-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cancel-quota-sync-work-before-freeing-quota-info.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: cancel quota sync work before freeing quota info
Date: Wed, 14 Oct 2026 11:43:40 +0800

OCFS2 quota info owns dqi_sync_work and must outlive both its timer and
qsync_work_fn().  ocfs2_local_free_info() frees that owner without
cancelling the work, relying on the quota suspend/disable wrappers.

Loading quotas on a read-only to read-write remount can successfully queue
the work in ocfs2_global_read_info() and then fail while attaching a dquot
to an existing inode in add_dquot_ref().  The quota core unwinds that
failure directly through dquot_disable(), bypassing the OCFS2 wrapper:

  Remount task (s_umount write)        Timer/workqueue
  ocfs2_global_read_info()
    schedules dqi_sync_work
  add_dquot_ref() returns an error
  dquot_disable()
    ocfs2_local_free_info()
      frees oinfo
                                     delayed-work timer expires
                                     qsync_work_fn() reads oinfo

The timer core can then write to the freed embedded timer, or
qsync_work_fn() can read oinfo->dqi_gqinode before its s_umount trylock.
The outer ocfs2_disable_quotas() cleanup skips the failed type because
dquot_disable() has already cleared its loaded state.

Cancel dqi_sync_work synchronously at the start of
ocfs2_local_free_info(), before dropping the global inode or freeing any
owner state. The work is initialized whenever read_file_info() succeeds.
dquot_disable() holds s_umount for write, so the callback skips its quota
scan via down_read_trylock() and can finish without waiting for teardown.
The synchronous cancel also handles its self-rearm.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in __run_timers+0x9e9/0xa10
    Write of size 8 at addr ffff888111b0aad0 by task swapper/3/0

    Call Trace:
     <IRQ>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? __run_timers+0x9e9/0xa10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? __run_timers+0x9e9/0xa10
     kasan_report+0xe0/0x110
     ? __run_timers+0x9e9/0xa10
     __run_timers+0x9e9/0xa10
     ? __pfx___run_timers+0x10/0x10
     ? __lock_acquire+0x5a3/0x2140
     ? __pfx_do_raw_spin_lock+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     timer_expire_remote+0xfa/0x160
     ? __pfx_timer_expire_remote+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     tmigr_handle_remote_up+0x4ba/0x9d0
     ? __pfx_tmigr_handle_remote_up+0x10/0x10
     ? tmigr_handle_remote+0x21a/0x340
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? __pfx_tmigr_handle_remote_up+0x10/0x10
     __walk_groups_from+0x5a/0x160
     tmigr_handle_remote+0x24f/0x340
     ? __pfx_tmigr_handle_remote+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     run_timer_softirq+0x222/0x270
     ? __pfx_run_timer_softirq+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lockdep_hardirqs_on_prepare+0xb8/0x1a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     handle_softirqs+0x1fa/0x8d0
     ? __pfx_handle_softirqs+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? _raw_spin_unlock+0x23/0x40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __hrtimer_rearm_deferred+0x1fb/0x5d0
     __irq_exit_rcu+0x113/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     </IRQ>
     <TASK>
     asm_sysvec_apic_timer_interrupt+0x1a/0x20
     ? ct_kernel_exit.constprop.0+0xc5/0xf0
     ? do_idle+0x3ae/0x650
     default_idle+0x9/0x10
     default_idle_call+0x6c/0xb0
     do_idle+0x3ae/0x650
     ? cpuhp_online_idle+0x9c/0xb0
     ? __pfx_do_idle+0x10/0x10
     ? __entry_text_end+0x1020f6/0x1020f9
     ? lockdep_hardirqs_on_prepare+0xeb/0x1a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     cpu_startup_entry+0x54/0x60
     start_secondary+0x223/0x2d0
     ? __pfx_start_secondary+0x10/0x10
     common_startup_64+0x13e/0x158
     </TASK>

    Allocated by task 523:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     ocfs2_local_read_info+0x181/0x1580
     dquot_load_quota_sb+0x69e/0x11c0
     dquot_load_quota_inode+0x227/0x3e0
     ocfs2_enable_quotas+0x27c/0x520
     ocfs2_reconfigure+0x964/0xd00
     reconfigure_super+0x3ca/0xa70
     path_mount+0x141e/0x1e80
     __x64_sys_mount+0x24b/0x2d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 523:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     ocfs2_local_free_info+0x47b/0x800
     dquot_disable+0x5d9/0x17a0
     dquot_load_quota_sb+0xd3c/0x11c0
     dquot_load_quota_inode+0x227/0x3e0
     ocfs2_enable_quotas+0x27c/0x520
     ocfs2_reconfigure+0x964/0xd00
     reconfigure_super+0x3ca/0xa70
     path_mount+0x141e/0x1e80
     __x64_sys_mount+0x24b/0x2d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff888111b0a800
     which belongs to the cache kmalloc-1k of size 1024
    The buggy address is located 720 bytes inside of
     freed 1024-byte region [ffff888111b0a800, ffff888111b0ac00)

Host details, register and page dumps omitted.

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0052-v3-b4904bd6c85daf033adf@gmail.com
Fixes: 1a6152d36dee ("quota: propagate error from __dquot_initialize")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/quota_local.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ocfs2/quota_local.c~ocfs2-cancel-quota-sync-work-before-freeing-quota-info
+++ a/fs/ocfs2/quota_local.c
@@ -840,6 +840,9 @@ static int ocfs2_local_free_info(struct
 	int mark_clean = 1, len;
 	int status = 0;
 
+	/* Quota-core error paths can bypass ocfs2_disable_quotas(). */
+	cancel_delayed_work_sync(&oinfo->dqi_sync_work);
+
 	iput(oinfo->dqi_gqinode);
 	ocfs2_simple_drop_lockres(OCFS2_SB(sb), &oinfo->dqi_gqlock);
 	ocfs2_lock_res_free(&oinfo->dqi_gqlock);
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-heartbeat-unlink-live-slots-when-their-node-is-missing.patch
ocfs2-initialize-status-waiters-before-publishing-them.patch
ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes.patch
ocfs2-dlm-hold-a-lock-reference-across-grant-ast-enqueue.patch
ocfs2-cancel-quota-sync-work-before-freeing-quota-info.patch

