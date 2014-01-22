From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:11:55 -0800
Message-ID: <52e0260b.x2uiCNMBz3N3n72f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaAVULz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:11:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: [merged] ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch removed from -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:11:55 -0800


The patch titled
     Subject: ocfs2: adjust minlen with discard_granularity in the FITRIM ioctl
has been removed from the -mm tree.  Its filename was
     ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jie Liu <jeff.liu@oracle.com>
Subject: ocfs2: adjust minlen with discard_granularity in the FITRIM ioctl

Adjust minlen with discard_granularity for FITRIM ioctl(2) if the given
minimum size in bytes is less than it because, discard granularity is used
to tell us that the minimum size of extent that can be discarded by the
storage device.

This is inspired by ext4 commit 5c2ed62fd4 ("ext4: Adjust minlen with
discard_granularity in the FITRIM ioctl") from Lukas Czerner.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/ioctl.c~ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl
+++ a/fs/ocfs2/ioctl.c
@@ -980,6 +980,8 @@ long ocfs2_ioctl(struct file *filp, unsi
 		if (copy_from_user(&range, argp, sizeof(range)))
 			return -EFAULT;
 
+		range.minlen = max_t(u64, q->limits.discard_granularity,
+				     range.minlen);
 		ret = ocfs2_trim_fs(sb, &range);
 		if (ret < 0)
 			return ret;
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

