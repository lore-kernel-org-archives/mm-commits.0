From: akpm@linux-foundation.org
Subject: + fs-make-struct-file-arg-to-d_path-const.patch added to -mm tree
Date: Mon, 12 May 2008 16:18:14 -0700
Message-ID: <200805122318.m4CNIE4I014137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbYELXSv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:18:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@medozas.de, viro@zeniv.linux.org.uk


The patch titled
     fs: make struct file arg to d_path const
has been added to the -mm tree.  Its filename is
     fs-make-struct-file-arg-to-d_path-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1847,7 +1847,7 @@ Elong:
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
@@ -300,7 +300,7 @@ extern int d_validate(struct dentry *, s
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
 extern char *__d_path(const struct path *path, struct path *root, char *, int);
-extern char *d_path(struct path *, char *, int);
+extern char *d_path(const struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */
_

Patches currently in -mm which might be from jengelh@medozas.de are

vt-fix-console-scrolling-regression.patch
vt-fbcon-fix-background-color-on-line-feed.patch
fs-make-struct-file-arg-to-d_path-const.patch

