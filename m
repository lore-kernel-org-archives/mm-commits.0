From: akpm@linux-foundation.org
Subject: + autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch added to -mm tree
Date: Thu, 09 May 2013 11:09:03 -0700
Message-ID: <20130509180903.EE4A331C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:36815 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3EISJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 14:09:05 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so316048vbg.4
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 11:09:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, ebiederm@xmission.com, mszeredi@suse.cz, oleg@redhat.com, raven@themaw.net, serge.hallyn@canonical.com


The patch titled
     Subject: autofs4: allow autofs to work outside the initial PID namespace
has been added to the -mm tree.  Its filename is
     autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: autofs4: allow autofs to work outside the initial PID namespace

Enable autofs4 to work in a "container".  oz_pgrp is converted from pid_t
to struct pid and this is stored at mount time based on the "pgrp=" option
or if the option is missing then the current pgrp.

The "pgrp=" option is interpreted in the PID namespace of the current
process.  This option is flawed in that it doesn't carry the namespace
information, so it should be deprecated.  AFAICS the autofs daemon always
sends the current pgrp, which is the default anyway.

The oz_pgrp is also set from the AUTOFS_DEV_IOCTL_SETPIPEFD_CMD ioctl. 
This ioctl sets oz_pgrp to the current pgrp.  It is not allowed to change
the pid namespace.

oz_pgrp is used mainly to determine whether the process traversing the
autofs mount tree is the autofs daemon itself or not.  This function now
compares the pid pointers instead of the pid_t values.

One other use of oz_pgrp is in autofs4_show_options.  There is shows the
virtual pid number (i.e.  the one that is valid inside the PID namespace
of the calling process)

For debugging printk convert oz_pgrp to the value in the initial pid
namespace.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Ian Kent <raven@themaw.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h  |    4 ++--
 fs/autofs4/dev-ioctl.c |   16 ++++++++++++++--
 fs/autofs4/inode.c     |   33 +++++++++++++++++++++++++--------
 3 files changed, 41 insertions(+), 12 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace
+++ a/fs/autofs4/autofs_i.h
@@ -104,7 +104,7 @@ struct autofs_sb_info {
 	u32 magic;
 	int pipefd;
 	struct file *pipe;
-	pid_t oz_pgrp;
+	struct pid *oz_pgrp;
 	int catatonic;
 	int version;
 	int sub_version;
@@ -139,7 +139,7 @@ static inline struct autofs_info *autofs
    filesystem without "magic".) */
 
 static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
-	return sbi->catatonic || task_pgrp_nr(current) == sbi->oz_pgrp;
+	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
 /* Does a dentry have some pending activity? */
