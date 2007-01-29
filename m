From: akpm@osdl.org
Subject: + fuse-fix-bug-in-control-filesystem-mount.patch added to -mm tree
Date: Mon, 29 Jan 2007 12:06:35 -0800
Message-ID: <200701292006.l0TK6Z1r029219@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53879 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbXA2UGq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 15:06:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miklos@szeredi.hu


The patch titled
     fuse: fix bug in control filesystem mount
has been added to the -mm tree.  Its filename is
     fuse-fix-bug-in-control-filesystem-mount.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: fix bug in control filesystem mount
From: Miklos Szeredi <miklos@szeredi.hu>

The BUG in fuse_ctl_add_dentry() could be triggered if the control
filesystem was unmounted and mounted again while one or more fuse
filesystems were present.

The fix is to reset the dentry counter in fuse_ctl_kill_sb().

Bug reported by Florent Mertens.

Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/fuse/control.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN fs/fuse/control.c~fuse-fix-bug-in-control-filesystem-mount fs/fuse/control.c
--- a/fs/fuse/control.c~fuse-fix-bug-in-control-filesystem-mount
+++ a/fs/fuse/control.c
@@ -193,8 +193,12 @@ static int fuse_ctl_get_sb(struct file_s
 
 static void fuse_ctl_kill_sb(struct super_block *sb)
 {
+	struct fuse_conn *fc;
+
 	mutex_lock(&fuse_mutex);
 	fuse_control_sb = NULL;
+	list_for_each_entry(fc, &fuse_conn_list, entry)
+		fc->ctl_ndents = 0;
 	mutex_unlock(&fuse_mutex);
 
 	kill_litter_super(sb);
_

Patches currently in -mm which might be from miklos@szeredi.hu are

fuse-fix-bug-in-control-filesystem-mount.patch
