From: akpm@linux-foundation.org
Subject: [merged] posix_acl-make-posix_acl_create-safer-and-cleaner.patch
 removed from -mm tree
Date: Tue, 23 Jun 2015 11:21:51 -0700
Message-ID: <5589a3bf.vsrgpmtE46Bu6Mwm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655AbbFWSVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Jun 2015 14:21:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/posix_acl.c: make posix_acl_create() safer and cleaner
has been removed from the -mm tree.  Its filename was
     posix_acl-make-posix_acl_create-safer-and-cleaner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: fs/posix_acl.c: make posix_acl_create() safer and cleaner

If posix_acl_create() returns an error code then "*acl" and "*default_acl"
can be uninitialized or point to freed memory.  This is a dangerous thing
to do.  For example, it causes a problem in ocfs2_reflink():

	fs/ocfs2/refcounttree.c:4327 ocfs2_reflink()
	error: potentially using uninitialized 'default_acl'.

I've re-written this so we set the pointers to NULL at the start.  I've
added a temporary "clone" variable to hold the value of "*acl" until end. 
Setting them to NULL means means we don't need the "no_acl" label.  We may
as well remove the "apply_umask" stuff forward and remove that label as
well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/posix_acl.c |   46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff -puN fs/posix_acl.c~posix_acl-make-posix_acl_create-safer-and-cleaner fs/posix_acl.c
--- a/fs/posix_acl.c~posix_acl-make-posix_acl_create-safer-and-cleaner
+++ a/fs/posix_acl.c
@@ -547,51 +547,45 @@ posix_acl_create(struct inode *dir, umod
 		struct posix_acl **default_acl, struct posix_acl **acl)
 {
 	struct posix_acl *p;
+	struct posix_acl *clone;
 	int ret;
 
+	*acl = NULL;
+	*default_acl = NULL;
+
 	if (S_ISLNK(*mode) || !IS_POSIXACL(dir))
-		goto no_acl;
+		return 0;
 
 	p = get_acl(dir, ACL_TYPE_DEFAULT);
-	if (IS_ERR(p)) {
-		if (p == ERR_PTR(-EOPNOTSUPP))
-			goto apply_umask;
-		return PTR_ERR(p);
+	if (!p || p == ERR_PTR(-EOPNOTSUPP)) {
+		*mode &= ~current_umask();
+		return 0;
 	}
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 
-	if (!p)
-		goto apply_umask;
-
-	*acl = posix_acl_clone(p, GFP_NOFS);
-	if (!*acl)
+	clone = posix_acl_clone(p, GFP_NOFS);
+	if (!clone)
 		goto no_mem;
 
-	ret = posix_acl_create_masq(*acl, mode);
+	ret = posix_acl_create_masq(clone, mode);
 	if (ret < 0)
 		goto no_mem_clone;
 
-	if (ret == 0) {
-		posix_acl_release(*acl);
-		*acl = NULL;
-	}
+	if (ret == 0)
+		posix_acl_release(clone);
+	else
+		*acl = clone;
 
-	if (!S_ISDIR(*mode)) {
+	if (!S_ISDIR(*mode))
 		posix_acl_release(p);
-		*default_acl = NULL;
-	} else {
+	else
 		*default_acl = p;
-	}
-	return 0;
 
-apply_umask:
-	*mode &= ~current_umask();
-no_acl:
-	*default_acl = NULL;
-	*acl = NULL;
 	return 0;
 
 no_mem_clone:
-	posix_acl_release(*acl);
+	posix_acl_release(clone);
 no_mem:
 	posix_acl_release(p);
 	return -ENOMEM;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
mm-hugetlb-introduce-minimum-hugepage-order.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch
checkpatch-categorize-some-long-line-length-checks.patch
linux-next.patch

