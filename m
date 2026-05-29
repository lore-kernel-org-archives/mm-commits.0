Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DDC371867
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028728; cv=none; b=UDfNrtDTHygg90zWbcRuKj+rj5KvU/Vx/cnEnIJbSKQxEzfnmJb0JuacDtFhnIJ8TRt9kRcbNnKwuCcra0Oq22mQm+slgyIlrxTGtUvxPsb9SxO+tc7zXn+g1Wymyltj36sKgV99aJGUqARBSKNnTghJCNn+iHRWfj5POoLZth0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028728; c=relaxed/simple;
	bh=j6s7G2VRgivbgwp60eYGVqyktLAJxM82jxs3jicMnuc=;
	h=Date:To:From:Subject:Message-Id; b=ON0qWP4iTSI3MvNolwXX5y9nurgJdX+LzHAZqSB5vt6PGlF8J/O33p9P0J1494YM92IdudSWfzSxLzXVBOIeQjmtqmei7dSmweIQGvvVq6ge2oSE9G/gBD6RMjjV82zUPJcG7MOgSSC1/Xx24FD/M0RC955slYcSQLnVOwkIOk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1UhDo4yL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1UhDo4yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AF51F00893;
	Fri, 29 May 2026 04:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028727;
	bh=QEaZesY8YtaP/CSm1I/EdkK/+sMRCh0wIi9AVUIkB5I=;
	h=Date:To:From:Subject;
	b=1UhDo4yLgoBC2OpwnjUlj1yIzl5oVAB3+Sg0lh5BSG1dWr5jzwPZ439jT9FNeZuNZ
	 2nqCM6Yw67SKFLx6RpHW4l8QmNzoFRJe9KcE0wZXYZaDxUDxu/1rIGMe6HLrP3gRJh
	 eMNVF0xvhqDysM310UryTrWtL24SeqxvcnsmSB+8=
Date: Thu, 28 May 2026 21:25:26 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-add-tgid_iterpid_ns-member.patch removed from -mm tree
Message-Id: <20260529042527.55AF51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: add tgid_iter.pid_ns member
has been removed from the -mm tree.  Its filename was
     proc-add-tgid_iterpid_ns-member.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: add tgid_iter.pid_ns member
Date: Wed, 22 Apr 2026 22:17:44 +0300

next_tgid() accepts pid namespace as an argument, but it never changes
during readdir (which would be unthinkable thing to do anyway).

Move it inside iterator type and hide from direct usage.

Link: https://lore.kernel.org/20260422191745.435556-1-adobriyan@gmail.com
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/proc/base.c~proc-add-tgid_iterpid_ns-member
+++ a/fs/proc/base.c
@@ -3543,8 +3543,10 @@ out:
 struct tgid_iter {
 	unsigned int tgid;
 	struct task_struct *task;
+	struct pid_namespace *pid_ns;
 };
-static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter)
+
+static struct tgid_iter next_tgid(struct tgid_iter iter)
 {
 	struct pid *pid;
 
@@ -3553,9 +3555,9 @@ static struct tgid_iter next_tgid(struct
 	rcu_read_lock();
 retry:
 	iter.task = NULL;
-	pid = find_ge_pid(iter.tgid, ns);
+	pid = find_ge_pid(iter.tgid, iter.pid_ns);
 	if (pid) {
-		iter.tgid = pid_nr_ns(pid, ns);
+		iter.tgid = pid_nr_ns(pid, iter.pid_ns);
 		iter.task = pid_task(pid, PIDTYPE_TGID);
 		if (!iter.task) {
 			iter.tgid += 1;
@@ -3574,7 +3576,7 @@ int proc_pid_readdir(struct file *file,
 {
 	struct tgid_iter iter;
 	struct proc_fs_info *fs_info = proc_sb_info(file_inode(file)->i_sb);
-	struct pid_namespace *ns = proc_pid_ns(file_inode(file)->i_sb);
+	struct pid_namespace *pid_ns = proc_pid_ns(file_inode(file)->i_sb);
 	loff_t pos = ctx->pos;
 
 	if (pos >= PID_MAX_LIMIT + TGID_OFFSET)
@@ -3592,9 +3594,10 @@ int proc_pid_readdir(struct file *file,
 	}
 	iter.tgid = pos - TGID_OFFSET;
 	iter.task = NULL;
-	for (iter = next_tgid(ns, iter);
+	iter.pid_ns = pid_ns;
+	for (iter = next_tgid(iter);
 	     iter.task;
-	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
+	     iter.tgid += 1, iter = next_tgid(iter)) {
 		char name[10 + 1];
 		unsigned int len;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are


