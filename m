From: akpm@linux-foundation.org
Subject: [merged] ocfs2-use-find_last_bit.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:22 -0700
Message-ID: <20120820195623.16D1E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:42094 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2HTT4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:25 -0400
Received: by faem1 with SMTP id m1so221140fae.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-use-find_last_bit fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-use-find_last_bit
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -956,23 +956,9 @@ out:
 	return changed;
 }
 
-/* This could be faster if we just implmented a find_last_bit, but I
- * don't think the circumstances warrant it. */
-static int o2hb_highest_node(unsigned long *nodes,
-			     int numbits)
-{
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
