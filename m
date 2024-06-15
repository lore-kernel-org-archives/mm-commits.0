Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5A04D13B;
	Sat, 15 Jun 2024 17:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473449; cv=none; b=h2uuwfqHwv1TPGw6PyGM3rQyBVhnv8sirDgfOjtEEPc1VX02xkgjcJHSqptcuy3u0fARS9BrbH5Lbs8h17SxfVnbxNgCYggDmtGzzj0NmYUfl4Wq+XZ0VUgpZosYuPdwgMAIqm4VsFSgXzalwT7SozA3n7T52I8FfzcODSZ7+mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473449; c=relaxed/simple;
	bh=AmqvOQpO3QrQWuQhJinIdBoo38s+x90NYqSrGEhX8cQ=;
	h=Date:To:From:Subject:Message-Id; b=qixRFRJLMImwcsvM0s7agwu96959AvQvfM9hvSZs20eZESnJZ+RoBH/UdjPR8/X8ioUstEjR7Wj0WIZC4BVtJ8Sq0UkAzmnT9DEaqKojKiHfXZRCAaf7YmLNmAeW69PIFSJeDZsK7ad88S6vVx98h0FRDVchH8XVsjsHdPxUdYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DAG5FNnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DAG5FNnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D601FC116B1;
	Sat, 15 Jun 2024 17:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473448;
	bh=AmqvOQpO3QrQWuQhJinIdBoo38s+x90NYqSrGEhX8cQ=;
	h=Date:To:From:Subject:From;
	b=DAG5FNnP2Wk9H4a//YKirybPqQFv8xJpA4bPTUBtNa0AQnh8khNhM26lI2VBZKh/3
	 R5algB9xFRr22yrLFcBmIh0XseExmL5qt3vTdNsvhEICjMc7O8OS2zEWIqA9voAIfe
	 fJk9NuloK5DVIXqGBgWSBS1UJsblT8Y/0dhswYqA=
Date: Sat, 15 Jun 2024 10:44:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,arnd@arndb.de,andreyknvl@gmail.com,nogikh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kcov-dont-lose-track-of-remote-references-during-softirqs.patch removed from -mm tree
Message-Id: <20240615174408.D601FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: don't lose track of remote references during softirqs
has been removed from the -mm tree.  Its filename was
     kcov-dont-lose-track-of-remote-references-during-softirqs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aleksandr Nogikh <nogikh@google.com>
Subject: kcov: don't lose track of remote references during softirqs
Date: Tue, 11 Jun 2024 15:32:29 +0200

In kcov_remote_start()/kcov_remote_stop(), we swap the previous KCOV
metadata of the current task into a per-CPU variable.  However, the
kcov_mode_enabled(mode) check is not sufficient in the case of remote KCOV
coverage: current->kcov_mode always remains KCOV_MODE_DISABLED for remote
KCOV objects.

If the original task that has invoked the KCOV_REMOTE_ENABLE ioctl happens
to get interrupted and kcov_remote_start() is called, it ultimately leads
to kcov_remote_stop() NOT restoring the original KCOV reference.  So when
the task exits, all registered remote KCOV handles remain active forever.

The most uncomfortable effect (at least for syzkaller) is that the bug
prevents the reuse of the same /sys/kernel/debug/kcov descriptor.  If
we obtain it in the parent process and then e.g.  drop some
capabilities and continuously fork to execute individual programs, at
some point current->kcov of the forked process is lost,
kcov_task_exit() takes no action, and all KCOV_REMOTE_ENABLE ioctls
calls from subsequent forks fail.

And, yes, the efficiency is also affected if we keep on losing remote
kcov objects.
a) kcov_remote_map keeps on growing forever.
b) (If I'm not mistaken), we're also not freeing the memory referenced
by kcov->area.

Fix it by introducing a special kcov_mode that is assigned to the task
that owns a KCOV remote object.  It makes kcov_mode_enabled() return true
and yet does not trigger coverage collection in __sanitizer_cov_trace_pc()
and write_comp_data().

[nogikh@google.com: replace WRITE_ONCE() with an ordinary assignment]
  Link: https://lkml.kernel.org/r/20240614171221.2837584-1-nogikh@google.com
Link: https://lkml.kernel.org/r/20240611133229.527822-1-nogikh@google.com
Fixes: 5ff3b30ab57d ("kcov: collect coverage from interrupts")
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Tested-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kcov.h |    2 ++
 kernel/kcov.c        |    1 +
 2 files changed, 3 insertions(+)

--- a/include/linux/kcov.h~kcov-dont-lose-track-of-remote-references-during-softirqs
+++ a/include/linux/kcov.h
@@ -21,6 +21,8 @@ enum kcov_mode {
 	KCOV_MODE_TRACE_PC = 2,
 	/* Collecting comparison operands mode. */
 	KCOV_MODE_TRACE_CMP = 3,
+	/* The process owns a KCOV remote reference. */
+	KCOV_MODE_REMOTE = 4,
 };
 
 #define KCOV_IN_CTXSW	(1 << 30)
--- a/kernel/kcov.c~kcov-dont-lose-track-of-remote-references-during-softirqs
+++ a/kernel/kcov.c
@@ -632,6 +632,7 @@ static int kcov_ioctl_locked(struct kcov
 			return -EINVAL;
 		kcov->mode = mode;
 		t->kcov = kcov;
+	        t->kcov_mode = KCOV_MODE_REMOTE;
 		kcov->t = t;
 		kcov->remote = true;
 		kcov->remote_size = remote_arg->area_size;
_

Patches currently in -mm which might be from nogikh@google.com are


