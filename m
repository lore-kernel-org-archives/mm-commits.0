Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD20F2DC79F
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 13:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776952463; cv=none; b=YR4zw59j5kIaTJaQ+ZUQx0mTxYEwH4nNfEYkBlCGNM1THttyAnlFYzSq+WaoofBH1DjwuQ86i5rIf8SEyDAnQVoX2H826js4jtql+SfnD0wrABpdpFlXAdk2fytTCIU9LuFZRCu79JnuI3hT10eGFzMz908+HPrhlTb3SrYyJek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776952463; c=relaxed/simple;
	bh=RBji3asVvcM9exGTZF0MTVl2LKI0uHRvthk5Ox8G9dM=;
	h=Date:To:From:Subject:Message-Id; b=JBkjnh4NBzXQvfiGf6/Rn6NcM6UPYn3Yr6du4LigelFic0IOLAsJXu65D/FOZGP15sbjX8IKRB4U29wQerD98rQmR0JYKQIVEo/Vn/Y5jTniZSAgjfkm/sqHinYCRRKrqQUuZ7OiisCSaYMDt6abTXeqq+nb/zURzy9hDOTasLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xTWF+GXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xTWF+GXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B77C2BCB3;
	Thu, 23 Apr 2026 13:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776952463;
	bh=RBji3asVvcM9exGTZF0MTVl2LKI0uHRvthk5Ox8G9dM=;
	h=Date:To:From:Subject:From;
	b=xTWF+GXIw8td4cb0bFP3UQL27AMasP25Tdc+Tw02vxszTVccSe1U92hsz8S0yttrZ
	 w0qw0qJMijptu2e3pSwKXAVfBUe1QVtmJUl/Smgxb/canK0rBINroYqard1AM1F8uW
	 m0NtR034HbX8TJ/oepO+rZFKsZOL2tJcojqciRVU=
Date: Thu, 23 Apr 2026 06:54:22 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-add-tgid_iterpid_ns-member.patch added to mm-nonmm-unstable branch
Message-Id: <20260423135423.55B77C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: add tgid_iter.pid_ns member
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-add-tgid_iterpid_ns-member.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-add-tgid_iterpid_ns-member.patch

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

proc-add-tgid_iterpid_ns-member.patch
proc-rewrite-next_tgid.patch

