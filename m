From: akpm@linux-foundation.org
Subject: - x86-fix-lockdep-warning-during-suspend-to-ram.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:38:16 -0700
Message-ID: <200806122038.m5CKcGcQ005522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756915AbYFLUjQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:39:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mingo@elte.hu, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     x86: fix lockdep warning during suspend-to-ram
has been removed from the -mm tree.  Its filename was
     x86-fix-lockdep-warning-during-suspend-to-ram.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix lockdep warning during suspend-to-ram
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Freezing user space processes ... <4>------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2658 check_flags+0x4c/0x127()
Modules linked in: i915 drm ipw2200 sonypi ipv6 autofs4 hidp l2cap bluetooth sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables acpi_cpufreq nvram ohci1394 ieee1394 ehci_hcd uhci_hcd sg joydev snd_hda_intel snd_seq_dummy sr_mod snd_seq_oss cdrom snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ieee80211 pcspkr ieee80211_crypt snd_pcm i2c_i801 snd_timer i2c_core ide_pci_generic piix snd soundcore snd_page_alloc button ext3 jbd ide_disk ide_core [last unloaded: ipw2200]
Pid: 3250, comm: zsh Not tainted 2.6.26-rc5 #1
 [<c011c5f5>] warn_on_slowpath+0x41/0x6d
 [<c01080e6>] ? native_sched_clock+0x82/0x96
 [<c013789c>] ? mark_held_locks+0x41/0x5c
 [<c0315688>] ? _spin_unlock_irqrestore+0x36/0x58
 [<c0137a29>] ? trace_hardirqs_on+0xe6/0x10d
 [<c0138637>] ? __lock_acquire+0xae3/0xb2b
 [<c0313413>] ? schedule+0x39b/0x3b4
 [<c0135596>] check_flags+0x4c/0x127
 [<c01386b9>] lock_acquire+0x3a/0x86
 [<c0315075>] _spin_lock+0x26/0x53
 [<c0140660>] ? refrigerator+0x13/0xc3
 [<c0140660>] refrigerator+0x13/0xc3
 [<c012684a>] get_signal_to_deliver+0x3c/0x31e
 [<c0102fe7>] do_notify_resume+0x91/0x6ee
 [<c01359fd>] ? lock_release_holdtime+0x50/0x56
 [<c0315688>] ? _spin_unlock_irqrestore+0x36/0x58
 [<c0235d24>] ? read_chan+0x0/0x58c
 [<c0137a29>] ? trace_hardirqs_on+0xe6/0x10d
 [<c0315694>] ? _spin_unlock_irqrestore+0x42/0x58
 [<c0230afa>] ? tty_ldisc_deref+0x5c/0x63
 [<c0233104>] ? tty_read+0x66/0x98
 [<c014b3f0>] ? audit_syscall_exit+0x2aa/0x2c5
 [<c0109430>] ? do_syscall_trace+0x6b/0x16f
 [<c0103a9c>] work_notifysig+0x13/0x1b
 =======================
---[ end trace 25b49fe59a25afa5 ]---
possible reason: unannotated irqs-off.
irq event stamp: 58919
hardirqs last  enabled at (58919): [<c0103afd>] syscall_exit_work+0x11/0x26

Joy - I so love entry.S

Best I can make of it:

syscall_exit_work
  resume_userspace
    DISABLE_INTERRUPTS
    (no TRACE_IRQS_OFF)
      work_pending
        work_notifysig
          do_notify_resume()
            do_signal()
              get_signal_to_deliver()
                try_to_freeze()
                  refrigerator()
                    task_lock() -> check_flags() -> BANG

The normal path is:

syscall_exit_work
  resume_userspace
    DISABLE_INTERRUPTS
    restore_all
      TRACE_IRQS_IRET
      iret

No idea why that would not warn..

i386-defconfig + lockdep seems to boot with this patch..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/entry_32.S |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/entry_32.S~x86-fix-lockdep-warning-during-suspend-to-ram arch/x86/kernel/entry_32.S
--- a/arch/x86/kernel/entry_32.S~x86-fix-lockdep-warning-during-suspend-to-ram
+++ a/arch/x86/kernel/entry_32.S
@@ -248,6 +248,7 @@ ENTRY(resume_userspace)
  	DISABLE_INTERRUPTS(CLBR_ANY)	# make sure we don't miss an interrupt
 					# setting need_resched or sigpending
 					# between sampling and the iret
+	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
 	andl $_TIF_WORK_MASK, %ecx	# is there any work to be done on
 					# int/exception return?
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
radix-tree-fix-small-lockless-radix-tree-bug.patch
access_process_vm-device-memory-infrastructure.patch
access_process_vm-device-memory-infrastructure-fix.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch

