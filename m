Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828031;
	b=ToJe8xpCbMu7M5nWry8hZ2MDbLe3nJKW2U7Xi9V+Zp0dqWOuU9ZgcijZyqu2+ojtUjfE
	 SOdt60rwT+R9YFGPoJelUjCxyrLDXt0Alis+T3trqu4/BcXrIk/48hVzDuSQOSXWve5tf
	 lACaJrERiAAbMSBTCeBKvWgB+N+Dl4rgfTRcqicQQhdsimcOPyYMH+8E+Vzx6d6Mdqkrk
	 Pj31SlIVj5k2qw4A1e1cpMm1sjHnJ1bhbKwvycHyhR/BV2/7lFqvPFI7V6jVTW5ExZWyT
	 V7eL6LmYxrH5E0pYryMDX10IEXpN7O+S28taNi3GBENXYwjXzBrn50clTw+wyHQhCXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828031;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YT+9CIc5XmEzt2UcFzVq0qnvpdZSTmtQqwD19QZ4ts4=;
	b=vL5YHaafndcQUIXSPupj8Mhi++/99fSqV4C02ni7hyLbp8VaXGXE05ZSJOqfZJWGnO0P
	 XFtzsu7sJI+GT7MJN1AXY8KnXErZrmNSq3JLO9yY7lJr4EIpCH0pYsg8bi62WcITiGZvk
	 7ru/PL/D8vC68E/8W6KC7sTljSGWSV0Cds7dPeR+IWBj4OdhjFLyZ5d/noK4SFmFIqU1p
	 /AWWoAF/cZo1/LolyrVWG8kN4uJB6HpemoBF+tPtslxIa3UccvSGJKXySTi9hqwviiCv7
	 gIC3g34Bva2qD7Km3A6/59yhb3aM9O8g8d7MIH6qxLZ6EyHspavNyf1cMS1SeP9+ldQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=g3dl4Kgn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B1D606A31E
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 07:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=g3dl4Kgn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485821F01828;
	Sat, 24 Oct 2026 07:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828030;
	bh=YT+9CIc5XmEzt2UcFzVq0qnvpdZSTmtQqwD19QZ4ts4=;
	h=Date:To:From:Subject;
	b=g3dl4KgnEI0fQqD3Jsv6nX1Hggo2Vq0ZyI3ehBx11DEtZaJc4EOpHSNAEKYS0jY48
	 Dbe0cf0Ai1nJvxL19/k4v+hbQox1IVRVc8foB28U9QucOKzaT1wJ/d0UmCK5sallX8
	 ENg58zD09u1w3cMSatS3uuXcGJdz41+0HfAKakWQ=
Date: Sat, 24 Oct 2026 00:47:09 -0700
To: mm-commits@vger.kernel.org,syzbot+1f0fbc2561b3e5d51b91@syzkaller.appspotmail.com,rafael@kernel.org,kernelfans@gmail.com,brads@mainlining.org,eadavis@sina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-reboot-avoid-potential-deadlocks-during-suspension.patch removed from -mm tree
Message-Id: <20261024074710.485821F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: kernel/reboot: avoid potential deadlocks during suspension
has been removed from the -mm tree.  Its filename was
     kernel-reboot-avoid-potential-deadlocks-during-suspension.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Adam Davis <eadavis@sina.com>
Subject: kernel/reboot: avoid potential deadlocks during suspension
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


