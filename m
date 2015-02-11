From: akpm@linux-foundation.org
Subject: [merged] ocfs2-o2net-silence-uninitialized-variable-warning.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:18 -0800
Message-ID: <54dbb9be.rpEyPn1rXwx9kLxb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2net: silence uninitialized variable warning
has been removed from the -mm tree.  Its filename was
     ocfs2-o2net-silence-uninitialized-variable-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: o2net: silence uninitialized variable warning

Smatch complains that, if o2net_tx_can_proceed() returns false, then "sc"
and "ret" are uninialized or maybe we are re-using the data from previous
iteration.  I do not know if we can hit this bug in real life but checking
the return value is harmless and we may as well silence the static checker
warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-silence-uninitialized-variable-warning fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-silence-uninitialized-variable-warning
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1016,7 +1016,8 @@ void o2net_fill_node_map(unsigned long *
 
 	memset(map, 0, bytes);
 	for (node = 0; node < O2NM_MAX_NODES; ++node) {
-		o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret);
+		if (!o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret))
+			continue;
 		if (!ret) {
 			set_bit(node, map);
 			sc_put(sc);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
slab-embed-memcg_cache_params-to-kmem_cache-fix.patch
checkpatch-try-to-avoid-poor-patch-subject-lines.patch
eventfd-dont-take-the-spinlock-in-eventfd_poll-fix-2.patch
linux-next.patch

