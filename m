From: akpm@linux-foundation.org
Subject: [merged] gru-handle-blades-without-memory.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:16 -0800
Message-ID: <200912162040.nBGKeGKQ013623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965004AbZLPUkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: handle blades without memory
has been removed from the -mm tree.  Its filename was
     gru-handle-blades-without-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: handle blades without memory
From: Jack Steiner <steiner@sgi.com>

Do not use alloc_pages_exact_node() to allocate GRU tables.  If a blade
has no local memory, nid will be -1.  Use alloc_pages_node() instead.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/sgi-gru/grufile.c~gru-handle-blades-without-memory drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-handle-blades-without-memory
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -266,8 +266,8 @@ static int gru_init_tables(unsigned long
 	max_user_dsr_bytes = GRU_NUM_DSR_BYTES;
 	for_each_possible_blade(bid) {
 		pnode = uv_blade_to_pnode(bid);
-		nid = uv_blade_to_memory_nid(bid);
-		page = alloc_pages_exact_node(nid, GFP_KERNEL, order);
+		nid = uv_blade_to_memory_nid(bid);/* -1 if no memory on blade */
+		page = alloc_pages_node(nid, GFP_KERNEL, order);
 		if (!page)
 			goto fail;
 		gru_base[bid] = page_address(page);
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

