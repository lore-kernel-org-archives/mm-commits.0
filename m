Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9117DC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 696FD2072D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598305875;
	bh=4/xN+Ao0pi0S9RjPc3tVWQ37Wq0ApUmJjiMZluVgmVA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SquqpIha1wq+S2VmPV2jN7pf8Z3TSCwvYPSzZPWwvO0lyfN7OVwddtfrqu5UhnUV7
	 a1S1Roi4JtyuCnMDVaorkYzb61AkNU3ihiN9D1uefSghciUzZGO+4Ax3FHo8A+fpct
	 DIzAad+rFySt2d+LnHfZlVdKwXoAAStYyk2S2FFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHXVvP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXVvO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 17:51:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1581204EA;
        Mon, 24 Aug 2020 21:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598305874;
        bh=4/xN+Ao0pi0S9RjPc3tVWQ37Wq0ApUmJjiMZluVgmVA=;
        h=Date:From:To:Subject:From;
        b=K3ONjU7ujxmR3Aux+WkMg/Hpq351r37BHpqaQMirFH0bsl8uELPbUfzxW8TbnSrCe
         n0eFYjg8HCiA9F6O6WkzI+iTMOO8jyiUlzmZQcYkjlkakrP85hM6ruBRRkXAZHPU8z
         Rgj1K1dDk0G3xj/QD3S3zHqejqSMW3unu4eS+tIs=
Date:   Mon, 24 Aug 2020 14:51:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-move-pagedoublemap-bit.patch added to -mm tree
Message-ID: <20200824215113.ItdBXyNor%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move PageDoubleMap bit
has been added to the -mm tree.  Its filename is
     mm-move-pagedoublemap-bit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-pagedoublemap-bit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-pagedoublemap-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move PageDoubleMap bit

Patch series "Fix PageDoubleMap".

This is a purely theoretical problem for now as none of the filesystems
which use PG_private_2 (ie PG_fscache) are being converted at this time,
but it's confusing to leave it like this.


This patch (of 2):

PG_private_2 is defined as being PF_ANY (applicable to tail pages as well
as regular & head pages).  That means that the first tail page of a
double-map page will appear to have Private2 set.  Use the Workingset bit
instead which is defined as PF_HEAD so any attempt to access the
Workingset bit on a tail page will redirect to the head page's Workingset
bit.

Link: https://lkml.kernel.org/r/20200629151933.15671-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200629151933.15671-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-move-pagedoublemap-bit
+++ a/include/linux/page-flags.h
@@ -164,7 +164,7 @@ enum pageflags {
 	PG_slob_free = PG_private,
 
 	/* Compound pages. Stored in first tail page's flags */
-	PG_double_map = PG_private_2,
+	PG_double_map = PG_workingset,
 
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
harden-autofs-ioctl-table.patch

