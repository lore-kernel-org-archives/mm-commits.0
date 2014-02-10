From: akpm@linux-foundation.org
Subject: + ocfs2-check-existence-of-old-dentry-in-ocfs2_link-v2.patch
 added to -mm tree
Date: Mon, 10 Feb 2014 13:54:29 -0800
Message-ID: <52f94a95.fFnY1wASvWL7pZOj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaBJVyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 16:54:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-check-existence-of-old-dentry-in-ocfs2_link-v2.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 13:54:29 -0800


The patch titled
     Subject: ocfs2-check-existence-of-old-dentry-in-ocfs2_link-v2
has been added to the -mm tree.  Its filename is
     ocfs2-check-existence-of-old-dentry-in-ocfs2_link-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-check-existence-of-old-dentry-in-ocfs2_link-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-check-existence-of-old-dentry-in-ocfs2_link-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2-check-existence-of-old-dentry-in-ocfs2_link-v2

Signed-off-by: joyce <xuejiufei@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ocfs2/namei.c~ocfs2-check-existence-of-old-dentry-in-ocfs2_link-v2 fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-check-existence-of-old-dentry-in-ocfs2_link-v2
+++ a/fs/ocfs2/namei.c
@@ -694,6 +694,10 @@ static int ocfs2_link(struct dentry *old
 		goto out;
 	}
 
+	/*
+	 * Check whether another node removed the source inode while we
+	 * were in the vfs.
+	 */
 	if (old_de_ino != OCFS2_I(inode)->ip_blkno) {
 		err = -ENOENT;
 		goto out;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-check-existence-of-old-dentry-in-ocfs2_link.patch
ocfs2-check-existence-of-old-dentry-in-ocfs2_link-v2.patch

