From: akpm@linux-foundation.org
Subject: [patch 036/117] mm/slub.c: fix sysfs filename in comment
Date: Thu, 19 May 2016 17:10:43 -0700
Message-ID: <573e5603.3xPJdIqk8Hq9w4AI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbcETAKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, lip@dtdream.com, cl@linux.com

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
