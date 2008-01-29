From: akpm@linux-foundation.org
Subject: + mount-options-fix-capifs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:28 -0800
Message-ID: <200801292322.m0TNMSna009698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754839AbYA2XWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, kkeil@suse.de


The patch titled
     mount options: fix capifs
has been added to the -mm tree.  Its filename is
     mount-options-fix-capifs.patch

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
Subject: mount options: fix capifs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to capifs.

Use generic_show_options() and save the complete option string in
capifs_remount().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capifs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/isdn/capi/capifs.c~mount-options-fix-capifs drivers/isdn/capi/capifs.c
--- a/drivers/isdn/capi/capifs.c~mount-options-fix-capifs
+++ a/drivers/isdn/capi/capifs.c
@@ -52,6 +52,7 @@ static int capifs_remount(struct super_b
 	gid_t gid = 0;
 	umode_t mode = 0600;
 	char *this_char;
+	char *new_opt = kstrdup(data, GFP_KERNEL);
 
 	this_char = NULL;
 	while ((this_char = strsep(&data, ",")) != NULL) {
@@ -72,11 +73,16 @@ static int capifs_remount(struct super_b
 			return -EINVAL;
 		}
 	}
+
+	kfree(s->s_options);
+	s->s_options = new_opt;
+
 	config.setuid  = setuid;
 	config.setgid  = setgid;
 	config.uid     = uid;
 	config.gid     = gid;
 	config.mode    = mode;
+
 	return 0;
 }
 
@@ -84,6 +90,7 @@ static struct super_operations capifs_so
 {
 	.statfs		= simple_statfs,
 	.remount_fs	= capifs_remount,
+	.show_options	= generic_show_options,
 };
 
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-udf.patch
