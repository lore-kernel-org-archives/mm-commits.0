Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F6127473
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382130; cv=none; b=vCqyZy9wHYS9TNvQ8XbWgBReTV2GTFs73WXl9+OTXYsOY7yAzdLiPob7ASra65P8NrKBS+0/KN1OhhXqg4giy4WEU3R2O07Pss46+XPeapS9u4G+FGODO+tuYMx0g8a9hjfhMq+b3L/tvRec8m8cpewkmrfbijksTAGToivorS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382130; c=relaxed/simple;
	bh=lNy42HRZ+KRLT2zSdSeA2A3thOFIkdWZHpdzPS21wUk=;
	h=Date:To:From:Subject:Message-Id; b=OsNE7z6HPKyyEEWdt1VVacXWwfye2C4yXRBIi0Q9fwBYkUEnPAxqYVp35U9vQ0jWlU6J22gd4gNliVldQ5Run/Rr2QaZACdSbr62bALzvy920ipAw2DAUC2VRJqVYWJW2/hTULtc/pJ17R74N/sZWwLZm40RA0u5VuLk95TilBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aAJ6XpSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aAJ6XpSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319ECC4CEC5;
	Thu, 26 Sep 2024 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382130;
	bh=lNy42HRZ+KRLT2zSdSeA2A3thOFIkdWZHpdzPS21wUk=;
	h=Date:To:From:Subject:From;
	b=aAJ6XpSP7lEvOCVaWSs0yPwpCceqMCCenXG8PPyy4ybhPFb9JZ8BXK7NP9nCpWvX6
	 jxp1Hh80+7kEJeY0AmTuMmTA0HyyFOOsBI6xyFG4HXIlFAQaPc8diY5nBQLQn4KnyR
	 JxadnLk1HOOjqhxJQFLLly18USzbWXQ6rhrbyEAs=
Date: Thu, 26 Sep 2024 13:22:08 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,tglx@linutronix.de,hdanton@sina.com,frederic@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread-unpark-only-parked-kthread.patch added to mm-hotfixes-unstable branch
Message-Id: <20240926202210.319ECC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kthread: Unpark only parked kthread
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kthread-unpark-only-parked-kthread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-unpark-only-parked-kthread.patch

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
From: Frederic Weisbecker <frederic@kernel.org>
Subject: kthread: Unpark only parked kthread
Date: Fri, 13 Sep 2024 23:46:34 +0200

Calling into kthread unparking unconditionally is mostly harmless when
the kthread is already unparked. The wake up is then simply ignored
because the target is not in TASK_PARKED state.

However if the kthread is per CPU, the wake up is preceded by a call
to kthread_bind() which expects the task to be inactive and in
TASK_PARKED state, which obviously isn't the case if it is unparked.

As a result, calling kthread_stop() on an unparked per-cpu kthread
triggers such a warning:

	WARNING: CPU: 0 PID: 11 at kernel/kthread.c:525 __kthread_bind_mask kernel/kthread.c:525
	 <TASK>
	 kthread_stop+0x17a/0x630 kernel/kthread.c:707
	 destroy_workqueue+0x136/0xc40 kernel/workqueue.c:5810
	 wg_destruct+0x1e2/0x2e0 drivers/net/wireguard/device.c:257
	 netdev_run_todo+0xe1a/0x1000 net/core/dev.c:10693
	 default_device_exit_batch+0xa14/0xa90 net/core/dev.c:11769
	 ops_exit_list net/core/net_namespace.c:178 [inline]
	 cleanup_net+0x89d/0xcc0 net/core/net_namespace.c:640
	 process_one_work kernel/workqueue.c:3231 [inline]
	 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
	 worker_thread+0x86d/0xd70 kernel/workqueue.c:3393
	 kthread+0x2f0/0x390 kernel/kthread.c:389
	 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
	 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
	 </TASK>

Fix this with skipping unecessary unparking while stopping a kthread.

Reported-and-tested-by: syzbot+943d34fa3cf2191e3068@syzkaller.appspotmail.com
Link: https://lkml.kernel.org/r/20240913214634.12557-1-frederic@kernel.org
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/kthread.c~kthread-unpark-only-parked-kthread
+++ a/kernel/kthread.c
@@ -623,6 +623,8 @@ void kthread_unpark(struct task_struct *
 {
 	struct kthread *kthread = to_kthread(k);
 
+	if (!test_bit(KTHREAD_SHOULD_PARK, &kthread->flags))
+		return;
 	/*
 	 * Newly created kthread was parked when the CPU was offline.
 	 * The binding was lost and we need to set it again.
_

Patches currently in -mm which might be from frederic@kernel.org are

kthread-unpark-only-parked-kthread.patch

