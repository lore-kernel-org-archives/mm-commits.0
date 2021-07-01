Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E859C11F6C
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8537861474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbhGAByo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238486AbhGAByo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80F0A61469;
        Thu,  1 Jul 2021 01:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104334;
        bh=TZ02/5BRV3MVGz6H7yhrD7JgNllspAGhg7ulbsDIIws=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PchLKqP2i/PEF2rI96lR7wqUsu8+5uR7IJpmpfbGKZkZB1j51N8WANRroi+Yq4v3p
         9B8pCP7QxtZ3ay+XpPEkLki+n8+mdgkn3nf3z0RVNukGpoJBgU5J0oEG5/s7BQhDYU
         85ybDdPgJwQwRKqoR9VzTmZVxN2oBW7f4CwgQJSc=
Date:   Wed, 30 Jun 2021 18:52:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chenli@uniontech.com, david@redhat.com,
        geert@linux-m68k.org, gerg@linux-m68k.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 095/192] nommu: remove __GFP_HIGHMEM in
 vmalloc/vzalloc
Message-ID: <20210701015214.X6biaOQaV%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chen Li <chenli@uniontech.com>
Subject: nommu: remove __GFP_HIGHMEM in vmalloc/vzalloc

mm/nommu.c:
void *__vmalloc(unsigned long size, gfp_t gfp_mask)
{
	/*
	 *  You can't specify __GFP_HIGHMEM with kmalloc() since kmalloc()
	 * returns only a logical address.
	 */
	return kmalloc(size, (gfp_mask | __GFP_COMP) & ~__GFP_HIGHMEM);
}

nommu's __vmalloc just uses kmalloc internally and elimitates
__GFP_HIGHMEM, so it makes no sense to add __GFP_HIGHMEM for nommu's
vmalloc/vzalloc.

[akpm@linux-foundation.org: coding style fixes]
Link: https://lkml.kernel.org/r/875z00rnp8.wl-chenli@uniontech.com
Signed-off-by: Chen Li <chenli@uniontech.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/nommu.c~nommu-remove-__gfp_highmem-in-vmalloc-vzalloc
+++ a/mm/nommu.c
@@ -223,7 +223,7 @@ long vread(char *buf, char *addr, unsign
  */
 void *vmalloc(unsigned long size)
 {
-       return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM);
+	return __vmalloc(size, GFP_KERNEL);
 }
 EXPORT_SYMBOL(vmalloc);
 
@@ -241,7 +241,7 @@ EXPORT_SYMBOL(vmalloc);
  */
 void *vzalloc(unsigned long size)
 {
-	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
+	return __vmalloc(size, GFP_KERNEL | __GFP_ZERO);
 }
 EXPORT_SYMBOL(vzalloc);
 
_
