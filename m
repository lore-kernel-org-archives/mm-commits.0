From: akpm@linux-foundation.org
Subject: + fs-affs-nameic-forward-declarations-clean-up.patch added to -mm tree
Date: Wed, 18 Jan 2017 13:44:39 -0800
Message-ID: <587fe1c7.RghMTm5wXgpv6Vh7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752406AbdARVok (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 16:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/namei.c: forward declarations clean-up
has been added to the -mm tree.  Its filename is
     fs-affs-nameic-forward-declarations-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-nameic-forward-declarations-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-nameic-forward-declarations-clean-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 /* Simple toupper() for DOS\1 */
 
 static int
@@ -505,3 +485,13 @@ const struct export_operations affs_expo
 	.fh_to_dentry = affs_fh_to_dentry,
 	.fh_to_parent = affs_fh_to_parent,
 };
+
+const struct dentry_operations affs_dentry_operations = {
+	.d_hash		= affs_hash_dentry,
+	.d_compare	= affs_compare_dentry,
+};
+
+const struct dentry_operations affs_intl_dentry_operations = {
+	.d_hash		= affs_intl_hash_dentry,
+	.d_compare	= affs_intl_compare_dentry,
+};
_

Patches currently in -mm which might be from fabf@skynet.be are

documentation-filesystems-proctxt-add-vmpin.patch
fs-affs-remove-reference-to-affs_parent_ino.patch
fs-affs-add-validation-block-function.patch
fs-affs-make-affs-exportable.patch
fs-affs-use-octal-for-permissions.patch
fs-affs-add-prefix-to-some-functions.patch
fs-affs-nameic-forward-declarations-clean-up.patch
fs-affs-make-export-work-with-cold-dcache.patch
fs-add-i_blocksize.patch

