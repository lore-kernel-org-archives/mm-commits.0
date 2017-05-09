From: akpm@linux-foundation.org
Subject: [merged]
 apparmorfs-replace-current_time-with-current_time.patch removed from -mm
 tree
Date: Tue, 09 May 2017 11:04:12 -0700
Message-ID: <20170509180412.IAVJ3X02L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35444 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753737AbdEISEN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:04:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, john.johansen@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: apparmorfs: replace CURRENT_TIME with current_time()
has been removed from the -mm tree.  Its filename was
     apparmorfs-replace-current_time-with-current_time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: apparmorfs: replace CURRENT_TIME with current_time()

CURRENT_TIME macro is not y2038 safe on 32 bit systems.

The patch replaces all the uses of CURRENT_TIME by current_time().

This is also in preparation for the patch that transitions vfs timestamps
to use 64 bit time and hence make them y2038 safe.  current_time() is also
planned to be transitioned to y2038 safe behavior along with this change.

CURRENT_TIME macro will be deleted before merging the aforementioned
change.

Link: http://lkml.kernel.org/r/1491613030-11599-11-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: John Johansen <john.johansen@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/apparmor/apparmorfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/apparmor/apparmorfs.c~apparmorfs-replace-current_time-with-current_time security/apparmor/apparmorfs.c
--- a/security/apparmor/apparmorfs.c~apparmorfs-replace-current_time-with-current_time
+++ a/security/apparmor/apparmorfs.c
@@ -1357,7 +1357,7 @@ static int aa_mk_null_file(struct dentry
 
 	inode->i_ino = get_next_ino();
 	inode->i_mode = S_IFCHR | S_IRUGO | S_IWUGO;
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = current_time(inode);
 	init_special_inode(inode, S_IFCHR | S_IRUGO | S_IWUGO,
 			   MKDEV(MEM_MAJOR, 3));
 	d_instantiate(dentry, inode);
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are

time-delete-current_fs_time-function.patch