diff -puN fs/autofs4/dev-ioctl.c~autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace
+++ a/fs/autofs4/dev-ioctl.c
@@ -346,6 +346,7 @@ static int autofs_dev_ioctl_setpipefd(st
 {
 	int pipefd;
 	int err = 0;
+	struct pid *new_pid = NULL;
 
 	if (param->setpipefd.pipefd == -1)
 		return -EINVAL;
@@ -357,7 +358,17 @@ static int autofs_dev_ioctl_setpipefd(st
 		mutex_unlock(&sbi->wq_mutex);
 		return -EBUSY;
 	} else {
-		struct file *pipe = fget(pipefd);
+		struct file *pipe;
+
+		new_pid = get_task_pid(current, PIDTYPE_PGID);
+
+		if (ns_of_pid(new_pid) != ns_of_pid(sbi->oz_pgrp)) {
+			AUTOFS_WARN("Not allowed to change PID namespace");
+			err = -EINVAL;
+			goto out;
+		}
+
+		pipe = fget(pipefd);
 		if (!pipe) {
 			err = -EBADF;
 			goto out;
@@ -367,12 +378,13 @@ static int autofs_dev_ioctl_setpipefd(st
 			fput(pipe);
 			goto out;
 		}
-		sbi->oz_pgrp = task_pgrp_nr(current);
+		swap(sbi->oz_pgrp, new_pid);
 		sbi->pipefd = pipefd;
 		sbi->pipe = pipe;
 		sbi->catatonic = 0;
 	}
 out:
+	put_pid(new_pid);
 	mutex_unlock(&sbi->wq_mutex);
 	return err;
 }
diff -puN fs/autofs4/inode.c~autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace
+++ a/fs/autofs4/inode.c
@@ -62,6 +62,8 @@ void autofs4_kill_sb(struct super_block
 	/* Free wait queues, close pipe */
 	autofs4_catatonic_mode(sbi);
 
+	put_pid(sbi->oz_pgrp);
+
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 
@@ -85,7 +87,7 @@ static int autofs4_show_options(struct s
 	if (!gid_eq(root_inode->i_gid, GLOBAL_ROOT_GID))
 		seq_printf(m, ",gid=%u",
 			from_kgid_munged(&init_user_ns, root_inode->i_gid));
-	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
+	seq_printf(m, ",pgrp=%d", pid_vnr(sbi->oz_pgrp));
 	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
 	seq_printf(m, ",minproto=%d", sbi->min_proto);
 	seq_printf(m, ",maxproto=%d", sbi->max_proto);
@@ -129,7 +131,8 @@ static const match_table_t tokens = {
 };
 
 static int parse_options(char *options, int *pipefd, kuid_t *uid, kgid_t *gid,
-		pid_t *pgrp, unsigned int *type, int *minproto, int *maxproto)
+			 int *pgrp, bool *pgrp_set, unsigned int *type,
+			 int *minproto, int *maxproto)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
@@ -137,7 +140,6 @@ static int parse_options(char *options,
 
 	*uid = current_uid();
 	*gid = current_gid();
-	*pgrp = task_pgrp_nr(current);
 
 	*minproto = AUTOFS_MIN_PROTO_VERSION;
 	*maxproto = AUTOFS_MAX_PROTO_VERSION;
@@ -176,6 +178,7 @@ static int parse_options(char *options,
 			if (match_int(args, &option))
 				return 1;
 			*pgrp = option;
+			*pgrp_set = true;
 			break;
 		case Opt_minproto:
 			if (match_int(args, &option))
@@ -211,6 +214,8 @@ int autofs4_fill_super(struct super_bloc
 	int pipefd;
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
+	int pgrp;
+	bool pgrp_set = false;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -223,7 +228,7 @@ int autofs4_fill_super(struct super_bloc
 	sbi->pipe = NULL;
 	sbi->catatonic = 1;
 	sbi->exp_timeout = 0;
-	sbi->oz_pgrp = task_pgrp_nr(current);
+	sbi->oz_pgrp = NULL;
 	sbi->sb = s;
 	sbi->version = 0;
 	sbi->sub_version = 0;
@@ -260,12 +265,23 @@ int autofs4_fill_super(struct super_bloc
 
 	/* Can this call block? */
 	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
-				&sbi->oz_pgrp, &sbi->type, &sbi->min_proto,
-				&sbi->max_proto)) {
+			  &pgrp, &pgrp_set, &sbi->type, &sbi->min_proto,
+			  &sbi->max_proto)) {
 		printk("autofs: called with bogus options\n");
 		goto fail_dput;
 	}
 
+	if (pgrp_set) {
+		sbi->oz_pgrp = find_get_pid(pgrp);
+		if (!sbi->oz_pgrp) {
+			pr_warn("autofs: could not find process group %d\n",
+				pgrp);
+			goto fail_dput;
+		}
+	} else {
+		sbi->oz_pgrp = get_task_pid(current, PIDTYPE_PGID);
+	}
+
 	if (autofs_type_trigger(sbi->type))
 		__managed_dentry_set_managed(root);
 
@@ -289,9 +305,9 @@ int autofs4_fill_super(struct super_bloc
 		sbi->version = sbi->max_proto;
 	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
 
-	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, sbi->oz_pgrp);
+	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, pid_nr(sbi->oz_pgrp));
 	pipe = fget(pipefd);
-	
+
 	if (!pipe) {
 		printk("autofs: could not open pipe file descriptor\n");
 		goto fail_dput;
@@ -321,6 +337,7 @@ fail_dput:
 fail_ino:
 	kfree(ino);
 fail_free:
+	put_pid(sbi->oz_pgrp);
 	kfree(sbi);
 	s->s_fs_info = NULL;
 fail_unlock:
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch

