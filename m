From: akpm@linux-foundation.org
Subject: [obsolete] viro-fix.patch removed from -mm tree
Date: Fri, 23 Jan 2015 12:25:58 -0800
Message-ID: <54c2ae56.IcvTlC1oIRpnYFmd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbbAWUZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jan 2015 15:25:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount root fs
has been removed from the -mm tree.  Its filename was
     viro-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount root fs

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff -puN fs/namei.c~viro-fix fs/namei.c
--- a/fs/namei.c~viro-fix
+++ a/fs/namei.c
@@ -2056,13 +2056,22 @@ static int do_path_lookup(int dfd, const
 /* does lookup, returns the object with parent locked */
 struct dentry *kern_path_locked(const char *name, struct path *path)
 {
+	struct filename *filename = getname_kernel(name);
 	struct nameidata nd;
 	struct dentry *d;
-	int err = do_path_lookup(AT_FDCWD, name, LOOKUP_PARENT, &nd);
-	if (err)
+	int err;
+
+	if (IS_ERR(filename))
+		return ERR_CAST(filename);
+
+	err = filename_lookup(AT_FDCWD, filename, LOOKUP_PARENT, &nd);
+	if (err) {
+		putname(filename);
 		return ERR_PTR(err);
+	}
 	if (nd.last_type != LAST_NORM) {
 		path_put(&nd.path);
+		putname(filename);
 		return ERR_PTR(-EINVAL);
 	}
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
@@ -2070,9 +2079,11 @@ struct dentry *kern_path_locked(const ch
 	if (IS_ERR(d)) {
 		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 		path_put(&nd.path);
+		putname(filename);
 		return d;
 	}
 	*path = nd.path;
+	putname(filename);
 	return d;
 }
 
@@ -3314,7 +3325,7 @@ struct file *do_file_open_root(struct de
 	return file;
 }
 
-struct dentry *kern_path_create(int dfd, const char *pathname,
+static struct dentry *filename_create(int dfd, struct filename *name,
 				struct path *path, unsigned int lookup_flags)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
@@ -3329,7 +3340,7 @@ struct dentry *kern_path_create(int dfd,
 	 */
 	lookup_flags &= LOOKUP_REVAL;
 
-	error = do_path_lookup(dfd, pathname, LOOKUP_PARENT|lookup_flags, &nd);
+	error = filename_lookup(dfd, name, LOOKUP_PARENT|lookup_flags, &nd);
 	if (error)
 		return ERR_PTR(error);
 
@@ -3383,6 +3394,19 @@ out:
 	path_put(&nd.path);
 	return dentry;
 }
+
+struct dentry *kern_path_create(int dfd, const char *pathname,
+				struct path *path, unsigned int lookup_flags)
+{
+	struct filename *filename = getname_kernel(pathname);
+	struct dentry *res = ERR_CAST(filename);
+
+	if (!IS_ERR(filename)) {
+		res = filename_create(dfd, filename, path, lookup_flags);
+		putname(filename);
+	}
+	return res;
+}
 EXPORT_SYMBOL(kern_path_create);
 
 void done_path_create(struct path *path, struct dentry *dentry)
@@ -3401,7 +3425,7 @@ struct dentry *user_path_create(int dfd,
 	struct dentry *res;
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
-	res = kern_path_create(dfd, tmp->name, path, lookup_flags);
+	res = filename_create(dfd, tmp, path, lookup_flags);
 	putname(tmp);
 	return res;
 }
_

Patches currently in -mm which might be from viro@ZenIV.linux.org.uk are

linux-next.patch
mutex-subsystem-synchro-test-module.patch

