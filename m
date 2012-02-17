From: akpm@linux-foundation.org
Subject: + fs-symlink-restrictions-on-sticky-directories.patch added to -mm tree
Date: Fri, 17 Feb 2012 15:24:45 -0800
Message-ID: <20120217232445.711B6A0201@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:39369 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab2BQXYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 18:24:46 -0500
Received: by yenm1 with SMTP id m1so502479yen.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 15:24:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, a.p.zijlstra@chello.nl, drosenberg@vsecurity.com, eparis@redhat.com, federica.teodori@googlemail.com, lucian.grijincu@gmail.com, matthew@wil.cx, mingo@elte.hu, rdunlap@xenotime.net, riel@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs: symlink restrictions on sticky directories
has been added to the -mm tree.  Its filename is
     fs-symlink-restrictions-on-sticky-directories.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Kees Cook <keescook@chromium.org>
Subject: fs: symlink restrictions on sticky directories

A longstanding class of security issues is the symlink-based
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

This patch is based on the patch in Openwall and grsecurity, along with
suggestions from Al Viro.  I have added a sysctl to enable the protecte=
d
behavior, documentation, and an audit notification.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Federica Teodori <federica.teodori@googlemail.com>
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Paris <eparis@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/fs.txt |   21 +++++++
 fs/Kconfig                  |   34 ++++++++++++
 fs/namei.c                  |   91 +++++++++++++++++++++++++++++++---
 kernel/sysctl.c             |   14 +++++
 4 files changed, 154 insertions(+), 6 deletions(-)

diff -puN Documentation/sysctl/fs.txt~fs-symlink-restrictions-on-sticky=
-directories Documentation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~fs-symlink-restrictions-on-sticky-dir=
ectories
+++ a/Documentation/sysctl/fs.txt
@@ -32,6 +32,7 @@ Currently, these files are in /proc/sys/
 - nr_open
 - overflowuid
 - overflowgid
+- protected_sticky_symlinks
 - suid_dumpable
 - super-max
 - super-nr
@@ -157,6 +158,26 @@ The default is 65534.
=20
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
+protected_sticky_symlinks:
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
diff -puN fs/Kconfig~fs-symlink-restrictions-on-sticky-directories fs/K=
config
--- a/fs/Kconfig~fs-symlink-restrictions-on-sticky-directories
+++ a/fs/Kconfig
@@ -271,4 +271,38 @@ endif # NETWORK_FILESYSTEMS
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
=20
+config PROTECTED_STICKY_SYMLINKS
+	bool "Evaluate vulnerable symlink conditions"
+	default y
+	help
+	  A long-standing class of security issues is the symlink-based
+	  time-of-check-time-of-use race, most commonly seen in
+	  world-writable directories like /tmp. The common method of
+	  exploitation of this flaw is to cross privilege boundaries
+	  when following a given symlink (i.e. a root process follows
+	  a malicious symlink belonging to another user).
+
+	  Enabling this adds the logic to examine these dangerous symlink
+	  conditions. Whether or not the dangerous symlink situations are
+	  allowed is controlled by PROTECTED_STICKY_SYMLINKS_ENABLED.
+
+config PROTECTED_STICKY_SYMLINKS_ENABLED
+	depends on PROTECTED_STICKY_SYMLINKS
+	bool "Disallow symlink following in sticky world-writable dirs"
+	default y
+	help
+	  Solve ToCToU symlink race vulnerablities by permitting symlinks
+	  to be followed only when outside a sticky world-writable directory,
+	  or when the uid of the symlink and follower match, or when the
+	  directory and symlink owners match.
+
+	  When PROC_SYSCTL is enabled, this setting can also be controlled
+	  via /proc/sys/kernel/protected_sticky_symlinks.
+
+config PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL
+	depends on PROTECTED_STICKY_SYMLINKS
+	int
+	default "1" if PROTECTED_STICKY_SYMLINKS_ENABLED
+	default "0"
+
 endmenu
diff -puN fs/namei.c~fs-symlink-restrictions-on-sticky-directories fs/n=
amei.c
--- a/fs/namei.c~fs-symlink-restrictions-on-sticky-directories
+++ a/fs/namei.c
@@ -623,10 +623,84 @@ static inline void put_link(struct namei
 	path_put(link);
 }
