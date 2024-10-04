Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDD51CF83;
	Fri,  4 Oct 2024 02:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008773; cv=none; b=OzgNRfctmcQejhAD7jC76lFSVcOeUgpzVbECUsnNz60r2wC7nZ6Pkum1iUpm07G3Bk571+0XfP1U7tJj6aSZdZ7ZtbfuN9WdHfYv81iUMBa0oSerjEd6qJyq9/INT6ORA+uosNtvfZ+/gcQItaJfhDLnhtm6nlYv3Vimu70yqTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008773; c=relaxed/simple;
	bh=GMnrujM0zm0apvAexcF+JfloyXlRp3m9jTg8SqyfaCQ=;
	h=Date:To:From:Subject:Message-Id; b=WC/WGdFvELIVc/8YyMA/euQZvwjrQSXpQ4jAQaHLZnCScXexAWJmtTYcJowprtcAseji0jgWPNqNqNnZJgAAkiLkFOKNpAlZJdh5tfzsUedAV+BXlT5EnGsLGOxmAP8xzYrNk9eCa0blbvEI1Sh2/X6cUfVekN/w9i3xRQ7DKx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eLjsAud7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eLjsAud7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD5BC4CEC5;
	Fri,  4 Oct 2024 02:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008773;
	bh=GMnrujM0zm0apvAexcF+JfloyXlRp3m9jTg8SqyfaCQ=;
	h=Date:To:From:Subject:From;
	b=eLjsAud7iiQy1n8Dnlpr+3HEsYybuz64roNPhdIjgEWjXCjOQBGTYKPnKWZoa6a4L
	 63TLjx95ip8dV/uyYoXy1NlWByCH+BFvt+/H94mNIR7Rr6KqJon0BhHyi/dImjLwtt
	 5Ab2bYOUqn7HGW5qSsUrKf/rL+KuVpzHcW6rBdNU=
Date: Thu, 03 Oct 2024 19:26:12 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,tglx@linutronix.de,stable@vger.kernel.org,hdanton@sina.com,frederic@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kthread-unpark-only-parked-kthread.patch removed from -mm tree
Message-Id: <20241004022613.2BD5BC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kthread: unpark only parked kthread
has been removed from the -mm tree.  Its filename was
     kthread-unpark-only-parked-kthread.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frederic Weisbecker <frederic@kernel.org>
Subject: kthread: unpark only parked kthread
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

Link: https://lkml.kernel.org/r/20240913214634.12557-1-frederic@kernel.org
Fixes: 5c25b5ff89f0 ("workqueue: Tag bound workers with KTHREAD_IS_PER_CPU")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reported-by: syzbot+943d34fa3cf2191e3068@syzkaller.appspotmail.com
Tested-by: syzbot+943d34fa3cf2191e3068@syzkaller.appspotmail.com
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
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


