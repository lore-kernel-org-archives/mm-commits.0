Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED331C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 01:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D624463212
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 01:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345452AbhKPB01 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 20:26:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378769AbhKPBWJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 20:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE6B61104;
        Tue, 16 Nov 2021 01:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637025552;
        bh=KNXfOI1ksCArY6BDlwnCyBfyC5wUb87cBIMe28wL+zE=;
        h=Date:From:To:Subject:From;
        b=z6/3Nvpi41jNrFqiDm4Y4BbEjunE60blppk+y81NKRSWj8eEWIQEVF3imN2MOmoUj
         4i3+6ZKFBn+ewltirWGZvTGeG+1S/d4Sj2CAFbdJGi1mXE7wWm+NhP5/lUiA6WQmw6
         JSUmB4PVwx2mazgrmJx3/mnTYiIaEDpRzVahIjcQ=
Date:   Mon, 15 Nov 2021 17:19:12 -0800
From:   akpm@linux-foundation.org
To:     hanyihao@vivo.com, mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com
Subject:  +
 mm-damon-vaddr-remove-swap_ranges-and-replace-it-with-swap.patch added to
 -mm tree
Message-ID: <20211116011912.NfzpIGMiK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: remove swap_ranges() and replace it with swap()
has been added to the -mm tree.  Its filename is
     mm-damon-vaddr-remove-swap_ranges-and-replace-it-with-swap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-vaddr-remove-swap_ranges-and-replace-it-with-swap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-vaddr-remove-swap_ranges-and-replace-it-with-swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yihao Han <hanyihao@vivo.com>
Subject: mm/damon/vaddr: remove swap_ranges() and replace it with swap()

Remove 'swap_ranges()' and replace it with the macro 'swap()' defined in
'include/linux/minmax.h' to simplify code and improve efficiency

Link: https://lkml.kernel.org/r/20211111115355.2808-1-hanyihao@vivo.com
Signed-off-by: Yihao Han <hanyihao@vivo.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-remove-swap_ranges-and-replace-it-with-swap
+++ a/mm/damon/vaddr.c
@@ -97,16 +97,6 @@ static unsigned long sz_range(struct dam
 	return r->end - r->start;
 }
 
-static void swap_ranges(struct damon_addr_range *r1,
-			struct damon_addr_range *r2)
-{
-	struct damon_addr_range tmp;
-
-	tmp = *r1;
-	*r1 = *r2;
-	*r2 = tmp;
-}
-
 /*
  * Find three regions separated by two biggest unmapped regions
  *
@@ -145,9 +135,9 @@ static int __damon_va_three_regions(stru
 		gap.start = last_vma->vm_end;
 		gap.end = vma->vm_start;
 		if (sz_range(&gap) > sz_range(&second_gap)) {
-			swap_ranges(&gap, &second_gap);
+			swap(gap, second_gap);
 			if (sz_range(&second_gap) > sz_range(&first_gap))
-				swap_ranges(&second_gap, &first_gap);
+				swap(second_gap, first_gap);
 		}
 next:
 		last_vma = vma;
@@ -158,7 +148,7 @@ next:
 
 	/* Sort the two biggest gaps by address */
 	if (first_gap.start > second_gap.start)
-		swap_ranges(&first_gap, &second_gap);
+		swap(first_gap, second_gap);
 
 	/* Store the result */
 	regions[0].start = ALIGN(start, DAMON_MIN_REGION);
_

Patches currently in -mm which might be from hanyihao@vivo.com are

mm-damon-vaddr-remove-swap_ranges-and-replace-it-with-swap.patch

