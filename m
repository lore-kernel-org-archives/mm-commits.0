From: akpm@linux-foundation.org
Subject: [merged] autofs4-make-autofs-log-prints-consistent.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:57:57 -0700
Message-ID: <56e9bac5.uGZCVXIaM2hA/LMs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbcCPT56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, joe@perches.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: make autofs log prints consistent
has been removed from the -mm tree.  Its filename was
     autofs4-make-autofs-log-prints-consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <ikent@redhat.com>
Subject: autofs4: make autofs log prints consistent

Use the pr_*() print in AUTOFS_*() macros instead of printks and include
the module name in log message macros.  Also use the AUTOFS_*() macros
everywhere instead of raw printks.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h  |    6 +++---
 fs/autofs4/dev-ioctl.c |    2 +-
 fs/autofs4/inode.c     |   12 ++++++------
 fs/autofs4/waitq.c     |    4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-make-autofs-log-prints-consistent fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-make-autofs-log-prints-consistent
+++ a/fs/autofs4/autofs_i.h
@@ -36,15 +36,15 @@
 /* #define DEBUG */
 
 #define DPRINTK(fmt, ...)				\
-	pr_debug("pid %d: %s: " fmt "\n",		\
+	pr_debug(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",\
 		current->pid, __func__, ##__VA_ARGS__)
 
 #define AUTOFS_WARN(fmt, ...)				\
-	printk(KERN_WARNING "pid %d: %s: " fmt "\n",	\
+	pr_warn(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",	\
 		current->pid, __func__, ##__VA_ARGS__)
 
 #define AUTOFS_ERROR(fmt, ...)				\
-	printk(KERN_ERR "pid %d: %s: " fmt "\n",	\
+	pr_err(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",	\
 		current->pid, __func__, ##__VA_ARGS__)
 
 /*
diff -puN fs/autofs4/dev-ioctl.c~autofs4-make-autofs-log-prints-consistent fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-make-autofs-log-prints-consistent
+++ a/fs/autofs4/dev-ioctl.c
@@ -373,7 +373,7 @@ static int autofs_dev_ioctl_setpipefd(st
 		new_pid = get_task_pid(current, PIDTYPE_PGID);
 
 		if (ns_of_pid(new_pid) != ns_of_pid(sbi->oz_pgrp)) {
-			AUTOFS_WARN("Not allowed to change PID namespace");
+			AUTOFS_WARN("not allowed to change PID namespace");
 			err = -EINVAL;
 			goto out;
 		}
diff -puN fs/autofs4/inode.c~autofs4-make-autofs-log-prints-consistent fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-make-autofs-log-prints-consistent
+++ a/fs/autofs4/inode.c
@@ -270,14 +270,14 @@ int autofs4_fill_super(struct super_bloc
 	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
 			  &pgrp, &pgrp_set, &sbi->type, &sbi->min_proto,
 			  &sbi->max_proto)) {
-		printk("autofs: called with bogus options\n");
+		AUTOFS_ERROR("called with bogus options");
 		goto fail_dput;
 	}
 
 	if (pgrp_set) {
 		sbi->oz_pgrp = find_get_pid(pgrp);
 		if (!sbi->oz_pgrp) {
-			pr_warn("autofs: could not find process group %d\n",
+			AUTOFS_ERROR("could not find process group %d",
 				pgrp);
 			goto fail_dput;
 		}
@@ -294,8 +294,8 @@ int autofs4_fill_super(struct super_bloc
 	/* Couldn't this be tested earlier? */
 	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
 	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
-		printk("autofs: kernel does not match daemon version "
-		       "daemon (%d, %d) kernel (%d, %d)\n",
+		AUTOFS_ERROR("kernel does not match daemon version "
+			     "daemon (%d, %d) kernel (%d, %d)",
 			sbi->min_proto, sbi->max_proto,
 			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
 		goto fail_dput;
@@ -312,7 +312,7 @@ int autofs4_fill_super(struct super_bloc
 	pipe = fget(pipefd);
 
 	if (!pipe) {
-		printk("autofs: could not open pipe file descriptor\n");
+		AUTOFS_ERROR("could not open pipe file descriptor");
 		goto fail_dput;
 	}
 	ret = autofs_prepare_pipe(pipe);
@@ -332,7 +332,7 @@ int autofs4_fill_super(struct super_bloc
 	 * Failure ... clean up.
 	 */
 fail_fput:
-	printk("autofs: pipe file descriptor does not contain proper ops\n");
+	AUTOFS_ERROR("pipe file descriptor does not contain proper ops");
 	fput(pipe);
 	/* fall through */
 fail_dput:
diff -puN fs/autofs4/waitq.c~autofs4-make-autofs-log-prints-consistent fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-make-autofs-log-prints-consistent
+++ a/fs/autofs4/waitq.c
@@ -164,7 +164,7 @@ static void autofs4_notify_daemon(struct
 		break;
 	}
 	default:
-		printk("autofs4_notify_daemon: bad type %d!\n", type);
+		AUTOFS_WARN("bad type %d!", type);
 		mutex_unlock(&sbi->wq_mutex);
 		return;
 	}
@@ -453,7 +453,7 @@ int autofs4_wait(struct autofs_sb_info *
 					autofs_ptype_expire_indirect;
 		}
 
-		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
+		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d",
 			(unsigned long) wq->wait_queue_token, wq->name.len,
 			wq->name.name, notify);
 
_

Patches currently in -mm which might be from ikent@redhat.com are


