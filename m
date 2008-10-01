From: akpm@linux-foundation.org
Subject: - ehea-fix-dlpar-memory-handling.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:37 -0700
Message-ID: <200810012152.m91Lqbjr006069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956AbYJAVwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:52:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes.hering@gmx.de, hering2@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ehea: fix DLPAR memory handling
has been removed from the -mm tree.  Its filename was
     ehea-fix-dlpar-memory-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ehea: fix DLPAR memory handling
From: Hannes Hering <hannes.hering@gmx.de>

The ehea busmap must be allocated only once in the first of many calls of the
ehea_create_busmap_callback.

Signed-off-by: Hannes Hering <hering2@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_qmr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/ehea/ehea_qmr.c~ehea-fix-dlpar-memory-handling drivers/net/ehea/ehea_qmr.c
--- a/drivers/net/ehea/ehea_qmr.c~ehea-fix-dlpar-memory-handling
+++ a/drivers/net/ehea/ehea_qmr.c
@@ -595,7 +595,8 @@ static int ehea_create_busmap_callback(u
 	end_section = start_section + ((nr_pages * PAGE_SIZE) / EHEA_SECTSIZE);
 	mr_len = *(unsigned long *)arg;
 
-	ehea_bmap = kzalloc(sizeof(struct ehea_bmap), GFP_KERNEL);
+	if (!ehea_bmap)
+		ehea_bmap = kzalloc(sizeof(struct ehea_bmap), GFP_KERNEL);
 	if (!ehea_bmap)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from hannes.hering@gmx.de are

git-net.patch

