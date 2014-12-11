From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-an-off-by-one-bug_on-statement.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:55:08 -0800
Message-ID: <5489e88c.lWTLyZNXCKXm88KS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaLKSzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix an off-by-one BUG_ON() statement
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-an-off-by-one-bug_on-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: fix an off-by-one BUG_ON() statement

The ->si_slots[] array is allocated in ocfs2_init_slot_info() it has
"->max_slots" number of elements so this test should be >= instead of >.

Static checker work.  Compile tested only.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/slot_map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/slot_map.c~ocfs2-fix-an-off-by-one-bug_on-statement fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~ocfs2-fix-an-off-by-one-bug_on-statement
+++ a/fs/ocfs2/slot_map.c
@@ -306,7 +306,7 @@ int ocfs2_slot_to_node_num_locked(struct
 	assert_spin_locked(&osb->osb_lock);
 
 	BUG_ON(slot_num < 0);
-	BUG_ON(slot_num > osb->max_slots);
+	BUG_ON(slot_num >= osb->max_slots);
 
 	if (!si->si_slots[slot_num].sl_valid)
 		return -ENOENT;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
decompress_bunzip2-off-by-one-in-get_next_block.patch
linux-next.patch

