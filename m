Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F188472
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 02:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791771765; cv=none; b=oWIIOeaqg1d+WaRkgAv/PKAtQi1cuJ3BiQpbSmKwLbJc0iT1XrfIDS17DsharyosOTgYDQdzbHGSGWzhNL+DGG1i103CLmT4ZjaWiEVrEI8PvQbvkk8jn9eYIyB6/AWuWqOJLYOCH04Ikz7/8cLG5NsCaLU/tqbhPbqdgdadO+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791771765; c=relaxed/simple;
	bh=TigLoMnTpfWOIvo1JJhR4bW/1B6tzAqk8l/+zWFkAgg=;
	h=Date:To:From:Subject:Message-Id; b=RxK/E7zaIuaITXnmdMm+r7WnyrTLWWXiWzjsWuKRovO5hErsR5QUw64UjNXVsFwOcZpset0iXQC7BXXAESmu/05ImFhx7+PJlm7msmfv9SlS+K50kv1rGz8vGBUED9hfTTcTnyU2o6vCSZYZLl9NfMbs/SZqdx3Kz+erWuMMAhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LyA5pjXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LyA5pjXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81E21F0089B;
	Mon, 12 Oct 2026 02:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791771763;
	bh=Mi4SiM3ktef1LFGxZcU+OrTOxVYSUMZRoBwCU/yo3/A=;
	h=Date:To:From:Subject;
	b=LyA5pjXjojwfX1O8FeKAxB1MQf2ONbo7XAMQDLIprqRX4a4y3UdfRDfQwYwOiYxiI
	 x8IpgR9mIh5aqWxNgxalc7Jk0rtS2apYJIKWgdMVxVL6Oro5hErOyLibmIMzjyLxlk
	 7HWm6NbiJmsOZLPVlawP4wjQ85RtPMJdbpWUrFug=
Date: Sun, 11 Oct 2026 19:22:43 -0700
To: mm-commits@vger.kernel.org,david.laight.linux@gmail.com,brauner@kernel.org,25181214217@stu.xidian.edu.cn,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pid-document-that-do_each_pid_task-needs-tasklist_lock.patch added to mm-nonmm-unstable branch
Message-Id: <20261012022243.C81E21F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pid: document that do_each_pid_task() needs tasklist_lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pid-document-that-do_each_pid_task-needs-tasklist_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-document-that-do_each_pid_task-needs-tasklist_lock.patch

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: pid: document that do_each_pid_task() needs tasklist_lock
Date: Sun, 11 Oct 2026 16:16:51 +0200

do_each_pid_task() looks "obviously rcu-safe". This confuses people
and we already have 2 buggy users: send_sigio() and send_sigurg().

The reasons why it is not are not obvious at all, add the comment.

Link: https://lore.kernel.org/asuaU8H_5MbO3-cW@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Mingyu Wang <25181214217@stu.xidian.edu.cn>
---

 include/linux/pid.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/linux/pid.h~pid-document-that-do_each_pid_task-needs-tasklist_lock
+++ a/include/linux/pid.h
@@ -187,6 +187,15 @@ static inline pid_t pid_nr(struct pid *p
 pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
 pid_t pid_vnr(struct pid *pid);
 
+/*
+ * Needs tasklist_lock if type > PIDTYPE_TGID. A lockless reader can:
+ *
+ * - race with a change_pid() that moves the task to another hlist,
+ *   and continue to scan the wrong list.
+ *
+ * - race with a copy_process() that adds a new task to the start of hlist,
+ *   and miss the new child.
+ */
 #define do_each_pid_task(pid, type, task)				\
 	do {								\
 		if ((pid) != NULL)					\
_

Patches currently in -mm which might be from oleg@redhat.com are

pid-document-that-do_each_pid_task-needs-tasklist_lock.patch

