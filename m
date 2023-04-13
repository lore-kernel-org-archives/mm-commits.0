Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D889C77B6E
	for <mm-commits@archiver.kernel.org>; Thu, 13 Apr 2023 21:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjDMVdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Apr 2023 17:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjDMVdZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2023 17:33:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214E22139
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 14:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA52664004
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 21:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54EDC433D2;
        Thu, 13 Apr 2023 21:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681421602;
        bh=WSFg4B5fxR11REF/7QEuD2p2bcS6L1kTXFy94s7Dmus=;
        h=Date:To:From:Subject:From;
        b=1nMicicRv0ijeOjiuM9ggDTeO9u043yeDPmggH+N5qdY96stXu3nrXvzyyr1+iGDA
         jeGW4iN5xyenBjmIc4UXrODXPoX1JbPiN3FD8M6mUogJxACBjMRVkTGRvUZyc6UZGe
         2GxobWJo5gzz3CpzR6WApsC4Q8FziSivn/mVedCU=
Date:   Thu, 13 Apr 2023 14:33:22 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        mail.dipanjan.das@gmail.com, hch@infradead.org, elver@google.com,
        dvyukov@google.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-apply-__must_check-to-vmap_pages_range_noflush.patch added to mm-unstable branch
Message-Id: <20230413213322.D54EDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: apply __must_check to vmap_pages_range_noflush()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-apply-__must_check-to-vmap_pages_range_noflush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-apply-__must_check-to-vmap_pages_range_noflush.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm: apply __must_check to vmap_pages_range_noflush()
Date: Thu, 13 Apr 2023 15:12:23 +0200

To prevent errors when vmap_pages_range_noflush() or
__vmap_pages_range_noflush() silently fail (see the link below for an
example), annotate them with __must_check so that the callers do not
unconditionally assume the mapping succeeded.

Link: https://lkml.kernel.org/r/20230413131223.4135168-4-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Dipanjan Das <mail.dipanjan.das@gmail.com>
  Link: https://lore.kernel.org/linux-mm/CANX2M5ZRrRA64k0hOif02TjmY9kbbO2aCBPyq79es34RXZ=cAw@mail.gmail.com/
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-apply-__must_check-to-vmap_pages_range_noflush
+++ a/mm/internal.h
@@ -906,7 +906,7 @@ size_t splice_folio_into_pipe(struct pip
  */
 #ifdef CONFIG_MMU
 void __init vmalloc_init(void);
-int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                 pgprot_t prot, struct page **pages, unsigned int page_shift);
 #else
 static inline void vmalloc_init(void)
@@ -914,16 +914,16 @@ static inline void vmalloc_init(void)
 }
 
 static inline
-int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                 pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
 	return -EINVAL;
 }
 #endif
 
-int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-			       pgprot_t prot, struct page **pages,
-			       unsigned int page_shift);
+int __must_check __vmap_pages_range_noflush(unsigned long addr,
+			       unsigned long end, pgprot_t prot,
+			       struct page **pages, unsigned int page_shift);
 
 void vunmap_range_noflush(unsigned long start, unsigned long end);
 
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-handle-alloc-failures-in-kmsan_vmap_pages_range_noflush.patch
mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range.patch
mm-kmsan-apply-__must_check-to-non-void-functions.patch
mm-apply-__must_check-to-vmap_pages_range_noflush.patch

