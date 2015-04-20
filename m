From: akpm@linux-foundation.org
Subject: [merged]
 hfsplus-dont-store-special-osx-xattr-prefix-on-disk.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 12:19:19 -0700
Message-ID: <55355137.ev9EglNG741IxSDY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbbDTTM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tommyhebb@gmail.com, anton@tuxera.com, fabf@skynet.be, hch@infradead.org, htl10@users.sourceforge.net, lists@nerdbynature.de, saproj@gmail.com, slava@dubeyko.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: don't store special "osx" xattr prefix on-disk
has been removed from the -mm tree.  Its filename was
     hfsplus-dont-store-special-osx-xattr-prefix-on-disk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Hebb <tommyhebb@gmail.com>
Subject: hfsplus: don't store special "osx" xattr prefix on-disk

On Mac OS X, HFS+ extended attributes are not namespaced.  Since we want
to be compatible with OS X filesystems and yet still support the Linux
namespacing system, the hfsplus driver implements a special "osx"
namespace that is reported for any attribute that is not namespaced
on-disk.  However, the current code for getting and setting these
unprefixed attributes is broken.

hfsplus_osx_setattr() and hfsplus_osx_getattr() are passed names that have
already had their "osx." prefixes stripped by the generic functions.  The
functions first, quite correctly, check those names to make sure that they
aren't prefixed with a known namespace, which would allow namespace access
restrictions to be bypassed.  However, the functions then prepend "osx."
to the name they're given before passing it on to hfsplus_getattr() and
hfsplus_setattr().  Not only does this cause the "osx." prefix to be
stored on-disk, defeating its purpose, it also breaks the check for the
special "com.apple.FinderInfo" attribute, which is reported for all files,
and as a consequence makes some userspace applications (e.g.  GNU patch)
fail even when extended attributes are not otherwise in use.

There are five commits which have touched this particular code:

  127e5f5ae51e ("hfsplus: rework functionality of getting, setting and deleting of extended attributes")
  b168fff72109 ("hfsplus: use xattr handlers for removexattr")
  bf29e886b242 ("hfsplus: correct usage of HFSPLUS_ATTR_MAX_STRLEN for non-English attributes")
  fcacbd95e121 ("fs/hfsplus: move xattr_name allocation in hfsplus_getxattr()")
  ec1bbd346f18 ("fs/hfsplus: move xattr_name allocation in hfsplus_setxattr()")

The first commit creates the functions to begin with.  The namespace is
prepended by the original code, which I believe was correct at the time,
since hfsplus_?etattr() stripped the prefix if found.  The second commit
removes this behavior from hfsplus_?etattr() and appears to have been
intended to also remove the prefixing from hfsplus_osx_?etattr(). 
However, what it actually does is remove a necessary strncpy() call
completely, breaking the osx namespace entirely.  The third commit re-adds
the strncpy() call as it was originally, but doesn't mention it in its
commit message.  The final two commits refactor the code and don't affect
its functionality.

This commit does what b168fff attempted to do (prevent the prefix from
being added), but does it properly, instead of passing in an empty buffer
(which is what b168fff actually did).

Fixes: b168fff72109 ("hfsplus: use xattr handlers for removexattr")
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Sergei Antonov <saproj@gmail.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN fs/hfsplus/xattr.c~hfsplus-dont-store-special-osx-xattr-prefix-on-disk fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-dont-store-special-osx-xattr-prefix-on-disk
+++ a/fs/hfsplus/xattr.c
@@ -862,8 +862,13 @@ static int hfsplus_osx_getxattr(struct d
 	if (is_known_namespace(name))
 		return -EOPNOTSUPP;
 
-	return hfsplus_getxattr(dentry, name, buffer, size,
-				XATTR_MAC_OSX_PREFIX, XATTR_MAC_OSX_PREFIX_LEN);
+	/*
+	 * osx is the namespace we use to indicate an unprefixed
+	 * attribute on the filesystem (like the ones that OS X
+	 * creates), so we pass the name through unmodified (after
+	 * ensuring it doesn't conflict with another namespace).
+	 */
+	return __hfsplus_getxattr(dentry->d_inode, name, buffer, size);
 }
 
 static int hfsplus_osx_setxattr(struct dentry *dentry, const char *name,
@@ -879,9 +884,13 @@ static int hfsplus_osx_setxattr(struct d
 	if (is_known_namespace(name))
 		return -EOPNOTSUPP;
 
-	return hfsplus_setxattr(dentry, name, buffer, size, flags,
-				XATTR_MAC_OSX_PREFIX,
-				XATTR_MAC_OSX_PREFIX_LEN);
+	/*
+	 * osx is the namespace we use to indicate an unprefixed
+	 * attribute on the filesystem (like the ones that OS X
+	 * creates), so we pass the name through unmodified (after
+	 * ensuring it doesn't conflict with another namespace).
+	 */
+	return __hfsplus_setxattr(dentry->d_inode, name, buffer, size, flags);
 }
 
 static size_t hfsplus_osx_listxattr(struct dentry *dentry, char *list,
_

Patches currently in -mm which might be from tommyhebb@gmail.com are

origin.patch

