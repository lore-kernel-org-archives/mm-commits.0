Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AD3C07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E161A61C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhGFTWn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhGFTWm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C265961A14;
        Tue,  6 Jul 2021 19:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599204;
        bh=fWQAuCgWaogi9LqA0tJImuqbJfYXC3rRFzjnw+NvUA8=;
        h=Date:From:To:Subject:From;
        b=MsTikgs77oRP3yZaajUdPtEM5Sq+whyhL6brZWqDaLOOgE1TW5r0EojRI+T/3nuo/
         wWL6jdU16SyuFPdzw/7faAnKvqu990SikiG1h7arLrj4uDDJWJlDltQYCN+TVu3Z6b
         7taaAbmefHSNJw8s3c7KvtwxnVe2aDeuTqOABhf0=
Date:   Tue, 06 Jul 2021 12:20:03 -0700
From:   akpm@linux-foundation.org
To:     chenli@uniontech.com, david@redhat.com, geert@linux-m68k.org,
        gerg@linux-m68k.org, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch removed from -mm tree
Message-ID: <20210706192003.gW7jL1FQ4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nommu: remove __GFP_HIGHMEM in vmalloc/vzalloc
has been removed from the -mm tree.  Its filename was
     nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from chenli@uniontech.com are


