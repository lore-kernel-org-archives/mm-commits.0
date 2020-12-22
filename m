Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55DABC43381
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 19:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DFF423137
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 19:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgLVTRI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 14:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgLVTRI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 14:17:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC76A23137;
        Tue, 22 Dec 2020 19:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608664587;
        bh=a6wawslk0n/8FxHDNVI+eUFUW/khDUMZT25Ol50z8og=;
        h=Date:From:To:Subject:From;
        b=PnGwc8SiBo/LFFD1z+ErWJ6+Dx/ionyUKNoXce6R6nlyTp6OOW4oir8Q2FpXYMLYX
         a92okirP0iy4yhDoerX8kPpr1TV9vF9obRu6+zcSVzwTlfUtDSrJva9udlzFNyu4kW
         huS4tkqR2KqLp41hcwUiUUGlELdRDO1hX1wjkALw=
Date:   Tue, 22 Dec 2020 11:16:27 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jrdr.linux@gmail.com,
        alex.shi@linux.alibaba.com, akpm@linux-foundation.org
Subject:  + mm-add-prototype-for-__add_to_page_cache_locked-fix.patch
 added to -mm tree
Message-ID: <20201222191627.GTVYZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-prototype-for-__add_to_page_cache_locked-fix
has been added to the -mm tree.  Its filename is
     mm-add-prototype-for-__add_to_page_cache_locked-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-prototype-for-__add_to_page_cache_locked-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-prototype-for-__add_to_page_cache_locked-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-prototype-for-__add_to_page_cache_locked-fix

tweak comment grammar

Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-add-prototype-for-__add_to_page_cache_locked-fix
+++ a/include/linux/mm.h
@@ -217,8 +217,8 @@ int overcommit_kbytes_handler(struct ctl
 int overcommit_policy_handler(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
 /*
- * Any attempt to mark this function as static leads to build failure
- * for few architectures. Adding a prototype to silence gcc warning.
+ * Marking this function as static leads to build failures for a few
+ * architectures.  The prototype silences a gcc warning.
  */
 int __add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 		pgoff_t offset, gfp_t gfp, void **shadowp);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-prototype-for-__add_to_page_cache_locked-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

