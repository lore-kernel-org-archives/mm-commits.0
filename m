From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-debug_pagealloc-dont-rely-on-static-keys-too-early-fix.patch removed from
 -mm tree
Date: Mon, 13 Jan 2020 16:22:23 -0800
Message-ID: <20200114002223.YqeTZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgANAWY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 19:22:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, sfr@canb.auug.org.au


The patch titled
     Subject: mm-debug_pagealloc-dont-rely-on-static-keys-too-early-fix
has been removed from the -mm tree.  Its filename was
     mm-debug_pagealloc-dont-rely-on-static-keys-too-early-fix.patch

This patch was dropped because it was folded into mm-debug_pagealloc-dont-rely-on-static-keys-too-early.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm-debug_pagealloc-dont-rely-on-static-keys-too-early-fix

need to export _debug_pagealloc_enabled_early

Link: http://lkml.kernel.org/r/20200106164944.063ac07b@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-debug_pagealloc-dont-rely-on-static-keys-too-early-fix
+++ a/mm/page_alloc.c
@@ -696,6 +696,7 @@ unsigned int _debug_guardpage_minorder;
 
 bool _debug_pagealloc_enabled_early __read_mostly
 			= IS_ENABLED(CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT);
+EXPORT_SYMBOL(_debug_pagealloc_enabled_early);
 DEFINE_STATIC_KEY_FALSE(_debug_pagealloc_enabled);
 EXPORT_SYMBOL(_debug_pagealloc_enabled);
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-debug_pagealloc-dont-rely-on-static-keys-too-early.patch
