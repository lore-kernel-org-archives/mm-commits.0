From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:08:04 -0700
Message-ID: <552eb714.vFztD1L4rWagTwFs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbDOTIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: avoid a pointless delay in o2cb_cluster_check()
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: ocfs2: avoid a pointless delay in o2cb_cluster_check()

Fix an off-by-one when attempting to avoid an msleep() on the final loop
iteration.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_o2cb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/stack_o2cb.c~ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check fs/ocfs2/stack_o2cb.c
--- a/fs/ocfs2/stack_o2cb.c~ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check
+++ a/fs/ocfs2/stack_o2cb.c
@@ -295,7 +295,7 @@ static int o2cb_cluster_check(void)
 		set_bit(node_num, netmap);
 		if (!memcmp(hbmap, netmap, sizeof(hbmap)))
 			return 0;
-		if (i < O2CB_MAP_STABILIZE_COUNT)
+		if (i < O2CB_MAP_STABILIZE_COUNT - 1)
 			msleep(1000);
 	}
 
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

origin.patch

