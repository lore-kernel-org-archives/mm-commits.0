From: akpm@linux-foundation.org
Subject: +
 ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits.patch added to -mm tree
Date: Tue, 17 Mar 2015 16:30:52 -0700
Message-ID: <5508b92c.9QZemIKCX1nhgaAd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbbCQXax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Mar 2015 19:30:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: rollback the cleared bits if error occurs after ocfs2_block_group_clear_bits
has been added to the -mm tree.  Its filename is
     ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: rollback the cleared bits if error occurs after ocfs2_block_group_clear_bits

ocfs2_block_group_clear_bits will clear bits in block group bitmap.
Once it succeeds but fails in the following step, it will cause block
group bitmap mismatch the corresponding count recorded in dinode.
So rollback the cleared bits if error occurs.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/suballoc.c~ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits
+++ a/fs/ocfs2/suballoc.c
@@ -2499,6 +2499,8 @@ static int _ocfs2_free_suballoc_bits(han
 					 alloc_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
+		ocfs2_block_group_set_bits(handle, alloc_inode, group, group_bh,
+				start_bit, count);
 		goto bail;
 	}
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch
ocfs2-no-need-get-dinode-bh-when-zeroing-extend.patch
ocfs2-take-inode-lock-when-get-clusters.patch
ocfs2-do-not-use-ocfs2_zero_extend-during-direct-io.patch
ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch
ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch
ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails.patch
ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

