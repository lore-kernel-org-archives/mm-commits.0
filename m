From: akpm@linux-foundation.org
Subject: [folded-merged] zbud-add-to-mm-init-under_reclaim.patch removed
 from -mm tree
Date: Wed, 10 Jul 2013 16:02:28 -0700
Message-ID: <51dde804.DwmYf63KsHXgR8HJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3GJXC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 19:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, bob.liu@oracle.com, sjenning@linux.vnet.ibm.com

Subject: [folded-merged] zbud-add-to-mm-init-under_reclaim.patch removed from -mm tree
To: sjenning@linux.vnet.ibm.com,bob.liu@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 16:02:28 -0700


The patch titled
     Subject: zswap: init under_reclaim
has been removed from the -mm tree.  Its filename was
     zbud-add-to-mm-init-under_reclaim.patch

This patch was dropped because it was folded into zbud-add-to-mm.patch

------------------------------------------------------
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: zswap: init under_reclaim

Bob Liu reported a memory leak in zswap.  This was due to the
under_reclaim field in the zbud header not being initialized
to 0, which resulted in zbud_free() not freeing the page
under the false assumption that the page was undergoing
zbud reclaim.

This patch properly initializes the under_reclaim field.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reported-by: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/zbud.c~zbud-add-to-mm-init-under_reclaim mm/zbud.c
--- a/mm/zbud.c~zbud-add-to-mm-init-under_reclaim
+++ a/mm/zbud.c
@@ -138,6 +138,7 @@ static struct zbud_header *init_zbud_pag
 	zhdr->last_chunks = 0;
 	INIT_LIST_HEAD(&zhdr->buddy);
 	INIT_LIST_HEAD(&zhdr->lru);
+	zhdr->under_reclaim = 0;
 	return zhdr;
 }
 
_

Patches currently in -mm which might be from sjenning@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-to-mm-fix-kconfig-to-depend-on-crypto=y.patch
zswap-add-documentation.patch

