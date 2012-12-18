From: akpm@linux-foundation.org
Subject: [merged] fs-fanotify-add-mflags-field-to-fanotify-output.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:57 -0800
Message-ID: <20121218201258.5B802200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58975 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab2LRUNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:13:02 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so63528eei.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:13:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, fanotify: add @mflags field to fanotify output
has been removed from the -mm tree.  Its filename was
     fs-fanotify-add-mflags-field-to-fanotify-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, fanotify: add @mflags field to fanotify output

The kernel keeps FAN_MARK_IGNORED_SURV_MODIFY bit separately from
fsnotify_mark::mask|ignored_mask thus put it in @mflags (mark flags) field
so the user-space reader will be able to detect if such bit were used on
mark creation procedure.

 | pos:	0
 | flags:	04002
 | fanotify flags:10 event-flags:0
 | fanotify mnt_id:12 mflags:40 mask:38 ignored_mask:40000003
 | fanotify ino:4f969 sdev:800013 mflags:0 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:69f90400c275b5b4

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/notify/fdinfo.c~fs-fanotify-add-mflags-field-to-fanotify-output fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fs-fanotify-add-mflags-field-to-fanotify-output
+++ a/fs/notify/fdinfo.c
@@ -111,29 +111,33 @@ int inotify_show_fdinfo(struct seq_file 
 
 static int fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 {
+	unsigned int mflags = 0;
 	struct inode *inode;
 	int ret = 0;
 
 	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE))
 		return 0;
 
+	if (mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY)
+		mflags |= FAN_MARK_IGNORED_SURV_MODIFY;
+
 	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
 		inode = igrab(mark->i.inode);
 		if (!inode)
 			goto out;
 		ret = seq_printf(m, "fanotify ino:%lx sdev:%x "
-				 "mask:%x ignored_mask:%x ",
+				 "mflags:%x mask:%x ignored_mask:%x ",
 				 inode->i_ino, inode->i_sb->s_dev,
-				 mark->mask, mark->ignored_mask);
+				 mflags, mark->mask, mark->ignored_mask);
 		ret |= show_mark_fhandle(m, inode);
 		ret |= seq_putc(m, '\n');
 		iput(inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
 		struct mount *mnt = real_mount(mark->m.mnt);
 
-		ret = seq_printf(m, "fanotify mnt_id:%x mask:%x "
-				 "ignored_mask:%x\n",
-				 mnt->mnt_id, mark->mask, mark->ignored_mask);
+		ret = seq_printf(m, "fanotify mnt_id:%x mflags:%x mask:%x "
+				 "ignored_mask:%x\n", mnt->mnt_id, mflags,
+				 mark->mask, mark->ignored_mask);
 	}
 out:
 	return ret;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

