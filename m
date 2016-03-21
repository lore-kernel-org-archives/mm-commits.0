From: akpm@linux-foundation.org
Subject: [merged] sound-query-dynamic-debug_pagealloc-setting.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:20 -0700
Message-ID: <56f03f9c.2Hln+0i79nw5IfiW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525AbcCUT4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, penberg@kernel.org, rientjes@google.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sound: query dynamic DEBUG_PAGEALLOC setting
has been removed from the -mm tree.  Its filename was
     sound-query-dynamic-debug_pagealloc-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: sound: query dynamic DEBUG_PAGEALLOC setting

We can disable debug_pagealloc processing even if the code is compiled
with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
whether it is enabled or not in runtime.

[akpm@linux-foundation.org: export _debug_pagealloc_enabled to modules]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c           |    1 +
 sound/drivers/pcsp/pcsp.c |    9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~sound-query-dynamic-debug_pagealloc-setting mm/page_alloc.c
--- a/mm/page_alloc.c~sound-query-dynamic-debug_pagealloc-setting
+++ a/mm/page_alloc.c
@@ -498,6 +498,7 @@ void prep_compound_page(struct page *pag
 unsigned int _debug_guardpage_minorder;
 bool _debug_pagealloc_enabled __read_mostly
 			= IS_ENABLED(CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT);
+EXPORT_SYMBOL(_debug_pagealloc_enabled);
 bool _debug_guardpage_enabled __read_mostly;
 
 static int __init early_debug_pagealloc(char *buf)
diff -puN sound/drivers/pcsp/pcsp.c~sound-query-dynamic-debug_pagealloc-setting sound/drivers/pcsp/pcsp.c
--- a/sound/drivers/pcsp/pcsp.c~sound-query-dynamic-debug_pagealloc-setting
+++ a/sound/drivers/pcsp/pcsp.c
@@ -14,6 +14,7 @@
 #include <linux/input.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
+#include <linux/mm.h>
 #include "pcsp_input.h"
 #include "pcsp.h"
 
@@ -148,11 +149,11 @@ static int alsa_card_pcsp_init(struct de
 		return err;
 	}
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 	/* Well, CONFIG_DEBUG_PAGEALLOC makes the sound horrible. Lets alert */
-	printk(KERN_WARNING "PCSP: CONFIG_DEBUG_PAGEALLOC is enabled, "
-	       "which may make the sound noisy.\n");
-#endif
+	if (debug_pagealloc_enabled()) {
+		printk(KERN_WARNING "PCSP: CONFIG_DEBUG_PAGEALLOC is enabled, "
+		       "which may make the sound noisy.\n");
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


