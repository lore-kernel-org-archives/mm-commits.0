Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0509D186E20
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855673; cv=none; b=FsCX7Wc/JzQH+r5PwNNMuj3xfv0VGPuP8KBrgLSZmqNlBQcSQmvQvhXE4TX4aS4yAV0FoRJjqGrk8FkrWLEfAx6J6cA0cFNkAiwTOMQkIKw6nh8VREvXNoa0PVVoKyW6a0OO9T36KbPGAAK7yCGlCStteixg8npeMLhMvwtvaXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855673; c=relaxed/simple;
	bh=4+yOLi6fwpNdq2JQw+ugs/6LQzdrrePVZ3dI/hoOfDQ=;
	h=Date:To:From:Subject:Message-Id; b=YSFGgGZxBl9x9TCbhhNB/E+dirrgKqjHLO7pcWMb7r8axQ7rZPugaYmSldQTI2Z7tGklzxrT9BWfF7liT4fnjOXV96h3T0w8USjsLF02FL4QtHQYACNN4AUWBp2dR11OGR4e8lIHuqaEo/h2LnQL5QCCowxf7XB+ek1eC9TaQ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BfmCvoaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BfmCvoaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE51BC4CECF;
	Wed,  6 Nov 2024 01:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855672;
	bh=4+yOLi6fwpNdq2JQw+ugs/6LQzdrrePVZ3dI/hoOfDQ=;
	h=Date:To:From:Subject:From;
	b=BfmCvoaV7N7/gabJEp3vGfEAuQUs8/pRS/fgjmohFa0TskvveHt5gRFGxzp4x3y0U
	 QdaiE+pG/QTUFoJK4CbkbPX9ioSLZ1cpeeykEEwvhXD4z+wlv0gEB/iDYXxGmjCnNF
	 3ZgvvGQrH5UretB+7HtzarzXsay1qrPpgYPeq5hg=
Date: Tue, 05 Nov 2024 17:14:32 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,linux@weissschuh.net,libang.li@antgroup.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jsiddle@redhat.com,joel.granados@kernel.org,j.granados@samsung.com,david@redhat.com,cunhuang@tencent.com,baolin.wang@linux.alibaba.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-add-detect-count-for-hung-tasks.patch removed from -mm tree
Message-Id: <20241106011432.CE51BC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: add detect count for hung tasks
has been removed from the -mm tree.  Its filename was
     hung_task-add-detect-count-for-hung-tasks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: hung_task: add detect count for hung tasks
Date: Sun, 27 Oct 2024 20:07:46 +0800

Patch series "add detect count for hung tasks", v2.

This patchset adds a counter, hung_task_detect_count, to track the number
of times hung tasks are detected.  

IHMO, hung tasks are a critical metric.  Currently, we detect them by
periodically parsing dmesg.  However, this method isn't as user-friendly
as using a counter.

Sometimes, a short-lived issue with NIC or hard drive can quickly decrease
the hung_task_warnings to zero.  Without warnings, we must directly access
the node to ensure that there are no more hung tasks and that the system
has recovered.  After all, load average alone cannot provide a clear
picture.

Once this counter is in place, in a high-density deployment pattern, we
plan to set hung_task_timeout_secs to a lower number to improve stability,
even though this might result in false positives.  And then we can set a
time-based threshold: if hung tasks last beyond this duration, we will
automatically migrate containers to other nodes.  Based on past
experience, this approach could help avoid many production disruptions.

Moreover, just like other important events such as OOM that already have
counters, having a dedicated counter for hung tasks makes sense ;)


This patch (of 2):

This commit adds a counter, hung_task_detect_count, to track the number of
times hung tasks are detected.

IHMO, hung tasks are a critical metric. Currently, we detect them by
periodically parsing dmesg. However, this method isn't as user-friendly as
using a counter.

Sometimes, a short-lived issue with NIC or hard drive can quickly decrease
the hung_task_warnings to zero. Without warnings, we must directly access
the node to ensure that there are no more hung tasks and that the system
has recovered. After all, load average alone cannot provide a clear
picture.

Once this counter is in place, in a high-density deployment pattern, we
plan to set hung_task_timeout_secs to a lower number to improve stability,
even though this might result in false positives. And then we can set a
time-based threshold: if hung tasks last beyond this duration, we will
automatically migrate containers to other nodes. Based on past experience,
this approach could help avoid many production disruptions.

Moreover, just like other important events such as OOM that already have
counters, having a dedicated counter for hung tasks makes sense.

Link: https://lkml.kernel.org/r/20241027120747.42833-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20241027120747.42833-2-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Cun <cunhuang@tencent.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Siddle <jsiddle@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Yongliang Gao <leonylgao@tencent.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/kernel/hung_task.c~hung_task-add-detect-count-for-hung-tasks
+++ a/kernel/hung_task.c
@@ -31,6 +31,11 @@
 static int __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
 
 /*
+ * Total number of tasks detected as hung since boot:
+ */
+static unsigned long __read_mostly sysctl_hung_task_detect_count;
+
+/*
  * Limit number of tasks checked in a batch.
  *
  * This value controls the preemptibility of khungtaskd since preemption
@@ -115,6 +120,12 @@ static void check_hung_task(struct task_
 	if (time_is_after_jiffies(t->last_switch_time + timeout * HZ))
 		return;
 
+	/*
+	 * This counter tracks the total number of tasks detected as hung
+	 * since boot.
+	 */
+	sysctl_hung_task_detect_count++;
+
 	trace_sched_process_hang(t);
 
 	if (sysctl_hung_task_panic) {
@@ -314,6 +325,13 @@ static struct ctl_table hung_task_sysctl
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_NEG_ONE,
 	},
+	{
+		.procname	= "hung_task_detect_count",
+		.data		= &sysctl_hung_task_detect_count,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 };
 
 static void __init hung_task_sysctl_init(void)
_

Patches currently in -mm which might be from ioworker0@gmail.com are


