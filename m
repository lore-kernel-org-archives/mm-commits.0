From: akpm@linux-foundation.org
Subject: + ocfs2-fix-return-value-from-ocfs2_page_mkwrite.patch added to
 -mm tree
Date: Fri, 04 Mar 2016 14:51:24 -0800
Message-ID: <56da116c.FZBZEarpBuTY23tG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759311AbcCDWvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 17:51:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix return value from ocfs2_page_mkwrite()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-return-value-from-ocfs2_page_mkwrite.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-return-value-from-ocfs2_page_mkwrite.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-return-value-from-ocfs2_page_mkwrite.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: fix return value from ocfs2_page_mkwrite()

ocfs2_page_mkwrite() could mistakenly return error code instead of mkwrite
status value.  Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ocfs2/mmap.c~ocfs2-fix-return-value-from-ocfs2_page_mkwrite fs/ocfs2/mmap.c
--- a/fs/ocfs2/mmap.c~ocfs2-fix-return-value-from-ocfs2_page_mkwrite
+++ a/fs/ocfs2/mmap.c
@@ -147,6 +147,10 @@ static int ocfs2_page_mkwrite(struct vm_
 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret < 0) {
 		mlog_errno(ret);
+		if (ret == -ENOMEM)
+			ret = VM_FAULT_OOM;
+		else
+			ret = VM_FAULT_SIGBUS;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-return-value-from-ocfs2_page_mkwrite.patch

