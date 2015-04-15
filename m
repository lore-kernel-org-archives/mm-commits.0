From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:22 -0700
Message-ID: <552eb726.srMSeQ9+0JsK+ZlM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbDOTIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: rollback the cleared bits if error occurs after ocfs2_block_group_clear_bits
has been removed from the -mm tree.  Its filename was
     ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

