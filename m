Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EB5C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbjDRXi4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjDRXg4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A5610262
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 264A663A01
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B652C433D2;
        Tue, 18 Apr 2023 23:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860947;
        bh=sJveDFQRnR6Om4LiBIrz1KkTQo8jcC4WVN/WW/h0hdc=;
        h=Date:To:From:Subject:From;
        b=HRibcUjZpsvFw7EqBxVJQ634MDlHpxPD/8kk3r0zmjL52+Hgaai1d68+ZXjxubsq8
         cCffdnJlEvY8K6QNkLAXZjPgTYK/hYV7w6IKp27WV2YoslVXpddOgZZaNd5hql7nAS
         cIq4OTSUMA9rh+wdY78o3iMOG4SuP6+qmncs3seo=
Date:   Tue, 18 Apr 2023 16:35:46 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        mail.dipanjan.das@gmail.com, hch@infradead.org, elver@google.com,
        dvyukov@google.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-apply-__must_check-to-vmap_pages_range_noflush.patch removed from -mm tree
Message-Id: <20230418233547.7B652C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: apply __must_check to vmap_pages_range_noflush()
has been removed from the -mm tree.  Its filename was
     mm-apply-__must_check-to-vmap_pages_range_noflush.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Marco Elver <elver@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-apply-__must_check-to-vmap_pages_range_noflush
+++ a/mm/internal.h
@@ -885,7 +885,7 @@ size_t splice_folio_into_pipe(struct pip
  */
 #ifdef CONFIG_MMU
 void __init vmalloc_init(void);
-int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                 pgprot_t prot, struct page **pages, unsigned int page_shift);
 #else
 static inline void vmalloc_init(void)
@@ -893,16 +893,16 @@ static inline void vmalloc_init(void)
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


