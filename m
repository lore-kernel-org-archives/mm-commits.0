From: akpm@linux-foundation.org
Subject: +
 ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super.patch
 added to -mm tree
Date: Wed, 19 Feb 2014 14:33:10 -0800
Message-ID: <53053126.fcKiVDtcZydPgKpi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaBSWdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 17:33:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 14:33:10 -0800


The patch titled
     Subject: ocfs2: remove unused variable uuid_net_key in ocfs2_initialize_super
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unused-variable-uuid_net_key-in-ocfs2_initialize_super.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: joyce.xue <xuejiufei@huawei.com>
Subject: ocfs2: remove unused variable uuid_net_key in ocfs2_initialize_super

Variable uuid_net_key in ocfs2_initialize_super() is not used.  Clean it
up.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
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
