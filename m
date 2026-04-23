Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3311126C03
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776952465; cv=none; b=r9wfwS9RxsBKcd316xmW6UKaCVxm1RmJpQFNIjbNQZWXAbWRK08vJBvUzlpjOQ0Adbn2AGdOs1SSNxhqhTfuOSKTel2MLMQKDJB/OxSHnee4o7Zl2xHxaJdxEphOavtcSpQ6NgU7lVxZ3+bNf8mgW/98XDe5J74ST0rVkYJNDM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776952465; c=relaxed/simple;
	bh=LWktz5VVOYnjJ8JJMDbVBpqVRKxBmg+DprVWmYjxYQ4=;
	h=Date:To:From:Subject:Message-Id; b=gxFay2kyIAI6tuZFGlIM1BxuBxoJQtjy6o/cmPFDee2o/YV78QMbbhFty9smgrccuC7wT6kjD+V8JJ2abVSvr4i8z6DQgunSyqesZZ492c/qvmVG2XmLG0k0c7pXtD22GnXUQ/3iMTMMNCDetDe65Lx8L12ioFxQRD85B6J+gxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FxfHKzh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FxfHKzh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72684C2BCB3;
	Thu, 23 Apr 2026 13:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776952465;
	bh=LWktz5VVOYnjJ8JJMDbVBpqVRKxBmg+DprVWmYjxYQ4=;
	h=Date:To:From:Subject:From;
	b=FxfHKzh3pgG4SFsjBdxCpVNpHriCWXkLU7WTueKx7TTkOtYkfl7qgMBoIY453GbLR
	 YB4tSd7wkr48jQKjSuPcY8o/zjqKA8X9Cjw7T4mxwznnoJfg/iqmX4ZxQaE4s6TpN2
	 h2osLlCH4kAYIQynniXP/Q2SaIeortYxCFQedvkg=
Date: Thu, 23 Apr 2026 06:54:24 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-rewrite-next_tgid.patch added to mm-nonmm-unstable branch
Message-Id: <20260423135425.72684C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: rewrite next_tgid()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-rewrite-next_tgid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-rewrite-next_tgid.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: rewrite next_tgid()
Date: Wed, 22 Apr 2026 22:17:45 +0300

* deduplicate "iter.tgid += 1" line,
  Right now it is done once inside next_tgid() itself and second time
  inside "for" loop.

* deduplicate next_tgid() call itself with different loop style:

	auto it = make_tgid_iter();
	while (next_tgid(&it)) {
		...
	}

  gcc seems to inline it twice:

  	$ ./scripts/bloat-o-meter ../vmlinux-000 ../obj/vmlinux
	add/remove: 0/1 grow/shrink: 1/0 up/down: 100/-245 (-145)
	Function                                     old     new   delta
	proc_pid_readdir                             531     631    +100
	next_tgid                                    245       -    -245

* make tgid_iter.pid_ns const
  it never changes during readdir anyway

Link: https://lore.kernel.org/20260422191745.435556-2-adobriyan@gmail.com
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   57 +++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 24 deletions(-)

--- a/fs/proc/base.c~proc-rewrite-next_tgid
+++ a/fs/proc/base.c
@@ -3543,30 +3543,43 @@ out:
 struct tgid_iter {
 	unsigned int tgid;
 	struct task_struct *task;
-	struct pid_namespace *pid_ns;
+	struct pid_namespace *const pid_ns;
 };
 
-static struct tgid_iter next_tgid(struct tgid_iter iter)
+static
+struct tgid_iter
+make_tgid_iter(unsigned int init_tgid, struct pid_namespace *pid_ns)
 {
-	struct pid *pid;
+	return (struct tgid_iter){
+		.tgid = init_tgid - 1,
+		.pid_ns = pid_ns,
+	};
+}
+
+static bool next_tgid(struct tgid_iter *it)
+{
+	if (it->task) {
+		put_task_struct(it->task);
+		it->task = NULL;
+	}
 
-	if (iter.task)
-		put_task_struct(iter.task);
 	rcu_read_lock();
-retry:
-	iter.task = NULL;
-	pid = find_ge_pid(iter.tgid, iter.pid_ns);
-	if (pid) {
-		iter.tgid = pid_nr_ns(pid, iter.pid_ns);
-		iter.task = pid_task(pid, PIDTYPE_TGID);
-		if (!iter.task) {
-			iter.tgid += 1;
-			goto retry;
+	while (1) {
+		it->tgid += 1;
+		const auto pid = find_ge_pid(it->tgid, it->pid_ns);
+		if (pid) {
+			it->tgid = pid_nr_ns(pid, it->pid_ns);
+			it->task = pid_task(pid, PIDTYPE_TGID);
+			if (it->task) {
+				get_task_struct(it->task);
+				rcu_read_unlock();
+				return true;
+			}
+		} else {
+			rcu_read_unlock();
+			return false;
 		}
-		get_task_struct(iter.task);
 	}
-	rcu_read_unlock();
-	return iter;
 }
 
 #define TGID_OFFSET (FIRST_PROCESS_ENTRY + 2)
@@ -3574,7 +3587,6 @@ retry:
 /* for the /proc/ directory itself, after non-process stuff has been done */
 int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 {
-	struct tgid_iter iter;
 	struct proc_fs_info *fs_info = proc_sb_info(file_inode(file)->i_sb);
 	struct pid_namespace *pid_ns = proc_pid_ns(file_inode(file)->i_sb);
 	loff_t pos = ctx->pos;
@@ -3592,12 +3604,9 @@ int proc_pid_readdir(struct file *file,
 			return 0;
 		ctx->pos = pos = pos + 1;
 	}
-	iter.tgid = pos - TGID_OFFSET;
-	iter.task = NULL;
-	iter.pid_ns = pid_ns;
-	for (iter = next_tgid(iter);
-	     iter.task;
-	     iter.tgid += 1, iter = next_tgid(iter)) {
+
+	auto iter = make_tgid_iter(pos - TGID_OFFSET, pid_ns);
+	while (next_tgid(&iter)) {
 		char name[10 + 1];
 		unsigned int len;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-add-tgid_iterpid_ns-member.patch
proc-rewrite-next_tgid.patch

