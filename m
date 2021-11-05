Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01E4C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB10C60FBF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhKEUlv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233407AbhKEUlu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83BF66056B;
        Fri,  5 Nov 2021 20:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144750;
        bh=p6w+94iaxs7+r544PijRic/QocSyQwil4huhbWvkmJM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jbwechSTOKscOUsBf5zT7zlLyDCobpI1l2xFl3Ky0D1ss/M63QU48lkPaVV/2eA1R
         +ZUqNqx19ewOG/8k+Li1CsMeSSNw9e+I0uIVktWyKGHwTHR/pDycahOm7Skkl+74RN
         pYwZuoDSUvhPJ+/yrK7P9Ro7N0e/w5QaEOLQe+kU=
Date:   Fri, 05 Nov 2021 13:39:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chris-wilson.co.uk,
        daniel.vetter@ffwll.ch, joonas.lahtinen@linux.intel.com,
        linux-mm@kvack.org, lucas.demarchi@intel.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 086/262] include/linux/io-mapping.h: remove
 fallback for writecombine
Message-ID: <20211105203910.DxiEtivZD%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
