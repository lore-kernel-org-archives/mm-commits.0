Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794548093;
	b=bVn73+b8WCtGA4WlN1SHo+czGLrhafOkITSR4gxwEiwyVZWBOHPfX5qW5YC54uY3jJVn
	 /JykGLhnREAlx1LyjMQI//M2DjuD7A8rh2DLyNUYhrn8zEU8oBUOoKwdHcOSf7WkHfC3U
	 87CYdYnm3+hu5dt7Qjt8qaib+69wQUngzL23bZSrRjCm8uhkpUH6B56xPIWqIRAEFGQNo
	 Buxmu76qWDY3V56Xdwsj8Wp8xgbAaX2LMUz8IWfqyzPgzyvNFw4Od1MLbiNFMamHt+YJO
	 x0NuNuupLtk8butAYcXF68iiszbkZUugOhf2xOY75Jmm0vTqtbv6YahZIP8yU8bruOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794548093;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=q5eNS8d42Hh/+55yAfICgQ4kX/msclKzcV5UwEFKHkA=;
	b=1oRZKIEit2hw8r0lNoD6c4A5h3Gea9gDPIxHt9MN1LcyZxPxJpG+Z/bdZ4iaCFPHYiE9
	 ZzsRRabooI4cqjnp5ZzLV3m7M55uroftkc7UKcwEEwmDMjUk6UW3rtSPlnKSEOq8oHEef
	 OU1goiRtM1gD9Lggh4L4/VF7YaMGSe97GSTKZGJc/3WYlfxseiJFrngZR71sNeGYrwZYV
	 z+olhbs3g7Rmj6nHyWUBkArTsmon86vtjffT+bUz55vjl6ukL9esp0xZv4iCBMkL2lAwc
	 pUOpnuvMza6TesGKU5L8yS3fsejurxy6wSC26r5bHf+VEcAIfW86Ri8L1sU0BvW3WUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y6aQrq7r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B7B606A32E;
	Fri, 13 Nov 2026 05:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y6aQrq7r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9860E1F000C4;
	Fri, 13 Nov 2026 05:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794548092;
	bh=q5eNS8d42Hh/+55yAfICgQ4kX/msclKzcV5UwEFKHkA=;
	h=Date:To:From:Subject;
	b=y6aQrq7rfn/csG121AymOBxPkajaAbVudifKGctkXPgTxu0FI9DEw2YwpmwTKSfjQ
	 pWMTGfop+f1fLqTHWTHQ0a138jRgjRYUMNUJgoSLOS01DYrKM8K+l8b92pj2A+YLaU
	 Yp6C9k8aXaD9tLNZi5iU385Y+FO4LWQ0n7M9+Sig=
Date: Thu, 12 Nov 2026 21:34:52 -0800
To: mm-commits@vger.kernel.org,
	syzbot+8fdf0d8e10bdde1c2e88@syzkaller.appspotmail.com,stable@vger.kernel.org,
	peterz@infradead.org,oleg@redhat.com,npiggin@gmail.com,
	matthias.bgg@gmail.com,ebiederm@xmission.com,bradley.morgan@linux.dev,
	angelogioacchino.delregno@collabora.com,leitao@debian.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-halt-when-power-off-fails.patch added to mm-nonmm-unstable branch
Message-Id: <20261113053452.9860E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: reboot: halt when power off fails
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-halt-when-power-off-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-halt-when-power-off-fails.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: reboot: halt when power off fails
Date: Tue, 10 Nov 2026 07:24:34 -0800

The reboot syscall calls do_exit(0) when kernel_power_off() returns.  That
happens when no power off handler takes the machine down, since
machine_power_off() returns to its caller on x86, arm, arm64 and sh.

For example, an x86 kernel built with CONFIG_ACPI_REDUCED_HARDWARE_ONLY
cannot power off QEMU's pc and q35 machines.  Their FADT is not
hardware-reduced, so acpi_power_off() is still registered.  But the legacy
sleep code is compiled out and the FADT has no sleep control register, so
acpi_enter_sleep_state() returns AE_NOT_EXIST.

On x86, arm and arm64, interrupts are disabled by then, and do_exit()
warns. syzbot hit this on a GCE VM:

  ACPI: PM: Preparing to enter system sleep state S5
  kvm: exiting hardware virtualization
  reboot: Power down
  ------------[ cut here ]------------
  irqs_disabled()
  WARNING: kernel/exit.c:930 at do_exit+0x1cf7/0x2ae0 kernel/exit.c:930, CPU#0: init/6193
  CPU: 0 UID: 0 PID: 6193 Comm: init Tainted: G             L      syzkaller #0 PREEMPT(full)
  Call Trace:
   <TASK>
   __do_sys_reboot+0x36e/0x400 kernel/reboot.c:784
   do_syscall_64+0x115/0x840 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

If the caller is init, do_exit() then panics. Exiting does not help
the other callers either: the devices are already shut down, and the
task still holds system_transition_mutex.

Halt instead, as the syscall already does when no power off handler is
registered, and as most other architectures do in machine_power_off().

Use machine_halt() rather than kernel_halt(). kernel_power_off() has
already run the shutdown sequence, and kernel_halt() would call the
reboot notifiers again with interrupts disabled.

Keep the fallback in the syscall.  hw_failure_emergency_action_func()
relies on kernel_power_off() returning, so that it can try an emergency
restart.

Link: https://lore.kernel.org/20261110-reboot-make-task-dead-v1-1-af88a3f37bf7@debian.org
Link: https://lore.kernel.org/all/20260713062332.21131-1-include@grrlz.net/
Fixes: 001c28e57187 ("exit: Detect and fix irq disabled state in oops")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+8fdf0d8e10bdde1c2e88@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=8fdf0d8e10bdde1c2e88
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/all/20250404152006.GF3720@redhat.com/
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Konrad Dybcio <angelogioacchino.delregno@collabora.com>
Cc: <stable@vger.kernel.org>
---

 kernel/reboot.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/reboot.c~reboot-halt-when-power-off-fails
+++ a/kernel/reboot.c
@@ -791,6 +791,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 
 	case LINUX_REBOOT_CMD_POWER_OFF:
 		kernel_power_off();
+		pr_emerg("Power off failed: System halted instead\n");
+		/* kernel_power_off() already ran the shutdown, only halt. */
+		machine_halt();
 		do_exit(0);
 		break;
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed.patch
tools-mm-add-hwpoison-panic-tool.patch
mm-split-out-memory-failure-declarations-from-internalh.patch
mm-kmemleak-drop-kmemleak_lock-in-scan_block-when-it-is-contended.patch
ratelimit-fix-data-race-on-burst-in-___ratelimit.patch
stackdepot-dont-warn-when-the-depot-runs-out-of-pools.patch
reboot-halt-when-power-off-fails.patch

