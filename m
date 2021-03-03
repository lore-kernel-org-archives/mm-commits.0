Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47E0C4332E
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A39964EAE
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381772AbhCCNam (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:30:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235770AbhCCAiO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 19:38:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC25C64F8C;
        Wed,  3 Mar 2021 00:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614731847;
        bh=H63Irf4PNVj3/LnHj2Xp+iHYJkW4dv6NGwh9Q42aJA8=;
        h=Date:From:To:Subject:From;
        b=phoicCTIZ1YnGhl8+LMQiy8vQS2aGhozPa4Ea3ROKQBW89rkpXYKuSNXaFiT2VDMZ
         3NM7DgAl39MEfn0qHxE8G9jfcrWNtBXJmOT7PuCUir3SS2MUI+vJBz6w1TB2jbHCht
         435PqZY0xPYBnyHcFDJmsnVdEQNN+2SNxk+XEG5g=
Date:   Tue, 02 Mar 2021 16:37:26 -0800
From:   akpm@linux-foundation.org
To:     hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, willy@infradead.org
Subject:  + fix-zero_user_segments-with-start-end.patch added to
 -mm tree
Message-ID: <20210303003726.QmywxY2fs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem.c: fix zero_user_segments() with start > end
has been added to the -mm tree.  Its filename is
     fix-zero_user_segments-with-start-end.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fix-zero_user_segments-with-start-end.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fix-zero_user_segments-with-start-end.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: mm/highmem.c: fix zero_user_segments() with start > end

zero_user_segments() is used from __block_write_begin_int(), for example
like the following

	zero_user_segments(page, 4096, 1024, 512, 918)

But new the zero_user_segments() implementation for for HIGHMEM +
TRANSPARENT_HUGEPAGE doesn't handle "start > end" case correctly, and hits
BUG_ON().  (we can fix __block_write_begin_int() instead though, it is the
old and multiple usage)

Also it calls kmap_atomic() unnecessarily while start == end == 0.

Link: https://lkml.kernel.org/r/87v9ab60r4.fsf@mail.parknet.co.jp
Fixes: 0060ef3b4e6d ("mm: support THPs in zero_user_segments")
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/highmem.c~fix-zero_user_segments-with-start-end
+++ a/mm/highmem.c
@@ -368,20 +368,24 @@ void zero_user_segments(struct page *pag
 
 	BUG_ON(end1 > page_size(page) || end2 > page_size(page));
 
+	if (start1 >= end1)
+		start1 = end1 = 0;
+	if (start2 >= end2)
+		start2 = end2 = 0;
+
 	for (i = 0; i < compound_nr(page); i++) {
 		void *kaddr = NULL;
 
-		if (start1 < PAGE_SIZE || start2 < PAGE_SIZE)
-			kaddr = kmap_atomic(page + i);
-
 		if (start1 >= PAGE_SIZE) {
 			start1 -= PAGE_SIZE;
 			end1 -= PAGE_SIZE;
 		} else {
 			unsigned this_end = min_t(unsigned, end1, PAGE_SIZE);
 
-			if (end1 > start1)
+			if (end1 > start1) {
+				kaddr = kmap_atomic(page + i);
 				memset(kaddr + start1, 0, this_end - start1);
+			}
 			end1 -= this_end;
 			start1 = 0;
 		}
@@ -392,8 +396,11 @@ void zero_user_segments(struct page *pag
 		} else {
 			unsigned this_end = min_t(unsigned, end2, PAGE_SIZE);
 
-			if (end2 > start2)
+			if (end2 > start2) {
+				if (!kaddr)
+					kaddr = kmap_atomic(page + i);
 				memset(kaddr + start2, 0, this_end - start2);
+			}
 			end2 -= this_end;
 			start2 = 0;
 		}
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fix-zero_user_segments-with-start-end.patch

