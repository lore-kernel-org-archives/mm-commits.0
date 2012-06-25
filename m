From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-add-link-restrictions.patch removed from -mm tree
Date: Mon, 25 Jun 2012 14:24:58 -0700
Message-ID: <20120625212459.3444DA0549@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44874 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab2FYVZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jun 2012 17:25:00 -0400
Received: by qcsu6 with SMTP id u6so170787qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Jun 2012 14:24:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mingo@elte.hu, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: add link restrictions
has been removed from the -mm tree.  Its filename was
     fs-add-link-restrictions.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Kees Cook <keescook@chromium.org>
Subject: fs: add link restrictions

This adds symlink and hardlink restrictions to the Linux VFS.

Symlinks:

A long-standing class of security issues is the symlink-based
time-of-check-time-of-use race, most commonly seen in world-writable
directories like /tmp.  The common method of exploitation of this flaw =
is
to cross privilege boundaries when following a given symlink (i.e.  a r=
oot
process follows a symlink belonging to another user).  For a likely
incomplete list of hundreds of examples across the years, please see:
http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=3D/tmp

The solution is to permit symlinks to only be followed when outside a
sticky world-writable directory, or when the uid of the symlink and
follower match, or when the directory owner matches the symlink's owner=
=2E

Some pointers to the history of earlier discussion that I could find:

 1996 Aug, Zygo Blaxell
  http://marc.info/?l=3Dbugtraq&m=3D87602167419830&w=3D2
 1996 Oct, Andrew Tridgell
  http://lkml.indiana.edu/hypermail/linux/kernel/9610.2/0086.html
 1997 Dec, Albert D Cahalan
  http://lkml.org/lkml/1997/12/16/4
 2005 Feb, Lorenzo Hern=E1ndez Garc=EDa-Hierro
  http://lkml.indiana.edu/hypermail/linux/kernel/0502.0/1896.html
 2010 May, Kees Cook
  https://lkml.org/lkml/2010/5/30/144

Past objections and rebuttals could be summarized as:

 - Violates POSIX.
   - POSIX didn't consider this situation and it's not useful to follow
     a broken specification at the cost of security.
 - Might break unknown applications that use this feature.
   - Applications that break because of the change are easy to spot and
     fix. Applications that are vulnerable to symlink ToCToU by not hav=
ing
     the change aren't. Additionally, no applications have yet been fou=
nd
     that rely on this behavior.
 - Applications should just use mkstemp() or O_CREATE|O_EXCL.
   - True, but applications are not perfect, and new software is writte=
