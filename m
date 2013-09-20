From: akpm@linux-foundation.org
Subject: + ocfs2-use-find_last_bit.patch added to -mm tree
Date: Fri, 20 Sep 2013 13:50:16 -0700
Message-ID: <523cb508.flYVPWPmlt+qhN7a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3ITUuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 16:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, akinobu.mita@gmail.com

Subject: + ocfs2-use-find_last_bit.patch added to -mm tree
To: akinobu.mita@gmail.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 13:50:16 -0700


The patch titled
     Subject: ocfs2: use find_last_bit()
has been added to the -mm tree.  Its filename is
     ocfs2-use-find_last_bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-find_last_bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-find_last_bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
