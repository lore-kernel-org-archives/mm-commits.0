From: akpm@linux-foundation.org
Subject: [patch 011/119] ocfs2: make ocfs2_set_acl() static
Date: Wed, 06 Sep 2017 16:19:08 -0700
Message-ID: <20170906231908.D_xI6zx59%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754578AbdIFXTJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:19:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Jan Kara <jack@suse.cz>
Subject: ocfs2: make ocfs2_set_acl() static

The function is never called outside of fs/ocfs2/acl.c.

Link: http://lkml.kernel.org/r/20170801141252.19675-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c |    2 +-
 fs/ocfs2/acl.h |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN fs/ocfs2/acl.c~ocfs2-make-ocfs2_set_acl-static fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~ocfs2-make-ocfs2_set_acl-static
+++ a/fs/ocfs2/acl.c
@@ -221,7 +221,7 @@ out:
 /*
  * Set the access or default ACL of an inode.
  */
-int ocfs2_set_acl(handle_t *handle,
+static int ocfs2_set_acl(handle_t *handle,
 			 struct inode *inode,
 			 struct buffer_head *di_bh,
 			 int type,
diff -puN fs/ocfs2/acl.h~ocfs2-make-ocfs2_set_acl-static fs/ocfs2/acl.h
--- a/fs/ocfs2/acl.h~ocfs2-make-ocfs2_set_acl-static
+++ a/fs/ocfs2/acl.h
@@ -28,13 +28,6 @@ struct ocfs2_acl_entry {
 
 struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type);
 int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type);
-int ocfs2_set_acl(handle_t *handle,
-			 struct inode *inode,
-			 struct buffer_head *di_bh,
-			 int type,
-			 struct posix_acl *acl,
-			 struct ocfs2_alloc_context *meta_ac,
-			 struct ocfs2_alloc_context *data_ac);
 extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
 extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
 			  struct buffer_head *, struct buffer_head *,
_
