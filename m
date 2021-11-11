Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C02C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE79161284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhKKCtx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234393AbhKKCtv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B92161247;
        Thu, 11 Nov 2021 02:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598823;
        bh=URveo9s22vI7aRyfAi9crEkZzeGfqK85sqFeNhWYmPU=;
        h=Date:From:To:Subject:From;
        b=et1fuegwlhG8oHhhTtaVTJBXKtdAxt1DWrVDgiFNhLf4SFBH4p0Vt5d6Ke4DGgRv/
         tReYdJjNhIhbNuBjiz3btfuBfjsWCVXZ/Ua3Irw+sWJ6ix9J9oz7EmdfY2f5HWc9/+
         JKuhxEBIwOCfVqzR/t4yig3wFfar7bZefi+vnTJQ=
Date:   Wed, 10 Nov 2021 18:47:03 -0800
From:   akpm@linux-foundation.org
To:     linf@wangsu.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-vmstatc-make-extfrag_index-show-more-pretty.patch removed from -mm tree
Message-ID: <20211111024703.E4LTK1CEZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat.c: make extfrag_index show more pretty
has been removed from the -mm tree.  Its filename was
     mm-vmstatc-make-extfrag_index-show-more-pretty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lin Feng <linf@wangsu.com>
Subject: mm: vmstat.c: make extfrag_index show more pretty

fragmentation_index may return -1000 and the corresponding formated value
showed by seq_printf will take a negative signatrue, but other positive
formated values don't take a positive signatrue, so the output becomes
unaligned.

before:
Node 0, zone      DMA -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000
Node 0, zone    DMA32 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000
Node 0, zone   Normal -1.000 -1.000 -1.000 -1.000 0.931 0.966 0.983 0.992 0.996 0.998 0.999

after this patch:
Node 0, zone      DMA -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000
Node 0, zone    DMA32 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000
Node 0, zone   Normal -1.000 -1.000 -1.000 -1.000  0.931  0.966  0.983  0.992  0.996  0.998  0.999

Link: https://lkml.kernel.org/r/20211019103241.134797-1-linf@wangsu.com
Signed-off-by: Lin Feng <linf@wangsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstatc-make-extfrag_index-show-more-pretty
+++ a/mm/vmstat.c
@@ -2191,7 +2191,7 @@ static void extfrag_show_print(struct se
 	for (order = 0; order < MAX_ORDER; ++order) {
 		fill_contig_page_info(zone, order, &info);
 		index = __fragmentation_index(order, &info);
-		seq_printf(m, "%d.%03d ", index / 1000, index % 1000);
+		seq_printf(m, "%2d.%03d ", index / 1000, index % 1000);
 	}
 
 	seq_putc(m, '\n');
_

Patches currently in -mm which might be from linf@wangsu.com are


