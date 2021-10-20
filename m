Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F86C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 21:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C6D61284
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 21:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhJTVH6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhJTVH5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 17:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C0861215;
        Wed, 20 Oct 2021 21:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634763942;
        bh=+5DAi8ziTx+1doeR4PsOU9zELbdnaKcdYH9UjlZTRC0=;
        h=Date:From:To:Subject:From;
        b=2okvflP1LULNMeCQVbUrucxFILyjfq8/vgjGzPdNjyNgGUvDTdwOTwqiymzChc2n4
         3HRQEk6Pwyz4PWptivIec0K4om6i5/InrtaRwd3EWiJD3Mc5QHV33bimEL6F0IUHnu
         FRBVs+OTR/sEYmWk9yqFlp94JrdSVbBcqgkkX1g8=
Date:   Wed, 20 Oct 2021 14:05:42 -0700
From:   akpm@linux-foundation.org
To:     chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch,
        joonas.lahtinen@linux.intel.com, lucas.demarchi@intel.com,
        mm-commits@vger.kernel.org, peterz@infradead.org
Subject:  + io-mapping-remove-fallback-for-writecombine.patch added
 to -mm tree
Message-ID: <20211020210542.s_EPDoZ77%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/io-mapping.h: remove fallback for writecombine
has been added to the -mm tree.  Its filename is
     io-mapping-remove-fallback-for-writecombine.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/io-mapping-remove-fallback-for-writecombine.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/io-mapping-remove-fallback-for-writecombine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

io-mapping-remove-fallback-for-writecombine.patch
lib-string_helpers-add-linux-stringh-for-strlen.patch

