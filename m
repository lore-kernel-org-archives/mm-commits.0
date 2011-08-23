From: akpm@linux-foundation.org
Subject: + readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups.patch added to -mm tree
Date: Tue, 23 Aug 2011 14:48:19 -0700
Message-ID: <201108232148.p7NLmJWK008878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab1HWVsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 17:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     readlinkat: ensure we return ENOENT for the empty pathname for normal lookups
has been added to the -mm tree.  Its filename is
     readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups.patch

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
Subject: readlinkat: ensure we return ENOENT for the empty pathname for normal lookups
From: Andy Whitcroft <apw@canonical.com>

Since the commit below which added O_PATH support to the *at() calls, the
error return for readlink/readlinkat for the empty pathname has switched
from ENOENT to EINVAL:

  commit 65cfc6722361570bfe255698d9cd4dccaf47570d
  Author: Al Viro <viro@zeniv.linux.org.uk>
  Date:   Sun Mar 13 15:56:26 2011 -0400

    readlinkat(), fchownat() and fstatat() with empty relative pathnames

This is both unexpected for userspace and makes readlink/readlinkat
inconsistant with all other interfaces; and inconsistant with our stated
return for these pathnames.

As the readlinkat call does not have a flags parameter we cannot use the
AT_EMPTY_PATH approach used in the other calls.  Therefore expose whether
the original path is infact entry via a new user_path_at_empty() path
lookup function.  Use this to determine whether to default to EINVAL or
ENOENT for failures.

BugLink: http://bugs.launchpad.net/bugs/817187
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |   24 +++++++++++++++++++-----
 fs/stat.c             |    5 +++--
 include/linux/namei.h |    1 +
 3 files changed, 23 insertions(+), 7 deletions(-)

diff -puN fs/namei.c~readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups fs/namei.c
--- a/fs/namei.c~readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups
+++ a/fs/namei.c
@@ -137,7 +137,8 @@ static int do_getname(const char __user 
 	return retval;
 }
 
-static char *getname_flags(const char __user * filename, int flags)
+static char *getname_flags_empty(const char __user * filename,
+							int flags, int *empty)
 {
 	char *tmp, *result;
 
@@ -148,6 +149,8 @@ static char *getname_flags(const char __
 
 		result = tmp;
 		if (retval < 0) {
+			if (retval == -ENOENT && empty)
+				*empty = 1;
 			if (retval != -ENOENT || !(flags & LOOKUP_EMPTY)) {
 				__putname(tmp);
 				result = ERR_PTR(retval);
@@ -158,9 +161,14 @@ static char *getname_flags(const char __
 	return result;
 }
 
+static char *getname_flags(const char __user * filename, int flags)
+{
+	return getname_flags_empty(filename, flags, 0);
+}
+
 char *getname(const char __user * filename)
 {
-	return getname_flags(filename, 0);
+	return getname_flags_empty(filename, 0, 0);
 }
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -1807,11 +1815,11 @@ struct dentry *lookup_one_len(const char
 	return __lookup_hash(&this, base, NULL);
 }
 
-int user_path_at(int dfd, const char __user *name, unsigned flags,
-		 struct path *path)
+int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
+		 struct path *path, int *empty)
 {
 	struct nameidata nd;
-	char *tmp = getname_flags(name, flags);
+	char *tmp = getname_flags_empty(name, flags, empty);
 	int err = PTR_ERR(tmp);
 	if (!IS_ERR(tmp)) {
 
@@ -1825,6 +1833,12 @@ int user_path_at(int dfd, const char __u
 	return err;
 }
 
+int user_path_at(int dfd, const char __user *name, unsigned flags,
+		 struct path *path)
+{
+	return user_path_at_empty(dfd, name, flags, path, 0);
+}
+
 static int user_path_parent(int dfd, const char __user *path,
 			struct nameidata *nd, char **name)
 {
diff -puN fs/stat.c~readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups fs/stat.c
--- a/fs/stat.c~readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups
+++ a/fs/stat.c
@@ -296,15 +296,16 @@ SYSCALL_DEFINE4(readlinkat, int, dfd, co
 {
 	struct path path;
 	int error;
+	int empty = 0;
 
 	if (bufsiz <= 0)
 		return -EINVAL;
 
-	error = user_path_at(dfd, pathname, LOOKUP_EMPTY, &path);
+	error = user_path_at_empty(dfd, pathname, LOOKUP_EMPTY, &path, &empty);
 	if (!error) {
 		struct inode *inode = path.dentry->d_inode;
 
-		error = -EINVAL;
+		error = (empty) ? -ENOENT : -EINVAL;
 		if (inode->i_op->readlink) {
 			error = security_inode_readlink(path.dentry);
 			if (!error) {
diff -puN include/linux/namei.h~readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups include/linux/namei.h
--- a/include/linux/namei.h~readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups
+++ a/include/linux/namei.h
@@ -66,6 +66,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_EMPTY		0x4000
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
+extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
 
 #define user_path(name, path) user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW, path)
 #define user_lpath(name, path) user_path_at(AT_FDCWD, name, 0, path)
_

Patches currently in -mm which might be from apw@canonical.com are

readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups.patch

