From: akpm@linux-foundation.org
Subject: [merged] fs-affs-nameic-forward-declarations-clean-up.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:50:27 -0800
Message-ID: <58b5e293.IWB+p8sEsAApePDL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751808AbdB1Uvd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/namei.c: forward declarations clean-up
has been removed from the -mm tree.  Its filename was
     fs-affs-nameic-forward-declarations-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/namei.c: forward declarations clean-up

Move dentry_operations structures and remove forward declarations.

Link: http://lkml.kernel.org/r/20170109191208.6085-7-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/namei.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff -puN fs/affs/namei.c~fs-affs-nameic-forward-declarations-clean-up fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-nameic-forward-declarations-clean-up
+++ a/fs/affs/namei.c
@@ -13,26 +13,6 @@
 
 typedef int (*toupper_t)(int);
 
-static int	 affs_toupper(int ch);
-static int	 affs_hash_dentry(const struct dentry *, struct qstr *);
-static int       affs_compare_dentry(const struct dentry *dentry,
-		unsigned int len, const char *str, const struct qstr *name);
-static int	 affs_intl_toupper(int ch);
-static int	 affs_intl_hash_dentry(const struct dentry *, struct qstr *);
-static int       affs_intl_compare_dentry(const struct dentry *dentry,
-		unsigned int len, const char *str, const struct qstr *name);
-
-const struct dentry_operations affs_dentry_operations = {
-	.d_hash		= affs_hash_dentry,
-	.d_compare	= affs_compare_dentry,
-};
-
-const struct dentry_operations affs_intl_dentry_operations = {
-	.d_hash		= affs_intl_hash_dentry,
-	.d_compare	= affs_intl_compare_dentry,
-};
-
