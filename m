From: akpm@linux-foundation.org
Subject: [folded-merged]
 sound-query-dynamic-debug_pagealloc-setting-fix.patch removed from -mm tree
Date: Thu, 17 Mar 2016 13:50:40 -0700
Message-ID: <56eb18a0.F0gemJa9+Ms5XML7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935675AbcCQUul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:50:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sound-query-dynamic-debug_pagealloc-setting-fix
has been removed from the -mm tree.  Its filename was
     sound-query-dynamic-debug_pagealloc-setting-fix.patch

This patch was dropped because it was folded into sound-query-dynamic-debug_pagealloc-setting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sound-query-dynamic-debug_pagealloc-setting-fix

export _debug_pagealloc_enabled to modules

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~sound-query-dynamic-debug_pagealloc-setting-fix mm/page_alloc.c
--- a/mm/page_alloc.c~sound-query-dynamic-debug_pagealloc-setting-fix
+++ a/mm/page_alloc.c
@@ -498,6 +498,7 @@ void prep_compound_page(struct page *pag
 unsigned int _debug_guardpage_minorder;
 bool _debug_pagealloc_enabled __read_mostly
 			= IS_ENABLED(CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT);
+EXPORT_SYMBOL(_debug_pagealloc_enabled);
 bool _debug_guardpage_enabled __read_mostly;
 
 static int __init early_debug_pagealloc(char *buf)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sound-query-dynamic-debug_pagealloc-setting.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sscanf-implement-basic-character-sets-fix.patch