n
     all the time that makes these mistakes; blocking this flaw at the
     kernel is a single solution to the entire class of vulnerability.
 - This should live in the core VFS.
   - This should live in an LSM. (https://lkml.org/lkml/2010/5/31/135)
 - This should live in an LSM.
   - This should live in the core VFS. (https://lkml.org/lkml/2010/8/2/=
188)

Hardlinks:

On systems that have user-writable directories on the same partition as
system files, a long-standing class of security issues is the
hardlink-based time-of-check-time-of-use race, most commonly seen in
world-writable directories like /tmp.  The common method of exploitatio=
n
of this flaw is to cross privilege boundaries when following a given
hardlink (i.e.  a root process follows a hardlink created by another
user).  Additionally, an issue exists where users can "pin" a potential=
ly
vulnerable setuid/setgid file so that an administrator will not actuall=
y
upgrade a system fully.

The solution is to permit hardlinks to only be created when the user is
already the existing file's owner, or if they already have read/write
access to the existing file.

Many Linux users are surprised when they learn they can link to files t=
hey
have no access to, so this change appears to follow the doctrine of "le=
ast
surprise".  Additionally, this change does not violate POSIX, which sta=
tes
"the implementation may require that the calling process has permission=
 to
access the existing file"[1].

This change is known to break some implementations of the "at" daemon,
though the version used by Fedora and Ubuntu has been fixed[2] for a
while.  Otherwise, the change has been undisruptive while in use in Ubu=
ntu
for the last 1.5 years.

[1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/linkat.ht=
ml
[2] http://anonscm.debian.org/gitweb/?p=3Dcollab-maint/at.git;a=3Dcommi=
tdiff;h=3Df4114656c3a6c6f6070e315ffdf940a49eda3279

This patch is based on the patches in Openwall and grsecurity, along wi=
th
suggestions from Al Viro.  I have added a sysctl to enable the protecte=
d
behavior, documentation, and audit notifications.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/fs.txt |   42 +++++++++
 fs/Kconfig                  |   60 ++++++++++++++
 fs/namei.c                  |  145 ++++++++++++++++++++++++++++++++++
 include/linux/audit.h       |    3=20
 include/linux/fs.h          |    2=20
 kernel/audit.c              |   20 ++++
 kernel/sysctl.c             |   20 ++++
 7 files changed, 292 insertions(+)

diff -puN Documentation/sysctl/fs.txt~fs-add-link-restrictions Document=
ation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~fs-add-link-restrictions
+++ a/Documentation/sysctl/fs.txt
@@ -32,6 +32,8 @@ Currently, these files are in /proc/sys/
 - nr_open
 - overflowuid
 - overflowgid
+- protected_hardlinks
+- protected_symlinks
 - suid_dumpable
 - super-max
 - super-nr
@@ -157,6 +159,46 @@ The default is 65534.
=20
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
+protected_hardlinks:
+
+A long-standing class of security issues is the hardlink-based
+time-of-check-time-of-use race, most commonly seen in world-writable
+directories like /tmp. The common method of exploitation of this flaw
+is to cross privilege boundaries when following a given hardlink (i.e.=
 a
+root process follows a hardlink created by another user). Additionally=
,
+on systems without separated partitions, this stops unauthorized users
+from "pinning" vulnerable setuid/setgid files against being upgraded b=
y
+the administrator, or linking to special files.
+
+When set to "0", hardlink creation behavior is unrestricted.
+
+When set to "1" hardlinks cannot be created by users if they do not
+already own the source file, or do not have read/write access to it.
+
+This protection is based on the restrictions in Openwall and grsecurit=
y.
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+protected_symlinks:
+
+A long-standing class of security issues is the symlink-based
+time-of-check-time-of-use race, most commonly seen in world-writable
+directories like /tmp. The common method of exploitation of this flaw
+is to cross privilege boundaries when following a given symlink (i.e. =
a
+root process follows a symlink belonging to another user). For a likel=
y
+incomplete list of hundreds of examples across the years, please see:
+http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=3D/tmp
+
+When set to "0", symlink following behavior is unrestricted.
+
+When set to "1" symlinks are permitted to be followed only when outsid=
e
+a sticky world-writable directory, or when the uid of the symlink and
+follower match, or when the directory owner matches the symlink's owne=
r.
+
+This protection is based on the restrictions in Openwall and grsecurit=
y.
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
 suid_dumpable:
=20
 This value can be used to query and set the core dump mode for setuid
diff -puN fs/Kconfig~fs-add-link-restrictions fs/Kconfig
--- a/fs/Kconfig~fs-add-link-restrictions
+++ a/fs/Kconfig
@@ -276,4 +276,64 @@ endif # NETWORK_FILESYSTEMS
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
=20
+config PROTECTED_LINKS
+	bool "Evaluate vulnerable link conditions"
+	default y
+	help
+	  A long-standing class of security issues is the link-based
+	  time-of-check-time-of-use race, most commonly seen in
+	  world-writable directories like /tmp. The common method of
+	  exploitation of this flaw is to cross privilege boundaries
+	  when following a given link (i.e. a root process follows
+	  a malicious symlink belonging to another user, or a hardlink
+	  created to a root-owned file).
+
+	  Enabling this adds the logic to examine these dangerous link
+	  conditions. Whether or not the dangerous link situations are
+	  allowed is controlled by PROTECTED_HARDLINKS_ENABLED and
+	  PROTECTED_SYMLINKS_ENABLED.
+
+config PROTECTED_SYMLINKS
+	depends on PROTECTED_LINKS
+	bool "Disallow symlink following in sticky world-writable dirs"
+	default y
+	help
+	  Solve ToCToU symlink race vulnerabilities by permitting symlinks
+	  to be followed only when outside a sticky world-writable directory,
+	  or when the uid of the symlink and follower match, or when the
+	  directory and symlink owners match.
+
+	  When PROC_SYSCTL is enabled, this setting can also be controlled
+	  via /proc/sys/kernel/protected_symlinks.
+
+	  See Documentation/sysctl/fs.txt for details.
+
+config PROTECTED_SYMLINKS_SYSCTL
+	depends on PROTECTED_LINKS
+	int
+	default "1" if PROTECTED_SYMLINKS
+	default "0"
+
+config PROTECTED_HARDLINKS
+	depends on PROTECTED_LINKS
+	bool "Disallow hardlink creation to non-accessible files"
+	default y
+	help
+	  Solve ToCToU hardlink race vulnerabilities by permitting hardlinks
+	  to be created only when to a regular file that is owned by the user=
,
+	  or is readable and writable by the user. Also blocks users from
+	  "pinning" vulnerable setuid/setgid programs from being upgraded by
+	  the administrator.
+
+	  When PROC_SYSCTL is enabled, this setting can also be controlled
+	  via /proc/sys/kernel/protected_hardlinks.
+
+	  See Documentation/sysctl/fs.txt for details.
+
+config PROTECTED_HARDLINKS_SYSCTL
+	depends on PROTECTED_LINKS
+	int
+	default "1" if PROTECTED_HARDLINKS
+	default "0"
+
 endmenu
diff -puN fs/namei.c~fs-add-link-restrictions fs/namei.c
--- a/fs/namei.c~fs-add-link-restrictions
+++ a/fs/namei.c
@@ -610,6 +610,140 @@ static inline void put_link(struct namei
 	path_put(link);
 }
=20
+#ifdef CONFIG_PROTECTED_LINKS
+int sysctl_protected_symlinks __read_mostly =3D
+	CONFIG_PROTECTED_SYMLINKS_SYSCTL;
+int sysctl_protected_hardlinks __read_mostly =3D
+	CONFIG_PROTECTED_HARDLINKS_SYSCTL;
+
+/**
+ * may_follow_link - Check symlink following for unsafe situations
+ * @link: The path of the symlink
+ *
+ * In the case of the sysctl_protected_symlinks sysctl being enabled,
+ * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
+ * in a sticky world-writable directory. This is to protect privileged
+ * processes from failing races against path names that may change out
+ * from under them by way of other users creating malicious symlinks.
+ * It will permit symlinks to be followed only when outside a sticky
+ * world-writable directory, or when the uid of the symlink and follow=
er
+ * match, or when the directory owner matches the symlink's owner.
+ *
+ * Returns 0 if following the symlink is allowed, -ve on error.
+ */
+static inline int may_follow_link(struct path *link)
+{
+	int error =3D 0;
+	const struct inode *parent;
+	const struct inode *inode;
+	const struct cred *cred;
+	struct dentry *dentry;
+
+	if (!sysctl_protected_symlinks)
+		return 0;
+
+	/* Allowed if owner and follower match. */
+	cred =3D current_cred();
+	dentry =3D link->dentry;
+	inode =3D dentry->d_inode;
+	if (cred->fsuid =3D=3D inode->i_uid)
+		return 0;
+
+	/* Check parent directory mode and owner. */
+	spin_lock(&dentry->d_lock);
+	parent =3D dentry->d_parent->d_inode;
+	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) =3D=3D (S_ISVTX|S_IWOTH) &&
+	    parent->i_uid !=3D inode->i_uid) {
+		error =3D -EACCES;
+	}
+	spin_unlock(&dentry->d_lock);
+
+	if (error)
+		audit_log_link_denied("follow_link", link);
+
+	return error;
+}
+
+/**
+ * safe_hardlink_source - Check for safe hardlink conditions
+ * @inode: the source inode to hardlink from
+ *
+ * Return false if at least one of the following conditions:
+ *    - inode is not a regular file
+ *    - inode is setuid
+ *    - inode is setgid and group-exec
+ *    - access failure for read and write
+ *
+ * Otherwise returns true.
+ */
+static bool safe_hardlink_source(struct inode *inode)
+{
+	mode_t mode =3D inode->i_mode;
+
+	/* Special files should not get pinned to the filesystem. */
+	if (!S_ISREG(mode))
+		return false;
+
+	/* Setuid files should not get pinned to the filesystem. */
+	if (mode & S_ISUID)
+		return false;
+
+	/* Executable setgid files should not get pinned to the filesystem. *=
/
+	if ((mode & (S_ISGID | S_IXGRP)) =3D=3D (S_ISGID | S_IXGRP))
+		return false;
+
+	/* Hardlinking to unreadable or unwritable sources is dangerous. */
+	if (inode_permission(inode, MAY_READ | MAY_WRITE))
+		return false;
+
+	return true;
+}
+
+/**
+ * may_linkat - Check permissions for creating a hardlink
+ * @link: the source to hardlink from
+ *
+ * Block hardlink when all of:
+ *  - sysctl_protected_hardlinks enabled
+ *  - fsuid does not match inode
+ *  - hardlink source is unsafe (see safe_hardlink_source() above)
+ *  - not CAP_FOWNER
+ *
+ * Returns 0 if successful, -ve on error.
+ */
+static int may_linkat(struct path *link)
+{
+	const struct cred *cred;
+	struct inode *inode;
+
+	if (!sysctl_protected_hardlinks)
+		return 0;
+
+	cred =3D current_cred();
+	inode =3D link->dentry->d_inode;
+
+	/* Source inode owner (or CAP_FOWNER) can hardlink all they like,
+	 * otherwise, it must be a safe source.
+	 */
+	if (cred->fsuid =3D=3D inode->i_uid || safe_hardlink_source(inode) ||
+	    capable(CAP_FOWNER))
+		return 0;
+
+	audit_log_link_denied("linkat", link);
+	return -EPERM;
+}
+#else
+static inline int may_follow_link(struct path *link)
+{
+	return 0;
+}
+
+static inline int may_linkat(struct path *link)
+{
+	return 0;
+}
+#endif
+
 static __always_inline int
 follow_link(struct path *link, struct nameidata *nd, void **p)
 {
@@ -1775,6 +1909,9 @@ static int path_lookupat(int dfd, const=20
 		while (err > 0) {
 			void *cookie;
 			struct path link =3D path;
+			err =3D may_follow_link(&link);
+			if (unlikely(err))
+				break;
 			nd->flags |=3D LOOKUP_PARENT;
 			err =3D follow_link(&link, nd, &cookie);
 			if (!err)
@@ -2471,6 +2608,11 @@ static struct file *path_openat(int dfd,
 			filp =3D ERR_PTR(-ELOOP);
 			break;
 		}
+		error =3D may_follow_link(&link);
+		if (unlikely(error)) {
+			filp =3D ERR_PTR(error);
+			break;
+		}
 		nd->flags |=3D LOOKUP_PARENT;
 		nd->flags &=3D ~(LOOKUP_OPEN|LOOKUP_CREATE|LOOKUP_EXCL);
 		error =3D follow_link(&link, nd, &cookie);
@@ -3130,6 +3272,9 @@ SYSCALL_DEFINE5(linkat, int, olddfd, con
 	error =3D -EXDEV;
 	if (old_path.mnt !=3D new_path.mnt)
 		goto out_dput;
+	error =3D may_linkat(&old_path);
+	if (unlikely(error))
+		goto out_dput;
 	error =3D mnt_want_write(new_path.mnt);
 	if (error)
 		goto out_dput;
diff -puN include/linux/audit.h~fs-add-link-restrictions include/linux/=
audit.h
--- a/include/linux/audit.h~fs-add-link-restrictions
+++ a/include/linux/audit.h
@@ -687,6 +687,8 @@ extern void		    audit_log_d_path(struct
 					     const struct path *path);
 extern void		    audit_log_key(struct audit_buffer *ab,
 					  char *key);
+extern void		    audit_log_link_denied(const char *operation,
+						  struct path *link);
 extern void		    audit_log_lost(const char *message);
 #ifdef CONFIG_SECURITY
 extern void 		    audit_log_secctx(struct audit_buffer *ab, u32 secid)=
;
@@ -716,6 +718,7 @@ extern int audit_enabled;
 #define audit_log_untrustedstring(a,s) do { ; } while (0)
 #define audit_log_d_path(b, p, d) do { ; } while (0)
 #define audit_log_key(b, k) do { ; } while (0)
+#define audit_log_link_denied(o, l) do { ; } while (0)
 #define audit_log_secctx(b,s) do { ; } while (0)
 #define audit_enabled 0
 #endif
diff -puN include/linux/fs.h~fs-add-link-restrictions include/linux/fs.=
h
--- a/include/linux/fs.h~fs-add-link-restrictions
+++ a/include/linux/fs.h
@@ -437,6 +437,8 @@ extern unsigned long get_max_files(void)
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
+extern int sysctl_protected_symlinks;
+extern int sysctl_protected_hardlinks;
=20
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
diff -puN kernel/audit.c~fs-add-link-restrictions kernel/audit.c
--- a/kernel/audit.c~fs-add-link-restrictions
+++ a/kernel/audit.c
@@ -1450,6 +1450,26 @@ void audit_log_key(struct audit_buffer *
 }
=20
 /**
+ * audit_log_link_denied - report a link restriction denial
+ * @operation: specific link opreation
+ * @link: the path that triggered the restriction
+ */
+void audit_log_link_denied(const char *operation, struct path *link)
+{
+	struct audit_buffer *ab;
+
+	ab =3D audit_log_start(current->audit_context, GFP_KERNEL, AUDIT_AVC)=
;
+	audit_log_format(ab, "op=3D%s action=3Ddenied", operation);
+	audit_log_format(ab, " pid=3D%d comm=3D", current->pid);
+	audit_log_untrustedstring(ab, current->comm);
+	audit_log_d_path(ab, " path=3D", link);
+	audit_log_format(ab, " dev=3D");
+	audit_log_untrustedstring(ab, link->dentry->d_inode->i_sb->s_id);
+	audit_log_format(ab, " ino=3D%lu", link->dentry->d_inode->i_ino);
+	audit_log_end(ab);
+}
+
+/**
  * audit_log_end - end one audit record
  * @ab: the audit_buffer
  *
diff -puN kernel/sysctl.c~fs-add-link-restrictions kernel/sysctl.c
--- a/kernel/sysctl.c~fs-add-link-restrictions
+++ a/kernel/sysctl.c
@@ -1493,6 +1493,26 @@ static struct ctl_table fs_table[] =3D {
 	},
 #endif
 #endif
+#ifdef CONFIG_PROTECTED_LINKS
+	{
+		.procname	=3D "protected_symlinks",
+		.data		=3D &sysctl_protected_symlinks,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0600,
+		.proc_handler	=3D proc_dointvec_minmax,
+		.extra1		=3D &zero,
+		.extra2		=3D &one,
+	},
+	{
+		.procname	=3D "protected_hardlinks",
+		.data		=3D &sysctl_protected_hardlinks,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0600,
+		.proc_handler	=3D proc_dointvec_minmax,
+		.extra1		=3D &zero,
+		.extra2		=3D &one,
+	},
+#endif
 	{
 		.procname	=3D "suid_dumpable",
 		.data		=3D &suid_dumpable,
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch
fs-introduce-pipe-only-dump-mode-suid_dumpable=3D3.patch
fs-introduce-pipe-only-dump-mode-suid_dumpable=3D3-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
