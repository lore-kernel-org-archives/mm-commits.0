From: akpm@linux-foundation.org
Subject: - fix-x86_64-mm-cpa-clflush.patch removed from -mm tree
Date: Wed, 19 Sep 2007 22:19:59 -0700
Message-ID: <200709200520.l8K5Jxfb029632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbXITFUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 01:20:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@suse.de, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Flush uncached AGP pages before freeing
has been removed from the -mm tree.  Its filename was
     fix-x86_64-mm-cpa-clflush.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Flush uncached AGP pages before freeing
From: Andi Kleen <andi@firstfloor.org>

Flush uncached AGP pages before freeing

Signed-off-by: Andi Kleen <ak@suse.de>
Tested-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/generic.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/char/agp/generic.c~fix-x86_64-mm-cpa-clflush drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~fix-x86_64-mm-cpa-clflush
+++ a/drivers/char/agp/generic.c
@@ -1185,6 +1185,7 @@ void agp_generic_destroy_page(void *addr
 
 	page = virt_to_page(addr);
 	unmap_page_from_agp(page);
+	flush_agp_mappings();
 	put_page(page);
 	free_page((unsigned long)addr);
 	atomic_dec(&agp_bridge->current_memory_agp);
_

Patches currently in -mm which might be from andi@firstfloor.org are

introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
fix-x86_64-mm-cpa-clflush.patch
readahead-compacting-file_ra_state.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
