From: akpm@linux-foundation.org
Subject: [merged] vmalloc-remove-redundant-unlikely.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:42 -0800
Message-ID: <201101142248.p0EMmWuo005208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012Ab1ANWsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vmalloc: remove redundant unlikely()
has been removed from the -mm tree.  Its filename was
     vmalloc-remove-redundant-unlikely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: remove redundant unlikely()
From: Tobias Klauser <tklauser@distanz.ch>

IS_ERR() already implies unlikely(), so it can be omitted here.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~vmalloc-remove-redundant-unlikely mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-remove-redundant-unlikely
+++ a/mm/vmalloc.c
@@ -748,7 +748,7 @@ static struct vmap_block *new_vmap_block
 	va = alloc_vmap_area(VMAP_BLOCK_SIZE, VMAP_BLOCK_SIZE,
 					VMALLOC_START, VMALLOC_END,
 					node, gfp_mask);
-	if (unlikely(IS_ERR(va))) {
+	if (IS_ERR(va)) {
 		kfree(vb);
 		return ERR_CAST(va);
 	}
_

Patches currently in -mm which might be from tklauser@distanz.ch are

origin.patch

