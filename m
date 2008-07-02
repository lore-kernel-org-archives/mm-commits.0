From: akpm@linux-foundation.org
Subject: - fs-make-struct-file-arg-to-d_path-const.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:31 -0700
Message-ID: <200807020747.m627lViu005654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753678AbYGBHsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@medozas.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: make struct file arg to d_path const
has been removed from the -mm tree.  Its filename was
     fs-make-struct-file-arg-to-d_path-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: make struct file arg to d_path const
From: Jan Engelhardt <jengelh@medozas.de>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |    2 +-
 include/linux/dcache.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dcache.c~fs-make-struct-file-arg-to-d_path-const fs/dcache.c
--- a/fs/dcache.c~fs-make-struct-file-arg-to-d_path-const
+++ a/fs/dcache.c
@@ -1948,7 +1948,7 @@ Elong:
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  */
-char *d_path(struct path *path, char *buf, int buflen)
+char *d_path(const struct path *path, char *buf, int buflen)
 {
 	char *res;
 	struct path root;
diff -puN include/linux/dcache.h~fs-make-struct-file-arg-to-d_path-const include/linux/dcache.h
--- a/include/linux/dcache.h~fs-make-struct-file-arg-to-d_path-const
+++ a/include/linux/dcache.h
@@ -302,7 +302,7 @@ extern int d_validate(struct dentry *, s
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
 extern char *__d_path(const struct path *path, struct path *root, char *, int);
-extern char *d_path(struct path *, char *, int);
+extern char *d_path(const struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */
_

Patches currently in -mm which might be from jengelh@medozas.de are

origin.patch
git-kbuild-next.patch

