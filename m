From: akpm@linux-foundation.org
Subject: [merged] autofs4-use-pr_xxx-macros-directly-for-logging.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:58:01 -0700
Message-ID: <56e9bac9.xOjlSJyCYR8dovUu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbcCPT6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: use pr_xxx() macros directly for logging
has been removed from the -mm tree.  Its filename was
     autofs4-use-pr_xxx-macros-directly-for-logging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <ikent@redhat.com>
Subject: autofs4: use pr_xxx() macros directly for logging

Use the standard pr_xxx() log macros directly for log prints instead of
the AUTOFS_XXX() macros.

Signed-off-by: Ian Kent <ikent@redhat.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h  |   15 ++++-----------
 fs/autofs4/dev-ioctl.c |   26 +++++++++++++-------------
 fs/autofs4/expire.c    |   24 ++++++++++++------------
 fs/autofs4/inode.c     |   22 +++++++++++-----------
 fs/autofs4/root.c      |   32 ++++++++++++++++----------------
 fs/autofs4/waitq.c     |   24 ++++++++++++------------
 6 files changed, 68 insertions(+), 75 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-use-pr_xxx-macros-directly-for-logging fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-use-pr_xxx-macros-directly-for-logging
+++ a/fs/autofs4/autofs_i.h
@@ -35,17 +35,10 @@
 
 /* #define DEBUG */
 
