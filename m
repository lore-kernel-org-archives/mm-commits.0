From: akpm@linux-foundation.org
Subject: [patch 098/114] apparmorfs: replace CURRENT_TIME with
 current_time()
Date: Mon, 08 May 2017 15:59:31 -0700
Message-ID: <20170508225931.86vbFsN2J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbdEHW7c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:59:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deepa.kernel@gmail.com, john.johansen@canonical.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