=20
+#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+int sysctl_protected_sticky_symlinks __read_mostly =3D
+	CONFIG_PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL;
+
+/**
+ * may_follow_link - Check symlink following for unsafe situations
+ * @dentry: The inode/dentry of the symlink
+ * @nameidata: The path data of the symlink
+ *
+ * In the case of the protected_sticky_symlinks sysctl being enabled,
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
+static inline int
+may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
+{
+	int error =3D 0;
+	const struct inode *parent;
+	const struct inode *inode;
+	const struct cred *cred;
+
+	if (!sysctl_protected_sticky_symlinks)
+		return 0;
+
+	/* Allowed if owner and follower match. */
+	cred =3D current_cred();
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
+#ifdef CONFIG_AUDIT
+	if (error) {
+		struct audit_buffer *ab;
+
+		ab =3D audit_log_start(current->audit_context,
+				     GFP_KERNEL, AUDIT_AVC);
+		audit_log_format(ab, "op=3Dfollow_link action=3Ddenied");
+		audit_log_format(ab, " pid=3D%d comm=3D", current->pid);
+		audit_log_untrustedstring(ab, current->comm);
+		audit_log_d_path(ab, " path=3D", &nameidata->path);
+		audit_log_format(ab, " name=3D");
+		audit_log_untrustedstring(ab, dentry->d_name.name);
+		audit_log_format(ab, " dev=3D");
+		audit_log_untrustedstring(ab, inode->i_sb->s_id);
+		audit_log_format(ab, " ino=3D%lu", inode->i_ino);
+		audit_log_end(ab);
+	}
+#endif
+	return error;
+}
+#else
+static inline int
+may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
+{
+	return 0;
+}
+#endif
+
 static __always_inline int
-follow_link(struct path *link, struct nameidata *nd, void **p)
+follow_link(struct path *link, struct nameidata *nd, void **p, bool se=
nsitive)
 {
-	int error;
+	int error =3D 0;
 	struct dentry *dentry =3D link->dentry;
=20
 	BUG_ON(nd->flags & LOOKUP_RCU);
@@ -645,7 +719,10 @@ follow_link(struct path *link, struct na
 	touch_atime(link->mnt, dentry);
 	nd_set_link(nd, NULL);
=20
-	error =3D security_inode_follow_link(link->dentry, nd);
+	if (sensitive)
+		error =3D may_follow_link(link->dentry, nd);
+	if (!error)
+		error =3D security_inode_follow_link(link->dentry, nd);
 	if (error) {
 		*p =3D ERR_PTR(error); /* no ->put_link(), please */
 		path_put(&nd->path);
@@ -1342,7 +1419,7 @@ static inline int nested_symlink(struct=20
 		struct path link =3D *path;
 		void *cookie;
=20
-		res =3D follow_link(&link, nd, &cookie);
+		res =3D follow_link(&link, nd, &cookie, false);
 		if (!res)
 			res =3D walk_component(nd, path, &nd->last,
 					     nd->last_type, LOOKUP_FOLLOW);
@@ -1615,7 +1692,8 @@ static int path_lookupat(int dfd, const=20
 			void *cookie;
 			struct path link =3D path;
 			nd->flags |=3D LOOKUP_PARENT;
-			err =3D follow_link(&link, nd, &cookie);
+
+			err =3D follow_link(&link, nd, &cookie, true);
 			if (!err)
 				err =3D lookup_last(nd, &path);
 			put_link(nd, &link, cookie);
@@ -2327,7 +2405,8 @@ static struct file *path_openat(int dfd,
 		}
 		nd->flags |=3D LOOKUP_PARENT;
 		nd->flags &=3D ~(LOOKUP_OPEN|LOOKUP_CREATE|LOOKUP_EXCL);
-		error =3D follow_link(&link, nd, &cookie);
+
+		error =3D follow_link(&link, nd, &cookie, true);
 		if (unlikely(error))
 			filp =3D ERR_PTR(error);
 		else
diff -puN kernel/sysctl.c~fs-symlink-restrictions-on-sticky-directories=
 kernel/sysctl.c
--- a/kernel/sysctl.c~fs-symlink-restrictions-on-sticky-directories
+++ a/kernel/sysctl.c
@@ -109,6 +109,9 @@ extern int sysctl_nr_trim_pages;
 #ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
 #endif
+#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+extern int sysctl_protected_sticky_symlinks;
+#endif
=20
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
@@ -1497,6 +1500,17 @@ static struct ctl_table fs_table[] =3D {
 	},
 #endif
 #endif
+#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+	{
+		.procname	=3D "protected_sticky_symlinks",
+		.data		=3D &sysctl_protected_sticky_symlinks,
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
Subject: Subject: fs: symlink restrictions on sticky directories

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-symlink-restrictions-on-sticky-directories-fix.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-pro=
c-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
