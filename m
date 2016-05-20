From: akpm@linux-foundation.org
Subject: [merged] mm-slubc-fix-sysfs-filename-in-comment.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:03:47 -0700
Message-ID: <573f7bb3.YeohAwRYLwoe931g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lip@dtdream.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: fix sysfs filename in comment
has been removed from the -mm tree.  Its filename was
     mm-slubc-fix-sysfs-filename-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Peng <lip@dtdream.com>
Subject: mm/slub.c: fix sysfs filename in comment

/sys/kernel/slab/xx/defrag_ratio should be remote_node_defrag_ratio.

Link: http://lkml.kernel.org/r/1463449242-5366-1-git-send-email-lip@dtdream.com
Signed-off-by: Li Peng <lip@dtdream.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/slub.c~mm-slubc-fix-sysfs-filename-in-comment mm/slub.c
--- a/mm/slub.c~mm-slubc-fix-sysfs-filename-in-comment
+++ a/mm/slub.c
@@ -1735,11 +1735,11 @@ static void *get_any_partial(struct kmem
 	 * may return off node objects because partial slabs are obtained
 	 * from other nodes and filled up.
 	 *
-	 * If /sys/kernel/slab/xx/defrag_ratio is set to 100 (which makes
-	 * defrag_ratio = 1000) then every (well almost) allocation will
-	 * first attempt to defrag slab caches on other nodes. This means
-	 * scanning over all nodes to look for partial slabs which may be
-	 * expensive if we do it every time we are trying to find a slab
+	 * If /sys/kernel/slab/xx/remote_node_defrag_ratio is set to 100
+	 * (which makes defrag_ratio = 1000) then every (well almost)
+	 * allocation will first attempt to defrag slab caches on other nodes.
+	 * This means scanning over all nodes to look for partial slabs which
+	 * may be expensive if we do it every time we are trying to find a slab
 	 * with available objects.
 	 */
 	if (!s->remote_node_defrag_ratio ||
_

Patches currently in -mm which might be from lip@dtdream.com are


