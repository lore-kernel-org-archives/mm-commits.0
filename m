From: akpm@linux-foundation.org
Subject: + devpts-parse-mount-options-just-once-and-copy-them-to-super-block.patch added to -mm tree
Date: Mon, 09 Mar 2009 13:05:27 -0700
Message-ID: <200903092005.n29K5RDR001093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbZCIUGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 16:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, hpa@zytor.com, serue@us.ibm.com


The patch titled
     devpts: parse mount options just once and copy them to super block
has been added to the -mm tree.  Its filename is
     devpts-parse-mount-options-just-once-and-copy-them-to-super-block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: parse mount options just once and copy them to super block
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Since all the mount option parsing is done in devpts, we could do it just
once and pass it around in devpts functions and eventually store it in the
super block.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |  100 +++++++++-----------------------------------
 1 file changed, 22 insertions(+), 78 deletions(-)

diff -puN fs/devpts/inode.c~devpts-parse-mount-options-just-once-and-copy-them-to-super-block fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-parse-mount-options-just-once-and-copy-them-to-super-block
+++ a/fs/devpts/inode.c
@@ -322,60 +322,21 @@ static int compare_init_pts_sb(struct su
 }
 
 /*
- * Safely parse the mount options in @data and update @opts.
- *
- * devpts ends up parsing options two times during mount, due to the
- * two modes of operation it supports. The first parse occurs in
- * devpts_get_sb() when determining the mode (single-instance or
- * multi-instance mode). The second parse happens in devpts_remount()
- * or new_pts_mount() depending on the mode.
- *
- * Parsing of options modifies the @data making subsequent parsing
- * incorrect. So make a local copy of @data and parse it.
- *
- * Return: 0 On success, -errno on error
- */
-static int safe_parse_mount_options(void *data, struct pts_mount_opts *opts)
-{
-	int rc;
-	void *datacp;
-
-	if (!data)
-		return 0;
-
-	/* Use kstrdup() ?  */
-	datacp = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!datacp)
-		return -ENOMEM;
-
-	memcpy(datacp, data, PAGE_SIZE);
-	rc = parse_mount_options((char *)datacp, PARSE_MOUNT, opts);
-	kfree(datacp);
-
-	return rc;
-}
-
-/*
  * Mount a new (private) instance of devpts.  PTYs created in this
  * instance are independent of the PTYs in other devpts instances.
  */
 static int new_pts_mount(struct file_system_type *fs_type, int flags,
-		void *data, struct vfsmount *mnt)
+		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
 {
 	int err;
 	struct pts_fs_info *fsi;
-	struct pts_mount_opts *opts;
 
 	err = get_sb_nodev(fs_type, flags, data, devpts_fill_super, mnt);
 	if (err)
 		return err;
 
 	fsi = DEVPTS_SB(mnt->mnt_sb);
-	opts = &fsi->mount_opts;
-
-	err = parse_mount_options(data, PARSE_MOUNT, opts);
-	if (err)
-		goto fail;
+	memcpy(&fsi->mount_opts, opts, sizeof(opts));
 
 	err = mknod_ptmx(mnt->mnt_sb);
 	if (err)
@@ -391,28 +352,6 @@ fail:
 }
 
 /*
- * Check if 'newinstance' mount option was specified in @data.
- *
- * Return: -errno  	on error (eg: invalid mount options specified)
- * 	 : 1 		if 'newinstance' mount option was specified
- * 	 : 0 		if 'newinstance' mount option was NOT specified
- */
-static int is_new_instance_mount(void *data)
-{
-	int rc;
-	struct pts_mount_opts opts;
-
-	if (!data)
-		return 0;
-
-	rc = safe_parse_mount_options(data, &opts);
-	if (!rc)
-		rc = opts.newinstance;
-
-	return rc;
-}
-
-/*
  * get_init_pts_sb()
  *
  *     This interface is needed to support multiple namespace semantics in
@@ -434,10 +373,9 @@ static int is_new_instance_mount(void *d
  *     presence of the private namespace (i.e 'newinstance') super-blocks.
  */
 static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
-		void *data, struct vfsmount *mnt)
+		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
 {
 	struct super_block *s;
-	struct pts_mount_opts *opts;
 	struct pts_fs_info *fsi;
 	int error;
 
@@ -455,11 +393,12 @@ static int get_init_pts_sb(struct file_s
 		}
 		s->s_flags |= MS_ACTIVE;
 	}
-	fsi = DEVPTS_SB(s);
-	opts = &fsi->mount_opts;
-	parse_mount_options(data, PARSE_REMOUNT, opts);
 
 	simple_set_mnt(mnt, s);
+
+	fsi = DEVPTS_SB(mnt->mnt_sb);
+	memcpy(&fsi->mount_opts, opts, sizeof(opts));
+
 	return 0;
 }
 
@@ -469,11 +408,11 @@ static int get_init_pts_sb(struct file_s
  * kernel still allows multiple-instances.
  */
 static int init_pts_mount(struct file_system_type *fs_type, int flags,
-		void *data, struct vfsmount *mnt)
+		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
 {
 	int err;
 
-	err = get_init_pts_sb(fs_type, flags, data, mnt);
+	err = get_init_pts_sb(fs_type, flags, data, opts, mnt);
 	if (err)
 		return err;
 
@@ -490,17 +429,22 @@ static int init_pts_mount(struct file_sy
 static int devpts_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	int new;
-
-	new = is_new_instance_mount(data);
-	if (new < 0)
-		return new;
+	int error;
+	struct pts_mount_opts opts;
 
-	if (new)
-		return new_pts_mount(fs_type, flags, data, mnt);
+	memset(&opts, 0, sizeof(opts));
+	if (data) {
+		error = parse_mount_options(data, PARSE_MOUNT, &opts);
+		if (error)
+			return error;
+	}
 
-	return init_pts_mount(fs_type, flags, data, mnt);
+	if (opts.newinstance)
+		return new_pts_mount(fs_type, flags, data, &opts, mnt);
+	else
+		return init_pts_mount(fs_type, flags, data, &opts, mnt);
 }
+
 #else
 /*
  * This supports only the legacy single-instance semantics (no
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

linux-next.patch
vfs-simple_set_mnt-should-return-void.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-protect-init-from-unwanted-signals-more.patch
signals-add-from_ancestor_ns-parameter-to-send_signal.patch
signals-protect-cinit-from-unblocked-sig_dfl-signals.patch
signals-zap_pid_ns_process-should-use-force_sig.patch
signals-protect-cinit-from-blocked-fatal-signals.patch
signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch
devpts-unroll-essentials-of-do_remount_sb-into-devpts.patch
devpts-parse-mount-options-just-once-and-copy-them-to-super-block.patch
devpts-move-common-mknod_ptmx-calls-into-caller.patch
devpts-remove-get_init_pts_sb.patch
devpts-merge-code-for-single-and-multiple-instance-mounts.patch

