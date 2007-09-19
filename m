From: akpm@linux-foundation.org
Subject: + fix-x86_64-mm-cpa-clflush.patch added to -mm tree
Date: Wed, 19 Sep 2007 14:38:43 -0700
Message-ID: <200709192138.l8JLcijq012521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520AbXISVi5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 17:38:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@suse.de, jirislaby@gmail.com


The patch titled
     Flush uncached AGP pages before freeing
has been added to the -mm tree.  Its filename is
     fix-x86_64-mm-cpa-clflush.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
