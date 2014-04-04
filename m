From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:01 -0700
Message-ID: <533f0839.ihvHIi3ZM6tlNEds%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbaDDTaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: [merged] ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super.patch removed from -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:01 -0700


The patch titled
     Subject: ocfs2: remove unused variable uuid_net_key in ocfs2_initialize_super
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: joyce.xue <xuejiufei@huawei.com>
Subject: ocfs2: remove unused variable uuid_net_key in ocfs2_initialize_super

Variable uuid_net_key in ocfs2_initialize_super() is not used.  Clean it
up.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ocfs2/super.c~ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super
+++ a/fs/ocfs2/super.c
@@ -2072,7 +2072,6 @@ static int ocfs2_initialize_super(struct
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 	struct inode *inode = NULL;
 	struct ocfs2_journal *journal;
-	__le32 uuid_net_key;
 	struct ocfs2_super *osb;
 	u64 total_blocks;
 
@@ -2306,8 +2305,6 @@ static int ocfs2_initialize_super(struct
 		goto bail;
 	}
 
-	memcpy(&uuid_net_key, di->id2.i_super.s_uuid, sizeof(uuid_net_key));
