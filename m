Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CA3C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 26 Dec 2021 22:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhLZWUN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 17:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbhLZWUN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 17:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF04C06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 14:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C3ABB808CD
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 22:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FACC36AE9;
        Sun, 26 Dec 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640557210;
        bh=ea1HIqMO3E1qdlFEPEe0vArGabzMuhDUowRBtHfGRNs=;
        h=Date:From:To:Subject:From;
        b=IL8rQu8wIc5u5r+BdZooLIvcpLZmYxfygal/IBrBWNBblYUMAf/RkksCCx22v2B9C
         fWtABEQCaiyR5CYC4hWiS6Syo83pgn4+t3Wbicq7gXV81cliYGuUkraWOILnWqVo0U
         Y4uSQ/9lPj79Gku1Rs3UzSYnlqCsMdPHPBPGokks=
Date:   Sun, 26 Dec 2021 14:20:10 -0800
From:   akpm@linux-foundation.org
To:     danielmicay@gmail.com, keescook@chromium.org,
        levente@leventepolyak.net, mm-commits@vger.kernel.org,
        thibaut.sautereau@ssi.gouv.fr
Subject:  [merged]
 mm-page_alloc-fix-__alloc_size-attribute-for-alloc_pages_exact_nid.patch
 removed from -mm tree
Message-ID: <20211226222010.2WRNlZX4D%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix __alloc_size attribute for alloc_pages_exact_nid
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-__alloc_size-attribute-for-alloc_pages_exact_nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Subject: mm/page_alloc: fix __alloc_size attribute for alloc_pages_exact_nid

The second parameter of alloc_pages_exact_nid is the one indicating the
size of memory pointed by the returned pointer.

Link: https://lkml.kernel.org/r/YbjEgwhn4bGblp//@coeus
Fixes: abd58f38dfb4 ("mm/page_alloc: add __alloc_size attributes for better bounds checking")
Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Levente Polyak <levente@leventepolyak.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-page_alloc-fix-__alloc_size-attribute-for-alloc_pages_exact_nid
+++ a/include/linux/gfp.h
@@ -624,7 +624,7 @@ extern unsigned long get_zeroed_page(gfp
 
 void *alloc_pages_exact(size_t size, gfp_t gfp_mask) __alloc_size(1);
 void free_pages_exact(void *virt, size_t size);
-__meminit void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask) __alloc_size(1);
+__meminit void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask) __alloc_size(2);
 
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask), 0)
_

Patches currently in -mm which might be from thibaut.sautereau@ssi.gouv.fr are


