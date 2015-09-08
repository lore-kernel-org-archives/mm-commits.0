From: akpm@linux-foundation.org
Subject: [merged] fs-create-and-use-seq_show_option-for-escaping.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:54 -0700
Message-ID: <55ef22ce.N1HT2n/7fgj8bUtw%akpm__12324.5847331875$1441735410$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, hooanon05g@gmail.com, jack@suse.com, paul@paul-moore.com, serge.hallyn@canonical.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: create and use seq_show_option for escaping
has been removed from the -mm tree.  Its filename was
     fs-create-and-use-seq_show_option-for-escaping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs: create and use seq_show_option for escaping

Many file systems that implement the show_options hook fail to correctly
escape their output which could lead to unescaped characters (e.g.  new
lines) leaking into /proc/mounts and /proc/[pid]/mountinfo files.  This
could lead to confusion, spoofed entries (resulting in things like systemd
issuing false d-bus "mount" notifications), and who knows what else.  This
looks like it would only be the root user stepping on themselves, but it's
possible weird things could happen in containers or in other situations
with delegated mount privileges.

Here's an example using overlay with setuid fusermount trusting the
contents of /proc/mounts (via the /etc/mtab symlink).  Imagine the use of
"sudo" is something more sneaky:

$ BASE="ovl"
$ MNT="$BASE/mnt"
$ LOW="$BASE/lower"
$ UP="$BASE/upper"
$ WORK="$BASE/work/ 0 0
none /proc fuse.pwn user_id=1000"
$ mkdir -p "$LOW" "$UP" "$WORK"
$ sudo mount -t overlay -o "lowerdir=$LOW,upperdir=$UP,workdir=$WORK" none /mnt
$ cat /proc/mounts
none /root/ovl/mnt overlay rw,relatime,lowerdir=ovl/lower,upperdir=ovl/upper,workdir=ovl/work/ 0 0
none /proc fuse.pwn user_id=1000 0 0
$ fusermount -u /proc
$ cat /proc/mounts
cat: /proc/mounts: No such file or directory

This fixes the problem by adding new seq_show_option and seq_show_option_n
helpers, and updating the vulnerable show_option handlers to use them as
needed.  Some, like SELinux, need to be open coded due to unusual existing
escape mechanisms.

[akpm@linux-foundation.org: add lost chunk, per Kees]
[keescook@chromium.org: seq_show_option should be using const parameters]
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: Jan Kara <jack@suse.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Cc: J. R. Okajima <hooanon05g@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/super.c          |    2 +-
 fs/cifs/cifsfs.c         |    6 +++---
 fs/ext4/super.c          |    4 ++--
 fs/gfs2/super.c          |    6 +++---
 fs/hfs/super.c           |    4 ++--
 fs/hfsplus/options.c     |    4 ++--
 fs/hostfs/hostfs_kern.c  |    2 +-
 fs/ocfs2/super.c         |    4 ++--
 fs/overlayfs/super.c     |    6 +++---
 fs/reiserfs/super.c      |    8 +++++---
 fs/xfs/xfs_super.c       |    4 ++--
 include/linux/seq_file.h |   35 +++++++++++++++++++++++++++++++++++
 kernel/cgroup.c          |    7 ++++---
 net/ceph/ceph_common.c   |    7 +++++--
 security/selinux/hooks.c |    2 +-
 15 files changed, 71 insertions(+), 30 deletions(-)

diff -puN fs/ceph/super.c~fs-create-and-use-seq_show_option-for-escaping fs/ceph/super.c
--- a/fs/ceph/super.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/ceph/super.c
@@ -479,7 +479,7 @@ static int ceph_show_options(struct seq_
 	if (fsopt->max_readdir_bytes != CEPH_MAX_READDIR_BYTES_DEFAULT)
 		seq_printf(m, ",readdir_max_bytes=%d", fsopt->max_readdir_bytes);
 	if (strcmp(fsopt->snapdir_name, CEPH_SNAPDIRNAME_DEFAULT))
-		seq_printf(m, ",snapdirname=%s", fsopt->snapdir_name);
+		seq_show_option(m, "snapdirname", fsopt->snapdir_name);
 
 	return 0;
 }
