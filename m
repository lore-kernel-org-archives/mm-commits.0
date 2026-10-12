Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA803AF64B
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 18:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791831008; cv=none; b=VJZU9N2Lz0bLv7K3LOtHNhTpdwWaLk45MC8w2kiz2JRsIFxbisvLHB6d+GmQ6umD4i+5sAMil799CyN17Nvzl1z6RApiUKVJ3iUdJtsQ42FmJXap623Xq0SS87w7rrWiYixIAunN88iQIhpJujKzNKOp59iBtvS0aRreaZ1bgSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791831008; c=relaxed/simple;
	bh=hmnbnTviXvhCj1LUk/tPDEiUfeZOLEZrbdbiMx3GcIw=;
	h=Date:To:From:Subject:Message-Id; b=guBkmc78KBvMsgKMuhWm2MpXgwIJUq410vH1RXlfoKBCMhZjtmxuNDWmPYXLdnIfenK5+jltTu8BvXkOEjb58Aik67RiKe16DbgR+UuJtKvNESpQ333wNbPndKUubXeW6Nv98dMQaFPDYwAp7vPV4/rsfI0+vTg+yCdhaTLEBtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i8PJw6OS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i8PJw6OS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF97C1F0089B;
	Mon, 12 Oct 2026 18:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791831006;
	bh=6cb/JaCdhWZgm2uMKmxGPHEcyltrU/SWLv5DcGfNx9w=;
	h=Date:To:From:Subject;
	b=i8PJw6OSB4WByvrZOlD7rmkuzAeGhZRVc8wxpQhtvVdY1CMit8D80aIY1CEuhltUy
	 eizoD0jbAbWPBqZnJ7l/4UaJ5spCHqweHdo5hmK5G0ifSYX0HxXHJ2A/Gc+mQl+Xwh
	 l5Lqy3WeIZaB4lgxeA3LL7lwJiqfOxHxlEBFIfSI=
Date: Mon, 12 Oct 2026 11:50:06 -0700
To: mm-commits@vger.kernel.org,david.laight.linux@gmail.com,brauner@kernel.org,25181214217@stu.xidian.edu.cn,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] pid-document-that-do_each_pid_task-needs-tasklist_lock.patch removed from -mm tree
Message-Id: <20261012185006.BF97C1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pid: document that do_each_pid_task() needs tasklist_lock
has been removed from the -mm tree.  Its filename was
     pid-document-that-do_each_pid_task-needs-tasklist_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


