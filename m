Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF04C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0317A61260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhKKCpy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:45:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234183AbhKKCpy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97C2F6113B;
        Thu, 11 Nov 2021 02:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598585;
        bh=2yXzcqBvXpDxGARsF7QomEurqVKSDC9t1IcBfZKcRYE=;
        h=Date:From:To:Subject:From;
        b=0IQ5xzSDwe5KLJmlIOv13c4EeMcz+LkeaWwZFCwYuSdWoLx8VVNl+DYE3C9iZrBau
         IlAGmDmrMxK+b5ts6uGAxh81/A8hBDrNqPQ2yzFBAi90ExYwXzzyVAzKX9cvNplPew
         i+BdGZQr94AYgbYTZuebCyFtg2+650RvjNqUMcCU=
Date:   Wed, 10 Nov 2021 18:43:05 -0800
From:   akpm@linux-foundation.org
To:     chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch,
        joonas.lahtinen@linux.intel.com, lucas.demarchi@intel.com,
        mm-commits@vger.kernel.org, peterz@infradead.org
Subject:  [merged]
 io-mapping-remove-fallback-for-writecombine.patch removed from -mm tree
Message-ID: <20211111024305.Oa1opeZms%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/io-mapping.h: remove fallback for writecombine
has been removed from the -mm tree.  Its filename was
     io-mapping-remove-fallback-for-writecombine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@intel.com>
Subject: include/linux/io-mapping.h: remove fallback for writecombine

The fallback was introduced in commit 80c33624e472 ("io-mapping: Fixup for
different names of writecombine") to fix the build on microblaze.

5 years later, it seems all archs now provide a pgprot_writecombine(), so
just remove the other possible fallbacks.  For microblaze,
pgprot_writecombine() is available since commit 97ccedd793ac ("microblaze:
Provide pgprot_device/writecombine macros for nommu").

This is build-tested on microblaze with a hack to always build
mm/io-mapping.o and without DIYing on an x86-only macro (_PAGE_CACHE_MASK)

Link: https://lkml.kernel.org/r/20211020204838.1142908-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io-mapping.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/io-mapping.h~io-mapping-remove-fallback-for-writecombine
+++ a/include/linux/io-mapping.h
@@ -132,13 +132,7 @@ io_mapping_init_wc(struct io_mapping *io
 
 	iomap->base = base;
 	iomap->size = size;
-#if defined(pgprot_noncached_wc) /* archs can't agree on a name ... */
-	iomap->prot = pgprot_noncached_wc(PAGE_KERNEL);
-#elif defined(pgprot_writecombine)
 	iomap->prot = pgprot_writecombine(PAGE_KERNEL);
-#else
-	iomap->prot = pgprot_noncached(PAGE_KERNEL);
-#endif
 
 	return iomap;
 }
_

Patches currently in -mm which might be from lucas.demarchi@intel.com are