diff -puN fs/cifs/cifsfs.c~fs-create-and-use-seq_show_option-for-escaping fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/cifs/cifsfs.c
@@ -394,17 +394,17 @@ cifs_show_options(struct seq_file *s, st
 	struct sockaddr *srcaddr;
 	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
 
-	seq_printf(s, ",vers=%s", tcon->ses->server->vals->version_string);
+	seq_show_option(s, "vers", tcon->ses->server->vals->version_string);
 	cifs_show_security(s, tcon->ses);
 	cifs_show_cache_flavor(s, cifs_sb);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
 		seq_puts(s, ",multiuser");
 	else if (tcon->ses->user_name)
-		seq_printf(s, ",username=%s", tcon->ses->user_name);
+		seq_show_option(s, "username", tcon->ses->user_name);
 
 	if (tcon->ses->domainName)
-		seq_printf(s, ",domain=%s", tcon->ses->domainName);
+		seq_show_option(s, "domain", tcon->ses->domainName);
 
 	if (srcaddr->sa_family != AF_UNSPEC) {
 		struct sockaddr_in *saddr4;
diff -puN fs/ext4/super.c~fs-create-and-use-seq_show_option-for-escaping fs/ext4/super.c
--- a/fs/ext4/super.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/ext4/super.c
@@ -1776,10 +1776,10 @@ static inline void ext4_show_quota_optio
 	}
 
 	if (sbi->s_qf_names[USRQUOTA])
-		seq_printf(seq, ",usrjquota=%s", sbi->s_qf_names[USRQUOTA]);
+		seq_show_option(seq, "usrjquota", sbi->s_qf_names[USRQUOTA]);
 
 	if (sbi->s_qf_names[GRPQUOTA])
-		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
+		seq_show_option(seq, "grpjquota", sbi->s_qf_names[GRPQUOTA]);
 #endif
 }
 
