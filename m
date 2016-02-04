From: akpm@linux-foundation.org
Subject: + sound-query-dynamic-debug_pagealloc-setting.patch added to -mm
 tree
Date: Thu, 04 Feb 2016 15:43:29 -0800
Message-ID: <56b3e221.zQaGDGpzHCHOa3KI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbcBDXna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:43:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sound: query dynamic DEBUG_PAGEALLOC setting
has been added to the -mm tree.  Its filename is
     sound-query-dynamic-debug_pagealloc-setting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sound-query-dynamic-debug_pagealloc-setting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sound-query-dynamic-debug_pagealloc-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: sound: query dynamic DEBUG_PAGEALLOC setting

We can disable debug_pagealloc processing even if the code is complied
with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
whether it is enabled or not in runtime.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/drivers/pcsp/pcsp.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

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

Patches currently in -mm which might be from js1304@gmail.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slub-support-left-red-zone.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch

