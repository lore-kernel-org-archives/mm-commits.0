From: akpm@linux-foundation.org
Subject: + ocfs2-use-find_last_bit.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:12:51 -0800
Message-ID: <20120120231252.36F931E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:41736 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab2ATXMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:12:53 -0500
Received: by ggnv2 with SMTP id v2so90974ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:12:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, jlbec@evilplan.org, mfasheh@suse.com


The patch titled
     Subject: ocfs2: use find_last_bit()
has been added to the -mm tree.  Its filename is
     ocfs2-use-find_last_bit.patch

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
