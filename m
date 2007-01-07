From: akpm@osdl.org
Subject: - sanely-size-hash-tables-when-using-large-base-pages-take-2.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:39 -0800
Message-ID: <200701070758.l077wdU8012969@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40760 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbXAGH6n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Sanely size hash tables when using large base pages
has been removed from the -mm tree.  Its filename was
     sanely-size-hash-tables-when-using-large-base-pages-take-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Sanely size hash tables when using large base pages
From: Paul Mundt <lethal@linux-sh.org>

At the moment the inode/dentry cache hash tables (common by way of
alloc_large_system_hash()) are incorrectly sized by their respective
detection logic when we attempt to use large base pages on systems with
little memory.

This results in odd behaviour when using a 64kB PAGE_SIZE, such as:

Dentry cache hash table entries: 8192 (order: -1, 32768 bytes)
Inode-cache hash table entries: 4096 (order: -2, 16384 bytes)

The mount cache hash table is seemingly the only one that gets this right
by directly taking PAGE_SIZE in to account.

The following patch attempts to catch the bogus values and round it up to
at least 0-order.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~sanely-size-hash-tables-when-using-large-base-pages-take-2 mm/page_alloc.c
--- a/mm/page_alloc.c~sanely-size-hash-tables-when-using-large-base-pages-take-2
+++ a/mm/page_alloc.c
@@ -3321,6 +3321,10 @@ void *__init alloc_large_system_hash(con
 			numentries >>= (scale - PAGE_SHIFT);
 		else
 			numentries <<= (PAGE_SHIFT - scale);
+
+		/* Make sure we've got at least a 0-order allocation.. */
+		if (unlikely((numentries * bucketsize) < PAGE_SIZE))
+			numentries = PAGE_SIZE / bucketsize;
 	}
 	numentries = roundup_pow_of_two(numentries);
 
_

Patches currently in -mm which might be from lethal@linux-sh.org are

git-avr32.patch
git-sh.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
remove-zone_dma-remains-from-sh-sh64.patch
