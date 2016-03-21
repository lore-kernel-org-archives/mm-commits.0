From: akpm@linux-foundation.org
Subject: [merged] tile-query-dynamic-debug_pagealloc-setting.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:25 -0700
Message-ID: <56f03fa1.wgQCumr6OzC8ziHw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbcCUT4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, penberg@kernel.org, rientjes@google.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: query dynamic DEBUG_PAGEALLOC setting
has been removed from the -mm tree.  Its filename was
     tile-query-dynamic-debug_pagealloc-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: tile: query dynamic DEBUG_PAGEALLOC setting

We can disable debug_pagealloc processing even if the code is compiled
with CONFIG_DEBUG_PAGEALLOC.  This patch changes the code to query whether
it is enabled or not in runtime.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/init.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/tile/mm/init.c~tile-query-dynamic-debug_pagealloc-setting arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~tile-query-dynamic-debug_pagealloc-setting
+++ a/arch/tile/mm/init.c
@@ -896,17 +896,15 @@ void __init pgtable_cache_init(void)
 		panic("pgtable_cache_init(): Cannot create pgd cache");
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-static long __write_once initfree;
-#else
 static long __write_once initfree = 1;
-#endif
+static bool __write_once set_initfree_done;
 
 /* Select whether to free (1) or mark unusable (0) the __init pages. */
 static int __init set_initfree(char *str)
 {
 	long val;
 	if (kstrtol(str, 0, &val) == 0) {
+		set_initfree_done = true;
 		initfree = val;
 		pr_info("initfree: %s free init pages\n",
 			initfree ? "will" : "won't");
@@ -919,6 +917,11 @@ static void free_init_pages(char *what,
 {
 	unsigned long addr = (unsigned long) begin;
 
+	/* Prefer user request first */
+	if (!set_initfree_done) {
+		if (debug_pagealloc_enabled())
+			initfree = 0;
+	}
 	if (kdata_huge && !initfree) {
 		pr_warn("Warning: ignoring initfree=0: incompatible with kdata=huge\n");
 		initfree = 1;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


