Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6E4371868
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028729; cv=none; b=jzE8ZsBNW2kbmv4PSXN3BDplv8pz+ZuqWFcVRpVFU516Mk0qdiITV1vHACYQWporJ/cU1UVGQTfZVL6WAVy/1Sg4ce8IkRPENfu2vtND0k/mQurOi4DmDuqCJX8d0xagWRbJyN4GfXPKAaEdOgjrQogDTTxfXVnm0Wm9NExnyqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028729; c=relaxed/simple;
	bh=ZTrR90dF4p3GwrCL+DoUxmqC3mCsx12ynKzRM/xksY8=;
	h=Date:To:From:Subject:Message-Id; b=nOdNmeFcF/1Dc7qSen0+OjCrSg9bbQuJHJxSSOWZi/NZ5K7KMuQjiTb+9eyKBVAqZdqFGswJU4W0XLzH3Xmb6z7LPqr4wwaxpool/yL5u/VOV5aPGkUh2E/Vzd0zhBwxqifWw740b4y2NSYpFi7nQRw1EkqT6CQYBOzoiYEKdxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1uvyu57i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1uvyu57i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767431F00898;
	Fri, 29 May 2026 04:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028728;
	bh=jtL6+d2ZSSskj9x131wHM1EmH9V6YCh5qIS1yTT6CG0=;
	h=Date:To:From:Subject;
	b=1uvyu57iCM3uPSA1CFl0rTiL2uGCKI8w8xeZqXGCr0cWfmId+7kuu1CuK9/ZIVBI4
	 RG66t9ZIWZWKCVqpxZZcAqFxm5DBA9dfRZ1EwQyWeQBunJ7oVMcIEr3dxWaLwLalQw
	 eVIJmdV0O8pDaFkmomdT6tldaScWrXdE7nSxeE8c=
Date: Thu, 28 May 2026 21:25:28 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-rewrite-next_tgid.patch removed from -mm tree
Message-Id: <20260529042528.767431F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: rewrite next_tgid()
has been removed from the -mm tree.  Its filename was
     proc-rewrite-next_tgid.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: remove newline]
Link: https://lore.kernel.org/20260422191745.435556-2-adobriyan@gmail.com
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   56 ++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

--- a/fs/proc/base.c~proc-rewrite-next_tgid
+++ a/fs/proc/base.c
@@ -3543,30 +3543,42 @@ out:
 struct tgid_iter {
 	unsigned int tgid;
 	struct task_struct *task;
-	struct pid_namespace *pid_ns;
+	struct pid_namespace *const pid_ns;
 };
 
-static struct tgid_iter next_tgid(struct tgid_iter iter)
+static struct tgid_iter
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
@@ -3574,7 +3586,6 @@ retry:
 /* for the /proc/ directory itself, after non-process stuff has been done */
 int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 {
-	struct tgid_iter iter;
 	struct proc_fs_info *fs_info = proc_sb_info(file_inode(file)->i_sb);
 	struct pid_namespace *pid_ns = proc_pid_ns(file_inode(file)->i_sb);
 	loff_t pos = ctx->pos;
@@ -3592,12 +3603,9 @@ int proc_pid_readdir(struct file *file,
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


