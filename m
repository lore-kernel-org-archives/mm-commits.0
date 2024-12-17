Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0511FA157;
	Tue, 17 Dec 2024 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458122; cv=none; b=t+hsuslq/z6zUj4oqXyRjmiNCKDlvwLyqUJPCoI3EPqnAioxk6L6k6o9/hVkoJYI49np3bzg1BriV5hcpKsTASzrw6NXse++LIKOp/NjX5708S949OpqqWOq0h8dT4kRkKu6i2ZGB+KKgaUJcPXTATlt4uqJLheZL7Ty7qFVb5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458122; c=relaxed/simple;
	bh=XS5IvDfgvR8yVowHUW14u4vct0tHwPPXXoqopb1SBT8=;
	h=Date:To:From:Subject:Message-Id; b=NffPlTxIZOEiV5AgXXCM3kT3jPWqpVDaD44KeSmkzWFruF5zrbsx3ShJ/U81E6B4sJfq6C+fKFjRVnE0JfYXCACUOtMmUex+QJtIOGnpzWZITDPrzA9SRQa9ONh9VeTOu61OHMjgjnEVMEKmNGxQyuoFH08Czudjg32k71d0ARU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qWg6JEWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qWg6JEWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0120C4CED3;
	Tue, 17 Dec 2024 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734458121;
	bh=XS5IvDfgvR8yVowHUW14u4vct0tHwPPXXoqopb1SBT8=;
	h=Date:To:From:Subject:From;
	b=qWg6JEWB3rP4bP+JcXGewLopnOXJeAHsOlVYueTEO5LHDp8tVv87bBdWJLwSKpgNq
	 Ca4m9tDiBllabyXv6QilbkPHV4gSXQMGPv2NWRisedqBLyHB2gxA7w3MimBsh3ZcGT
	 +ogU1I/YDO+e36K83bTIfMAskwqCTPGaLnTBFgWs=
Date: Tue, 17 Dec 2024 09:55:21 -0800
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,stable@vger.kernel.org,rostedt@goodmis.org,juri.lelli@redhat.com,gpaoloni@redhat.com,echanude@redhat.com,clement.leger@bootlin.com,catalin.marinas@arm.com,bigeasy@linutronix.de,acarmina@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-fix-sleeping-function-called-from-invalid-context-at-print-message.patch added to mm-hotfixes-unstable branch
Message-Id: <20241217175521.B0120C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: fix sleeping function called from invalid context at print message
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmemleak-fix-sleeping-function-called-from-invalid-context-at-print-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-fix-sleeping-function-called-from-invalid-context-at-print-message.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alessandro Carminati <acarmina@redhat.com>
Subject: mm/kmemleak: fix sleeping function called from invalid context at print message
Date: Tue, 17 Dec 2024 14:20:33 +0000

Address a bug in the kernel that triggers a "sleeping function called from
invalid context" warning when /sys/kernel/debug/kmemleak is printed under
specific conditions:
- CONFIG_PREEMPT_RT=y
- Set SELinux as the LSM for the system
- Set kptr_restrict to 1
- kmemleak buffer contains at least one item

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 136, name: cat
preempt_count: 1, expected: 0
RCU nest depth: 2, expected: 2
6 locks held by cat/136:
 #0: ffff32e64bcbf950 (&p->lock){+.+.}-{3:3}, at: seq_read_iter+0xb8/0xe30
 #1: ffffafe6aaa9dea0 (scan_mutex){+.+.}-{3:3}, at: kmemleak_seq_start+0x34/0x128
 #3: ffff32e6546b1cd0 (&object->lock){....}-{2:2}, at: kmemleak_seq_show+0x3c/0x1e0
 #4: ffffafe6aa8d8560 (rcu_read_lock){....}-{1:2}, at: has_ns_capability_noaudit+0x8/0x1b0
 #5: ffffafe6aabbc0f8 (notif_lock){+.+.}-{2:2}, at: avc_compute_av+0xc4/0x3d0
irq event stamp: 136660
hardirqs last  enabled at (136659): [<ffffafe6a80fd7a0>] _raw_spin_unlock_irqrestore+0xa8/0xd8
hardirqs last disabled at (136660): [<ffffafe6a80fd85c>] _raw_spin_lock_irqsave+0x8c/0xb0
softirqs last  enabled at (0): [<ffffafe6a5d50b28>] copy_process+0x11d8/0x3df8
softirqs last disabled at (0): [<0000000000000000>] 0x0
Preemption disabled at:
[<ffffafe6a6598a4c>] kmemleak_seq_show+0x3c/0x1e0
CPU: 1 UID: 0 PID: 136 Comm: cat Tainted: G            E      6.11.0-rt7+ #34
Tainted: [E]=UNSIGNED_MODULE
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace+0xa0/0x128
 show_stack+0x1c/0x30
 dump_stack_lvl+0xe8/0x198
 dump_stack+0x18/0x20
 rt_spin_lock+0x8c/0x1a8
 avc_perm_nonode+0xa0/0x150
 cred_has_capability.isra.0+0x118/0x218
 selinux_capable+0x50/0x80
 security_capable+0x7c/0xd0
 has_ns_capability_noaudit+0x94/0x1b0
 has_capability_noaudit+0x20/0x30
 restricted_pointer+0x21c/0x4b0
 pointer+0x298/0x760
 vsnprintf+0x330/0xf70
 seq_printf+0x178/0x218
 print_unreferenced+0x1a4/0x2d0
 kmemleak_seq_show+0xd0/0x1e0
 seq_read_iter+0x354/0xe30
 seq_read+0x250/0x378
 full_proxy_read+0xd8/0x148
 vfs_read+0x190/0x918
 ksys_read+0xf0/0x1e0
 __arm64_sys_read+0x70/0xa8
 invoke_syscall.constprop.0+0xd4/0x1d8
 el0_svc+0x50/0x158
 el0t_64_sync+0x17c/0x180

%pS and %pK, in the same back trace line, are redundant, and %pS can void
%pK service in certain contexts.

%pS alone already provides the necessary information, and if it cannot
resolve the symbol, it falls back to printing the raw address voiding
the original intent behind the %pK.

Additionally, %pK requires a privilege check CAP_SYSLOG enforced through
the LSM, which can trigger a "sleeping function called from invalid
context" warning under RT_PREEMPT kernels when the check occurs in an
atomic context. This issue may also affect other LSMs.

This change avoids the unnecessary privilege check and resolves the
sleeping function warning without any loss of information.

Link: https://lkml.kernel.org/r/20241217142032.55793-1-acarmina@redhat.com
Fixes: 3a6f33d86baa ("mm/kmemleak: use %pK to display kernel pointers in backtrace")
Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
Cc: Clément Léger <clement.leger@bootlin.com>
Cc: Alessandro Carminati <acarmina@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Eric Chanudet <echanude@redhat.com>
Cc: Gabriele Paoloni <gpaoloni@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-sleeping-function-called-from-invalid-context-at-print-message
+++ a/mm/kmemleak.c
@@ -373,7 +373,7 @@ static void print_unreferenced(struct se
 
 	for (i = 0; i < nr_entries; i++) {
 		void *ptr = (void *)entries[i];
-		warn_or_seq_printf(seq, "    [<%pK>] %pS\n", ptr, ptr);
+		warn_or_seq_printf(seq, "    %pS\n", ptr);
 	}
 }
 
_

Patches currently in -mm which might be from acarmina@redhat.com are

mm-kmemleak-fix-sleeping-function-called-from-invalid-context-at-print-message.patch