-#define DPRINTK(fmt, ...)				\
-	pr_debug(KBUILD_MODNAME ":pid:%d:%s: " fmt,	\
-		current->pid, __func__, ##__VA_ARGS__)
-
-#define AUTOFS_WARN(fmt, ...)				\
-	pr_warn(KBUILD_MODNAME ":pid:%d:%s: " fmt,	\
-		current->pid, __func__, ##__VA_ARGS__)
-
-#define AUTOFS_ERROR(fmt, ...)				\
-	pr_err(KBUILD_MODNAME ":pid:%d:%s: " fmt,	\
-		current->pid, __func__, ##__VA_ARGS__)
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+#define pr_fmt(fmt) KBUILD_MODNAME ":pid:%d:%s: " fmt, current->pid, __func__
 
 /*
  * Unified info structure.  This is pointed to by both the dentry and
diff -puN fs/autofs4/dev-ioctl.c~autofs4-use-pr_xxx-macros-directly-for-logging fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-use-pr_xxx-macros-directly-for-logging
+++ a/fs/autofs4/dev-ioctl.c
@@ -74,11 +74,11 @@ static int check_dev_ioctl_version(int c
 
 	if ((param->ver_major != AUTOFS_DEV_IOCTL_VERSION_MAJOR) ||
 	    (param->ver_minor > AUTOFS_DEV_IOCTL_VERSION_MINOR)) {
-		AUTOFS_WARN("ioctl control interface version mismatch: "
-		     "kernel(%u.%u), user(%u.%u), cmd(%d)\n",
-		     AUTOFS_DEV_IOCTL_VERSION_MAJOR,
-		     AUTOFS_DEV_IOCTL_VERSION_MINOR,
-		     param->ver_major, param->ver_minor, cmd);
+		pr_warn("ioctl control interface version mismatch: "
+			"kernel(%u.%u), user(%u.%u), cmd(%d)\n",
+			AUTOFS_DEV_IOCTL_VERSION_MAJOR,
+			AUTOFS_DEV_IOCTL_VERSION_MINOR,
+			param->ver_major, param->ver_minor, cmd);
 		err = -EINVAL;
 	}
 
@@ -129,15 +129,15 @@ static int validate_dev_ioctl(int cmd, s
 
 	err = check_dev_ioctl_version(cmd, param);
 	if (err) {
-		AUTOFS_WARN("invalid device control module version "
-		     "supplied for cmd(0x%08x)\n", cmd);
+		pr_warn("invalid device control module version "
+			"supplied for cmd(0x%08x)\n", cmd);
 		goto out;
 	}
 
 	if (param->size > sizeof(*param)) {
 		err = invalid_str(param->path, param->size - sizeof(*param));
 		if (err) {
-			AUTOFS_WARN(
+			pr_warn(
 			  "path string terminator missing for cmd(0x%08x)\n",
 			  cmd);
 			goto out;
@@ -145,8 +145,8 @@ static int validate_dev_ioctl(int cmd, s
 
 		err = check_name(param->path);
 		if (err) {
-			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)\n",
-				    cmd);
+			pr_warn("invalid path supplied for cmd(0x%08x)\n",
+				cmd);
 			goto out;
 		}
 	}
@@ -373,7 +373,7 @@ static int autofs_dev_ioctl_setpipefd(st
 		new_pid = get_task_pid(current, PIDTYPE_PGID);
 
 		if (ns_of_pid(new_pid) != ns_of_pid(sbi->oz_pgrp)) {
-			AUTOFS_WARN("not allowed to change PID namespace\n");
+			pr_warn("not allowed to change PID namespace\n");
 			err = -EINVAL;
 			goto out;
 		}
@@ -661,7 +661,7 @@ static int _autofs_dev_ioctl(unsigned in
 
 	fn = lookup_dev_ioctl(cmd);
 	if (!fn) {
-		AUTOFS_WARN("unknown command 0x%08x\n", command);
+		pr_warn("unknown command 0x%08x\n", command);
 		return -ENOTTY;
 	}
 
@@ -754,7 +754,7 @@ int __init autofs_dev_ioctl_init(void)
 
 	r = misc_register(&_autofs_dev_ioctl_misc);
 	if (r) {
-		AUTOFS_ERROR("misc_register failed for control device\n");
+		pr_err("misc_register failed for control device\n");
 		return r;
 	}
 
diff -puN fs/autofs4/expire.c~autofs4-use-pr_xxx-macros-directly-for-logging fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-use-pr_xxx-macros-directly-for-logging
+++ a/fs/autofs4/expire.c
@@ -37,7 +37,7 @@ static int autofs4_mount_busy(struct vfs
 	struct path path = {.mnt = mnt, .dentry = dentry};
 	int status = 1;
 
-	DPRINTK("dentry %p %pd\n", dentry, dentry);
+	pr_debug("dentry %p %pd\n", dentry, dentry);
 
 	path_get(&path);
 
@@ -63,7 +63,7 @@ static int autofs4_mount_busy(struct vfs
 
 	status = 0;
 done:
-	DPRINTK("returning = %d\n", status);
+	pr_debug("returning = %d\n", status);
 	path_put(&path);
 	return status;
 }
@@ -189,7 +189,7 @@ static int autofs4_direct_busy(struct vf
 			       unsigned long timeout,
 			       int do_now)
 {
-	DPRINTK("top %p %pd\n", top, top);
+	pr_debug("top %p %pd\n", top, top);
 
 	/* If it's busy update the expiry counters */
 	if (!may_umount_tree(mnt)) {
@@ -220,7 +220,7 @@ static int autofs4_tree_busy(struct vfsm
 	struct autofs_info *top_ino = autofs4_dentry_ino(top);
 	struct dentry *p;
 
-	DPRINTK("top %p %pd\n", top, top);
+	pr_debug("top %p %pd\n", top, top);
 
 	/* Negative dentry - give up */
 	if (!simple_positive(top))
@@ -228,7 +228,7 @@ static int autofs4_tree_busy(struct vfsm
 
 	p = NULL;
 	while ((p = get_next_positive_dentry(p, top))) {
-		DPRINTK("dentry %p %pd\n", p, p);
+		pr_debug("dentry %p %pd\n", p, p);
 
 		/*
 		 * Is someone visiting anywhere in the subtree ?
@@ -274,11 +274,11 @@ static struct dentry *autofs4_check_leav
 {
 	struct dentry *p;
 
-	DPRINTK("parent %p %pd\n", parent, parent);
+	pr_debug("parent %p %pd\n", parent, parent);
 
 	p = NULL;
 	while ((p = get_next_positive_dentry(p, parent))) {
-		DPRINTK("dentry %p %pd\n", p, p);
+		pr_debug("dentry %p %pd\n", p, p);
 
 		if (d_mountpoint(p)) {
 			/* Can we umount this guy */
@@ -363,7 +363,7 @@ static struct dentry *should_expire(stru
 	 *	   offset (autofs-5.0+).
 	 */
 	if (d_mountpoint(dentry)) {
-		DPRINTK("checking mountpoint %p %pd\n", dentry, dentry);
+		pr_debug("checking mountpoint %p %pd\n", dentry, dentry);
 
 		/* Can we umount this guy */
 		if (autofs4_mount_busy(mnt, dentry))
@@ -376,7 +376,7 @@ static struct dentry *should_expire(stru
 	}
 
 	if (d_really_is_positive(dentry) && d_is_symlink(dentry)) {
-		DPRINTK("checking symlink %p %pd\n", dentry, dentry);
+		pr_debug("checking symlink %p %pd\n", dentry, dentry);
 		/*
 		 * A symlink can't be "busy" in the usual sense so
 		 * just check last used for expire timeout.
@@ -473,7 +473,7 @@ struct dentry *autofs4_expire_indirect(s
 	return NULL;
 
 found:
-	DPRINTK("returning %p %pd\n", expired, expired);
+	pr_debug("returning %p %pd\n", expired, expired);
 	ino->flags |= AUTOFS_INF_EXPIRING;
 	smp_mb();
 	ino->flags &= ~AUTOFS_INF_NO_RCU;
@@ -505,12 +505,12 @@ int autofs4_expire_wait(struct dentry *d
 	if (ino->flags & AUTOFS_INF_EXPIRING) {
 		spin_unlock(&sbi->fs_lock);
 
-		DPRINTK("waiting for expire %p name=%pd\n", dentry, dentry);
+		pr_debug("waiting for expire %p name=%pd\n", dentry, dentry);
 
 		status = autofs4_wait(sbi, dentry, NFY_NONE);
 		wait_for_completion(&ino->expire_complete);
 
-		DPRINTK("expire done status=%d\n", status);
+		pr_debug("expire done status=%d\n", status);
 
 		if (d_unhashed(dentry))
 			return -EAGAIN;
diff -puN fs/autofs4/inode.c~autofs4-use-pr_xxx-macros-directly-for-logging fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-use-pr_xxx-macros-directly-for-logging
+++ a/fs/autofs4/inode.c
@@ -60,7 +60,7 @@ void autofs4_kill_sb(struct super_block
 		put_pid(sbi->oz_pgrp);
 	}
 
-	DPRINTK("shutting down\n");
+	pr_debug("shutting down\n");
 	kill_litter_super(sb);
 	if (sbi)
 		kfree_rcu(sbi, rcu);
@@ -221,7 +221,7 @@ int autofs4_fill_super(struct super_bloc
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
-	DPRINTK("starting up, sbi = %p\n", sbi);
+	pr_debug("starting up, sbi = %p\n", sbi);
 
 	s->s_fs_info = sbi;
 	sbi->magic = AUTOFS_SBI_MAGIC;
@@ -270,14 +270,14 @@ int autofs4_fill_super(struct super_bloc
 	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
 			  &pgrp, &pgrp_set, &sbi->type, &sbi->min_proto,
 			  &sbi->max_proto)) {
-		AUTOFS_ERROR("called with bogus options\n");
+		pr_err("called with bogus options\n");
 		goto fail_dput;
 	}
 
 	if (pgrp_set) {
 		sbi->oz_pgrp = find_get_pid(pgrp);
 		if (!sbi->oz_pgrp) {
-			AUTOFS_ERROR("could not find process group %d\n",
+			pr_err("could not find process group %d\n",
 				pgrp);
 			goto fail_dput;
 		}
@@ -294,10 +294,10 @@ int autofs4_fill_super(struct super_bloc
 	/* Couldn't this be tested earlier? */
 	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
 	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
-		AUTOFS_ERROR("kernel does not match daemon version "
-			     "daemon (%d, %d) kernel (%d, %d)\n",
-			sbi->min_proto, sbi->max_proto,
-			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
+		pr_err("kernel does not match daemon version "
+		       "daemon (%d, %d) kernel (%d, %d)\n",
+		       sbi->min_proto, sbi->max_proto,
+		       AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
 		goto fail_dput;
 	}
 
@@ -308,11 +308,11 @@ int autofs4_fill_super(struct super_bloc
 		sbi->version = sbi->max_proto;
 	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
 
-	DPRINTK("pipe fd = %d, pgrp = %u\n", pipefd, pid_nr(sbi->oz_pgrp));
+	pr_debug("pipe fd = %d, pgrp = %u\n", pipefd, pid_nr(sbi->oz_pgrp));
 	pipe = fget(pipefd);
 
 	if (!pipe) {
-		AUTOFS_ERROR("could not open pipe file descriptor\n");
+		pr_err("could not open pipe file descriptor\n");
 		goto fail_dput;
 	}
 	ret = autofs_prepare_pipe(pipe);
@@ -332,7 +332,7 @@ int autofs4_fill_super(struct super_bloc
 	 * Failure ... clean up.
 	 */
 fail_fput:
-	AUTOFS_ERROR("pipe file descriptor does not contain proper ops\n");
+	pr_err("pipe file descriptor does not contain proper ops\n");
 	fput(pipe);
 	/* fall through */
 fail_dput:
diff -puN fs/autofs4/root.c~autofs4-use-pr_xxx-macros-directly-for-logging fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-use-pr_xxx-macros-directly-for-logging
+++ a/fs/autofs4/root.c
@@ -108,7 +108,7 @@ static int autofs4_dir_open(struct inode
 	struct dentry *dentry = file->f_path.dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 
-	DPRINTK("file=%p dentry=%p %pd\n", file, dentry, dentry);
+	pr_debug("file=%p dentry=%p %pd\n", file, dentry, dentry);
 
 	if (autofs4_oz_mode(sbi))
 		goto out;
@@ -138,7 +138,7 @@ static void autofs4_dentry_release(struc
 	struct autofs_info *ino = autofs4_dentry_ino(de);
 	struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
 
-	DPRINTK("releasing %p\n", de);
+	pr_debug("releasing %p\n", de);
 
 	if (!ino)
 		return;
@@ -278,9 +278,9 @@ static int autofs4_mount_wait(struct den
 	if (ino->flags & AUTOFS_INF_PENDING) {
 		if (rcu_walk)
 			return -ECHILD;
-		DPRINTK("waiting for mount name=%pd\n", dentry);
+		pr_debug("waiting for mount name=%pd\n", dentry);
 		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
-		DPRINTK("mount wait done status=%d\n", status);
+		pr_debug("mount wait done status=%d\n", status);
 	}
 	ino->last_used = jiffies;
 	return status;
@@ -340,7 +340,7 @@ static struct vfsmount *autofs4_d_automo
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int status;
 
-	DPRINTK("dentry=%p %pd\n", dentry, dentry);
+	pr_debug("dentry=%p %pd\n", dentry, dentry);
 
 	/* The daemon never triggers a mount. */
 	if (autofs4_oz_mode(sbi))
@@ -427,7 +427,7 @@ static int autofs4_d_manage(struct dentr
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int status;
 
-	DPRINTK("dentry=%p %pd\n", dentry, dentry);
+	pr_debug("dentry=%p %pd\n", dentry, dentry);
 
 	/* The daemon never waits. */
 	if (autofs4_oz_mode(sbi)) {
@@ -504,7 +504,7 @@ static struct dentry *autofs4_lookup(str
 	struct autofs_info *ino;
 	struct dentry *active;
 
-	DPRINTK("name = %pd\n", dentry);
+	pr_debug("name = %pd\n", dentry);
 
 	/* File name too long to exist */
 	if (dentry->d_name.len > NAME_MAX)
@@ -512,9 +512,9 @@ static struct dentry *autofs4_lookup(str
 
 	sbi = autofs4_sbi(dir->i_sb);
 
-	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d\n",
-		current->pid, task_pgrp_nr(current), sbi->catatonic,
-		autofs4_oz_mode(sbi));
+	pr_debug("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d\n",
+		 current->pid, task_pgrp_nr(current), sbi->catatonic,
+		 autofs4_oz_mode(sbi));
 
 	active = autofs4_lookup_active(dentry);
 	if (active)
@@ -559,7 +559,7 @@ static int autofs4_dir_symlink(struct in
 	size_t size = strlen(symname);
 	char *cp;
 
-	DPRINTK("%s <- %pd\n", symname, dentry);
+	pr_debug("%s <- %pd\n", symname, dentry);
 
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
@@ -699,7 +699,7 @@ static int autofs4_dir_rmdir(struct inod
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 
-	DPRINTK("dentry %p, removing %pd\n", dentry, dentry);
+	pr_debug("dentry %p, removing %pd\n", dentry, dentry);
 
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
@@ -742,7 +742,7 @@ static int autofs4_dir_mkdir(struct inod
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
 
-	DPRINTK("dentry %p, creating %pd\n", dentry, dentry);
+	pr_debug("dentry %p, creating %pd\n", dentry, dentry);
 
 	BUG_ON(!ino);
 
@@ -844,7 +844,7 @@ static inline int autofs4_ask_umount(str
 	if (may_umount(mnt))
 		status = 1;
 
-	DPRINTK("returning %d\n", status);
+	pr_debug("returning %d\n", status);
 
 	status = put_user(status, p);
 
@@ -872,8 +872,8 @@ static int autofs4_root_ioctl_unlocked(s
 	struct autofs_sb_info *sbi = autofs4_sbi(inode->i_sb);
 	void __user *p = (void __user *)arg;
 
-	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u\n",
-		cmd, arg, sbi, task_pgrp_nr(current));
+	pr_debug("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u\n",
+		 cmd, arg, sbi, task_pgrp_nr(current));
 
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
diff -puN fs/autofs4/waitq.c~autofs4-use-pr_xxx-macros-directly-for-logging fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-use-pr_xxx-macros-directly-for-logging
+++ a/fs/autofs4/waitq.c
@@ -31,7 +31,7 @@ void autofs4_catatonic_mode(struct autof
 		return;
 	}
 
-	DPRINTK("entering catatonic mode\n");
+	pr_debug("entering catatonic mode\n");
 
 	sbi->catatonic = 1;
 	wq = sbi->queues;
@@ -101,9 +101,9 @@ static void autofs4_notify_daemon(struct
 	struct file *pipe = NULL;
 	size_t pktsz;
 
-	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d\n",
-		(unsigned long) wq->wait_queue_token,
-		wq->name.len, wq->name.name, type);
+	pr_debug("wait id = 0x%08lx, name = %.*s, type=%d\n",
+		 (unsigned long) wq->wait_queue_token,
+		 wq->name.len, wq->name.name, type);
 
 	memset(&pkt, 0, sizeof(pkt)); /* For security reasons */
 
@@ -164,7 +164,7 @@ static void autofs4_notify_daemon(struct
 		break;
 	}
 	default:
-		AUTOFS_WARN("bad type %d!\n", type);
+		pr_warn("bad type %d!\n", type);
 		mutex_unlock(&sbi->wq_mutex);
 		return;
 	}
@@ -453,9 +453,9 @@ int autofs4_wait(struct autofs_sb_info *
 					autofs_ptype_expire_indirect;
 		}
 
-		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
-			(unsigned long) wq->wait_queue_token, wq->name.len,
-			wq->name.name, notify);
+		pr_debug("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
+			 (unsigned long) wq->wait_queue_token, wq->name.len,
+			 wq->name.name, notify);
 
 		/*
 		 * autofs4_notify_daemon() may block; it will unlock ->wq_mutex
@@ -463,9 +463,9 @@ int autofs4_wait(struct autofs_sb_info *
 		autofs4_notify_daemon(sbi, wq, type);
 	} else {
 		wq->wait_ctr++;
-		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d\n",
-			(unsigned long) wq->wait_queue_token, wq->name.len,
-			wq->name.name, notify);
+		pr_debug("existing wait id = 0x%08lx, name = %.*s, nfy=%d\n",
+			 (unsigned long) wq->wait_queue_token, wq->name.len,
+			 wq->name.name, notify);
 		mutex_unlock(&sbi->wq_mutex);
 		kfree(qstr.name);
 	}
@@ -494,7 +494,7 @@ int autofs4_wait(struct autofs_sb_info *
 		recalc_sigpending();
 		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 	} else {
-		DPRINTK("skipped sleeping\n");
+		pr_debug("skipped sleeping\n");
 	}
 
 	status = wq->status;
_

Patches currently in -mm which might be from ikent@redhat.com are


