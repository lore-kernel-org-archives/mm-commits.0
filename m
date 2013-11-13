From: akpm@linux-foundation.org
Subject: [merged] ocfs2-use-find_last_bit.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:24 -0800
Message-ID: <5283e304.OqIAulyodbpEHCrg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3KMUhY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, akinobu.mita@gmail.com

Subject: [merged] ocfs2-use-find_last_bit.patch removed from -mm tree
To: akinobu.mita@gmail.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:24 -0800


The patch titled
     Subject: ocfs2: use find_last_bit()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-find_last_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ocfs2: use find_last_bit()

We already have find_last_bit().  So just use it as described in the
comment.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-use-find_last_bit fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-use-find_last_bit
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -946,23 +946,9 @@ out:
 	return changed;
 }
 
-/* This could be faster if we just implmented a find_last_bit, but I
- * don't think the circumstances warrant it. */
-static int o2hb_highest_node(unsigned long *nodes,
-			     int numbits)
+static int o2hb_highest_node(unsigned long *nodes, int numbits)
 {
-	int highest, node;
-
-	highest = numbits;
-	node = -1;
-	while ((node = find_next_bit(nodes, numbits, node + 1)) != -1) {
-		if (node >= numbits)
-			break;
-
-		highest = node;
-	}
