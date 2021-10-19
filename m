Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA24C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2C5261355
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhJSVmH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 17:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhJSVmH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 17:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6BB3610A3;
        Tue, 19 Oct 2021 21:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634679593;
        bh=GBgJNky+AfL3CWCyCvrPH75p8Q6WxlGnGruLgn0p/VI=;
        h=Date:From:To:Subject:From;
        b=yx4Uo7ZaiCcJkV/VXe6NI8NkgaGqhHhIv6yTn+bMF4fkBhEoLcaWmEppzr0V8HKBH
         rK1bcy6oG8A48CcFKRaPUcd+EL4jysG4Fd3UVR2xYnbOzfRt0C+dexmhGZpv85SWZk
         3jMsMejVw5lT3qvEfQdUOVsWFqncIT7UIclLlc1c=
Date:   Tue, 19 Oct 2021 14:39:53 -0700
From:   akpm@linux-foundation.org
To:     linf@wangsu.com, mm-commits@vger.kernel.org
Subject:  + mm-vmstatc-make-extfrag_index-show-more-pretty.patch
 added to -mm tree
Message-ID: <20211019213953.NQKCuwOZN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat.c: make extfrag_index show more pretty
has been added to the -mm tree.  Its filename is
     mm-vmstatc-make-extfrag_index-show-more-pretty.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstatc-make-extfrag_index-show-more-pretty.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstatc-make-extfrag_index-show-more-pretty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2190,7 +2190,7 @@ static void extfrag_show_print(struct se
 	for (order = 0; order < MAX_ORDER; ++order) {
 		fill_contig_page_info(zone, order, &info);
 		index = __fragmentation_index(order, &info);
-		seq_printf(m, "%d.%03d ", index / 1000, index % 1000);
+		seq_printf(m, "%2d.%03d ", index / 1000, index % 1000);
 	}
 
 	seq_putc(m, '\n');
_

Patches currently in -mm which might be from linf@wangsu.com are

mm-readaheadc-fix-incorrect-comments-for-get_init_ra_size.patch
mm-vmstatc-make-extfrag_index-show-more-pretty.patch

