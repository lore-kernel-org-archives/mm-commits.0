From: akpm@linux-foundation.org
Subject: [merged] relay-fix-for-possible-loss-corruption-of-produced-subbufs.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:13 -0700
Message-ID: <200904061937.n36JbDU0012813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754267AbZDFUMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:12:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raa.aars@gmail.com, tzanussi@gmail.com, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     relay: fix for possible loss/corruption of produced subbufs
has been removed from the -mm tree.  Its filename was
     relay-fix-for-possible-loss-corruption-of-produced-subbufs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: relay: fix for possible loss/corruption of produced subbufs
From: Aravind Srinivasan <raa.aars@gmail.com>

Fix possible loss/corruption of produced subbufs in
relay_subbufs_consumed().

When buf->subbufs_produced wraps around after UINT_MAX and
buf->subbufs_consumed is still < UINT_MAX, the condition

	if (buf->subbufs_consumed > buf->subbufs_produced)

will be true even for certain valid values of subbufs_consumed.  This may
lead to loss or corruption of produced subbufs.

Signed-off-by: Aravind Srinivasan <raa.aars@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/relay.c~relay-fix-for-possible-loss-corruption-of-produced-subbufs kernel/relay.c
--- a/kernel/relay.c~relay-fix-for-possible-loss-corruption-of-produced-subbufs
+++ a/kernel/relay.c
@@ -797,13 +797,15 @@ void relay_subbufs_consumed(struct rchan
 	if (!chan)
 		return;
 
-	if (cpu >= NR_CPUS || !chan->buf[cpu])
+	if (cpu >= NR_CPUS || !chan->buf[cpu] ||
+					subbufs_consumed > chan->n_subbufs)
 		return;
 
 	buf = chan->buf[cpu];
-	buf->subbufs_consumed += subbufs_consumed;
-	if (buf->subbufs_consumed > buf->subbufs_produced)
+	if (subbufs_consumed > buf->subbufs_produced - buf->subbufs_consumed)
 		buf->subbufs_consumed = buf->subbufs_produced;
+	else
+		buf->subbufs_consumed += subbufs_consumed;
 }
 EXPORT_SYMBOL_GPL(relay_subbufs_consumed);
 
_

Patches currently in -mm which might be from raa.aars@gmail.com are

origin.patch