diff -puN fs/gfs2/super.c~fs-create-and-use-seq_show_option-for-escaping fs/gfs2/super.c
--- a/fs/gfs2/super.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/gfs2/super.c
@@ -1334,11 +1334,11 @@ static int gfs2_show_options(struct seq_
 	if (is_ancestor(root, sdp->sd_master_dir))
 		seq_puts(s, ",meta");
 	if (args->ar_lockproto[0])
-		seq_printf(s, ",lockproto=%s", args->ar_lockproto);
+		seq_show_option(s, "lockproto", args->ar_lockproto);
 	if (args->ar_locktable[0])
-		seq_printf(s, ",locktable=%s", args->ar_locktable);
+		seq_show_option(s, "locktable", args->ar_locktable);
 	if (args->ar_hostdata[0])
-		seq_printf(s, ",hostdata=%s", args->ar_hostdata);
+		seq_show_option(s, "hostdata", args->ar_hostdata);
 	if (args->ar_spectator)
 		seq_puts(s, ",spectator");
 	if (args->ar_localflocks)
diff -puN fs/hfs/super.c~fs-create-and-use-seq_show_option-for-escaping fs/hfs/super.c
--- a/fs/hfs/super.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/hfs/super.c
@@ -136,9 +136,9 @@ static int hfs_show_options(struct seq_f
 	struct hfs_sb_info *sbi = HFS_SB(root->d_sb);
 
 	if (sbi->s_creator != cpu_to_be32(0x3f3f3f3f))
-		seq_printf(seq, ",creator=%.4s", (char *)&sbi->s_creator);
+		seq_show_option_n(seq, "creator", (char *)&sbi->s_creator, 4);
 	if (sbi->s_type != cpu_to_be32(0x3f3f3f3f))
-		seq_printf(seq, ",type=%.4s", (char *)&sbi->s_type);
+		seq_show_option_n(seq, "type", (char *)&sbi->s_type, 4);
 	seq_printf(seq, ",uid=%u,gid=%u",
 			from_kuid_munged(&init_user_ns, sbi->s_uid),
 			from_kgid_munged(&init_user_ns, sbi->s_gid));
diff -puN fs/hfsplus/options.c~fs-create-and-use-seq_show_option-for-escaping fs/hfsplus/options.c
--- a/fs/hfsplus/options.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/hfsplus/options.c
@@ -218,9 +218,9 @@ int hfsplus_show_options(struct seq_file
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(root->d_sb);
 
 	if (sbi->creator != HFSPLUS_DEF_CR_TYPE)
-		seq_printf(seq, ",creator=%.4s", (char *)&sbi->creator);
+		seq_show_option_n(seq, "creator", (char *)&sbi->creator, 4);
 	if (sbi->type != HFSPLUS_DEF_CR_TYPE)
-		seq_printf(seq, ",type=%.4s", (char *)&sbi->type);
+		seq_show_option_n(seq, "type", (char *)&sbi->type, 4);
 	seq_printf(seq, ",umask=%o,uid=%u,gid=%u", sbi->umask,
 			from_kuid_munged(&init_user_ns, sbi->uid),
 			from_kgid_munged(&init_user_ns, sbi->gid));
diff -puN fs/hostfs/hostfs_kern.c~fs-create-and-use-seq_show_option-for-escaping fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/hostfs/hostfs_kern.c
@@ -260,7 +260,7 @@ static int hostfs_show_options(struct se
 	size_t offset = strlen(root_ino) + 1;
 
 	if (strlen(root_path) > offset)
-		seq_printf(seq, ",%s", root_path + offset);
+		seq_show_option(seq, root_path + offset, NULL);
 
 	if (append)
 		seq_puts(seq, ",append");
diff -puN fs/ocfs2/super.c~fs-create-and-use-seq_show_option-for-escaping fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/ocfs2/super.c
@@ -1563,8 +1563,8 @@ static int ocfs2_show_options(struct seq
 		seq_printf(s, ",localflocks,");
 
 	if (osb->osb_cluster_stack[0])
-		seq_printf(s, ",cluster_stack=%.*s", OCFS2_STACK_LABEL_LEN,
-			   osb->osb_cluster_stack);
+		seq_show_option_n(s, "cluster_stack", osb->osb_cluster_stack,
+				  OCFS2_STACK_LABEL_LEN);
 	if (opts & OCFS2_MOUNT_USRQUOTA)
 		seq_printf(s, ",usrquota");
 	if (opts & OCFS2_MOUNT_GRPQUOTA)
diff -puN fs/overlayfs/super.c~fs-create-and-use-seq_show_option-for-escaping fs/overlayfs/super.c
--- a/fs/overlayfs/super.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/overlayfs/super.c
@@ -588,10 +588,10 @@ static int ovl_show_options(struct seq_f
 	struct super_block *sb = dentry->d_sb;
 	struct ovl_fs *ufs = sb->s_fs_info;
 
-	seq_printf(m, ",lowerdir=%s", ufs->config.lowerdir);
+	seq_show_option(m, "lowerdir", ufs->config.lowerdir);
 	if (ufs->config.upperdir) {
-		seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
-		seq_printf(m, ",workdir=%s", ufs->config.workdir);
+		seq_show_option(m, "upperdir", ufs->config.upperdir);
+		seq_show_option(m, "workdir", ufs->config.workdir);
 	}
 	return 0;
 }
diff -puN fs/reiserfs/super.c~fs-create-and-use-seq_show_option-for-escaping fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/reiserfs/super.c
@@ -714,18 +714,20 @@ static int reiserfs_show_options(struct
 		seq_puts(seq, ",acl");
 
 	if (REISERFS_SB(s)->s_jdev)
-		seq_printf(seq, ",jdev=%s", REISERFS_SB(s)->s_jdev);
+		seq_show_option(seq, "jdev", REISERFS_SB(s)->s_jdev);
 
 	if (journal->j_max_commit_age != journal->j_default_max_commit_age)
 		seq_printf(seq, ",commit=%d", journal->j_max_commit_age);
 
 #ifdef CONFIG_QUOTA
 	if (REISERFS_SB(s)->s_qf_names[USRQUOTA])
-		seq_printf(seq, ",usrjquota=%s", REISERFS_SB(s)->s_qf_names[USRQUOTA]);
+		seq_show_option(seq, "usrjquota",
+				REISERFS_SB(s)->s_qf_names[USRQUOTA]);
 	else if (opts & (1 << REISERFS_USRQUOTA))
 		seq_puts(seq, ",usrquota");
 	if (REISERFS_SB(s)->s_qf_names[GRPQUOTA])
-		seq_printf(seq, ",grpjquota=%s", REISERFS_SB(s)->s_qf_names[GRPQUOTA]);
+		seq_show_option(seq, "grpjquota",
+				REISERFS_SB(s)->s_qf_names[GRPQUOTA]);
 	else if (opts & (1 << REISERFS_GRPQUOTA))
 		seq_puts(seq, ",grpquota");
 	if (REISERFS_SB(s)->s_jquota_fmt) {
diff -puN fs/xfs/xfs_super.c~fs-create-and-use-seq_show_option-for-escaping fs/xfs/xfs_super.c
--- a/fs/xfs/xfs_super.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/fs/xfs/xfs_super.c
@@ -511,9 +511,9 @@ xfs_showargs(
 		seq_printf(m, "," MNTOPT_LOGBSIZE "=%dk", mp->m_logbsize >> 10);
 
 	if (mp->m_logname)
-		seq_printf(m, "," MNTOPT_LOGDEV "=%s", mp->m_logname);
+		seq_show_option(m, MNTOPT_LOGDEV, mp->m_logname);
 	if (mp->m_rtname)
-		seq_printf(m, "," MNTOPT_RTDEV "=%s", mp->m_rtname);
+		seq_show_option(m, MNTOPT_RTDEV, mp->m_rtname);
 
 	if (mp->m_dalign > 0)
 		seq_printf(m, "," MNTOPT_SUNIT "=%d",
diff -puN include/linux/seq_file.h~fs-create-and-use-seq_show_option-for-escaping include/linux/seq_file.h
--- a/include/linux/seq_file.h~fs-create-and-use-seq_show_option-for-escaping
+++ a/include/linux/seq_file.h
@@ -149,6 +149,41 @@ static inline struct user_namespace *seq
 #endif
 }
 
+/**
+ * seq_show_options - display mount options with appropriate escapes.
+ * @m: the seq_file handle
+ * @name: the mount option name
+ * @value: the mount option name's value, can be NULL
+ */
+static inline void seq_show_option(struct seq_file *m, const char *name,
+				   const char *value)
+{
+	seq_putc(m, ',');
+	seq_escape(m, name, ",= \t\n\\");
+	if (value) {
+		seq_putc(m, '=');
+		seq_escape(m, value, ", \t\n\\");
+	}
+}
+
+/**
+ * seq_show_option_n - display mount options with appropriate escapes
+ *		       where @value must be a specific length.
+ * @m: the seq_file handle
+ * @name: the mount option name
+ * @value: the mount option name's value, cannot be NULL
+ * @length: the length of @value to display
+ *
+ * This is a macro since this uses "length" to define the size of the
+ * stack buffer.
+ */
+#define seq_show_option_n(m, name, value, length) {	\
+	char val_buf[length + 1];			\
+	strncpy(val_buf, value, length);		\
+	val_buf[length] = '\0';				\
+	seq_show_option(m, name, val_buf);		\
+}
+
 #define SEQ_START_TOKEN ((void *)1)
 /*
  * Helpers for iteration over list_head-s in seq_files
diff -puN kernel/cgroup.c~fs-create-and-use-seq_show_option-for-escaping kernel/cgroup.c
--- a/kernel/cgroup.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/kernel/cgroup.c
@@ -1342,7 +1342,7 @@ static int cgroup_show_options(struct se
 	if (root != &cgrp_dfl_root)
 		for_each_subsys(ss, ssid)
 			if (root->subsys_mask & (1 << ssid))
-				seq_printf(seq, ",%s", ss->legacy_name);
+				seq_show_option(seq, ss->name, NULL);
 	if (root->flags & CGRP_ROOT_NOPREFIX)
 		seq_puts(seq, ",noprefix");
 	if (root->flags & CGRP_ROOT_XATTR)
@@ -1350,13 +1350,14 @@ static int cgroup_show_options(struct se
 
 	spin_lock(&release_agent_path_lock);
 	if (strlen(root->release_agent_path))
-		seq_printf(seq, ",release_agent=%s", root->release_agent_path);
+		seq_show_option(seq, "release_agent",
+				root->release_agent_path);
 	spin_unlock(&release_agent_path_lock);
 
 	if (test_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags))
 		seq_puts(seq, ",clone_children");
 	if (strlen(root->name))
-		seq_printf(seq, ",name=%s", root->name);
+		seq_show_option(seq, "name", root->name);
 	return 0;
 }
 
diff -puN net/ceph/ceph_common.c~fs-create-and-use-seq_show_option-for-escaping net/ceph/ceph_common.c
--- a/net/ceph/ceph_common.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/net/ceph/ceph_common.c
@@ -517,8 +517,11 @@ int ceph_print_client_options(struct seq
 	struct ceph_options *opt = client->options;
 	size_t pos = m->count;
 
-	if (opt->name)
-		seq_printf(m, "name=%s,", opt->name);
+	if (opt->name) {
+		seq_puts(m, "name=");
+		seq_escape(m, opt->name, ", \t\n\\");
+		seq_putc(m, ',');
+	}
 	if (opt->key)
 		seq_puts(m, "secret=<hidden>,");
 
diff -puN security/selinux/hooks.c~fs-create-and-use-seq_show_option-for-escaping security/selinux/hooks.c
--- a/security/selinux/hooks.c~fs-create-and-use-seq_show_option-for-escaping
+++ a/security/selinux/hooks.c
@@ -1100,7 +1100,7 @@ static void selinux_write_opts(struct se
 		seq_puts(m, prefix);
 		if (has_comma)
 			seq_putc(m, '\"');
-		seq_puts(m, opts->mnt_opts[i]);
+		seq_escape(m, opts->mnt_opts[i], "\"\n\\");
 		if (has_comma)
 			seq_putc(m, '\"');
 	}
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-string_helpers-clarify-esc-arg-in-string_escape_mem.patch
lib-string_helpers-rename-esc-arg-to-only.patch

