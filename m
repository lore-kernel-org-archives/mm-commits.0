Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792532673;
	b=w8r7ccObUHA7+7hzGjHQQaGCabstUW84t40edGqadS76xEbZJzyibfBzfTRN6ZuyCPtP
	 yqoKrgUeS4VZhAqxm+/mm6bGIw06N+mwYrtXKYclv3niebEmovnZsh6DQaZqfsyimXkha
	 vQH5kpMAeiGCMumKQh6dP53DSqvXeH8KbuO2wUDHySZguhGEkczzQax44x8eHfYXJxXkk
	 tmFSXUUfIQi1Dx55JF2DqFbv4G2KWtK2Xj5tu/fwZsdavtQjTbRKLFrxmNZaNwYRFDlN6
	 GQFG6LAi8Q22TRl4+SpzajeryNyeIlQFK4+4b/RNYh8+VAK9MqgY9Q9rXOMK67FNNZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532673;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7NWpBlbylNaxiL2qCPwmvScDgpyVSXhFSmnuZ++Ph10=;
	b=snCtqJZ1XEdEBOTpTqXPb+eHXFZr+Jj2qpkmou9UAbBv2ruQXvA9CN6XaOpRsB6RTafG
	 nfT2M8iHgTuHYcrC5ZUV/G2Qrli+bzPjtfGTwXanfXxW4zk10DAzfjINV6OEIXUZj9tnF
	 AEuqgjUapRL/h06bBUgP711Em8lDCx/HrkQtqCmZrTij6GmoSpUQeCVc205CkYjcXB5RF
	 1RmZWBfyD22VUp7VmbEsIFK9RV5FTq3pvRBGPElc1Tof//ELKK3mj9N9xK3DzbfiyyDqL
	 5SED27luSmOWWt8FCw4NEJTl4/74q54sGvAEz6NAqqUB4eQdLtnM/Y5jWjyFYDpYqNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1PqxCzdi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7478D606A31C
	for <mm-commits@vger.kernel.org>; Tue, 20 Oct 2026 21:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1PqxCzdi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CD81F000C9;
	Tue, 20 Oct 2026 21:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792532673;
	bh=7NWpBlbylNaxiL2qCPwmvScDgpyVSXhFSmnuZ++Ph10=;
	h=Date:To:From:Subject;
	b=1PqxCzdiLDowlBt/b0LIrWAVqnf1plTBIn+qoGogNSo4zDsbuozCrUI4lLMwFKtwi
	 GnUk8GyQpvHgPlzQiAu085ne+kR7yoPlU/C7yGmPdYoP2mMKON/6RbkR/dxfjOFgpq
	 oVmnya4OeNWiMu4pr2IJF2LdeHdP39Cyl4rz8UGc=
Date: Tue, 20 Oct 2026 14:44:32 -0700
To: mm-commits@vger.kernel.org,syzbot+1f0fbc2561b3e5d51b91@syzkaller.appspotmail.com,rafael@kernel.org,kernelfans@gmail.com,brads@mainlining.org,eadavis@sina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-reboot-avoid-potential-deadlocks-during-suspension.patch added to mm-nonmm-unstable branch
Message-Id: <20261020214433.20CD81F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kernel/reboot: Avoid potential deadlocks during suspension
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-reboot-avoid-potential-deadlocks-during-suspension.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-reboot-avoid-potential-deadlocks-during-suspension.patch

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
From: Edward Adam Davis <eadavis@sina.com>
Subject: kernel/reboot: Avoid potential deadlocks during suspension
Date: Tue, 20 Oct 2026 09:05:59 +0800

Invoking reboot with LINUX_REBOOT_CMD_SW_SUSPEND causes kernel/reboot.c
to acquire system_transition_mutex and invoke hibernate(). hibernate()
calls lock_system_sleep(), which sets PF_NOFREEZE on current and attempts
to acquire system_transition_mutex again, potentially hitting:

WARNING: possible recursive locking detected
--------------------------------------------
syz.3.5755/5950 is trying to acquire lock:
ffffffff8fc04760 (system_transition_mutex){+.+.}-{4:4}, at: lock_system_sleep+0x49/0x70 kernel/power/main.c:71

but task is already holding lock:
ffffffff8fc04760 (system_transition_mutex){+.+.}-{4:4}, at: __do_sys_reboot kernel/reboot.c:774 [inline]
ffffffff8fc04760 (system_transition_mutex){+.+.}-{4:4}, at: __se_sys_reboot+0x223/0x460 kernel/reboot.c:738

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(system_transition_mutex);
  lock(system_transition_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

locks held by syz.3.5755/5950: 1, last CPU#0:
 #0: ffffffff8fc04760 (system_transition_mutex){+.+.}-{4:4}, at: __do_sys_reboot kernel/reboot.c:774 [inline]
 #0: ffffffff8fc04760 (system_transition_mutex){+.+.}-{4:4}, at: __se_sys_reboot+0x223/0x460 kernel/reboot.c:738

Call Trace:
 lock_system_sleep+0x49/0x70 kernel/power/main.c:71
 hibernate+0x162/0x680 kernel/power/hibernate.c:784
 __do_sys_reboot kernel/reboot.c:816 [inline]

Move the suspension operation outside the scope protected by lock
system_transition_mutex.

Link: https://lore.kernel.org/20261020010559.23031-1-eadavis@sina.com
Fixes: 55f2503c3b69 ("PM / reboot: Eliminate race between reboot and suspend")
Signed-off-by: Edward Adam Davis <eadavis@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+1f0fbc2561b3e5d51b91@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1f0fbc2561b3e5d51b91
Tested-by: <syzbot+1f0fbc2561b3e5d51b91@syzkaller.appspotmail.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
---

 kernel/reboot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/reboot.c~kernel-reboot-avoid-potential-deadlocks-during-suspension
+++ a/kernel/reboot.c
@@ -804,8 +804,8 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 
 #ifdef CONFIG_HIBERNATION
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
-		ret = hibernate();
-		break;
+		mutex_unlock(&system_transition_mutex);
+		return hibernate();
 #endif
 
 	default:
_

Patches currently in -mm which might be from eadavis@sina.com are

kernel-reboot-avoid-potential-deadlocks-during-suspension.patch

