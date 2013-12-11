From: akpm@linux-foundation.org
Subject: +
 ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch
 added to -mm tree
Date: Tue, 10 Dec 2013 16:18:05 -0800
Message-ID: <52a7af3d.nOyPKbgkf/bPamEZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3LKASG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 19:18:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: + ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch added to -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 16:18:05 -0800


The patch titled
     Subject: ocfs2: adjust minlen with discard_granularity in the FITRIM ioctl
has been added to the -mm tree.  Its filename is
     ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch

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

ocfs2-return-eopnotsupp-if-the-device-does-not-support-discard.patch
ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch
ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

