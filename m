From: akpm@linux-foundation.org
Subject: +
 ocfs2-return-eopnotsupp-if-the-device-does-not-support-discard.patch added
 to -mm tree
Date: Tue, 10 Dec 2013 16:18:03 -0800
Message-ID: <52a7af3b.vAsA7jRoxBLuAsXm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3LKASE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 19:18:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: + ocfs2-return-eopnotsupp-if-the-device-does-not-support-discard.patch added to -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 16:18:03 -0800


The patch titled
     Subject: ocfs2: return EOPNOTSUPP if the device does not support discard
has been added to the -mm tree.  Its filename is
     ocfs2-return-eopnotsupp-if-the-device-does-not-support-discard.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-return-eopnotsupp-if-the-device-does-not-support-discard.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-return-eopnotsupp-if-the-device-does-not-support-discard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jie Liu <jeff.liu@oracle.com>
Subject: ocfs2: return EOPNOTSUPP if the device does not support discard

For FITRIM ioctl(2), we should return EOPNOTSUPP to inform the user that
the storage device does not support discard if it is, otherwise return
success would confuse the user even though there is no free blocks were
trimmed at all.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ocfs2/ioctl.c~ocfs2-return-eopnotsupp-if-the-device-does-not-support-discard fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~ocfs2-return-eopnotsupp-if-the-device-does-not-support-discard
+++ a/fs/ocfs2/ioctl.c
@@ -7,6 +7,7 @@
 
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/blkdev.h>
 #include <linux/compat.h>
 
 #include <cluster/masklog.h>
@@ -966,12 +967,16 @@ long ocfs2_ioctl(struct file *filp, unsi
 	case FITRIM:
 	{
 		struct super_block *sb = inode->i_sb;
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
 		struct fstrim_range range;
 		int ret = 0;
 
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
+		if (!blk_queue_discard(q))
+			return -EOPNOTSUPP;
+
 		if (copy_from_user(&range, argp, sizeof(range)))
 			return -EFAULT;
 
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

ocfs2-return-eopnotsupp-if-the-device-does-not-support-discard.patch
ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch
ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

