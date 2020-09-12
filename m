Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C918C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C8A21531
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599940459;
	bh=7T+hHqZFBmFcnTbLK7AvZXvdl/pCUGMlfKg2qn9o/Xo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=i6/wlHlkp8iCEDA85+ZJkO6q9ChmAEUUlNHzaXKAqqYn7sJqriJ4wxvx9d1r87hsR
	 BqVbN8TtXHrsEs1CSeYgauZeJeTrpWA/O3kb0+urauIzEyNRcxDIjHcSbMc789bLPz
	 of2LMNVqF98v1+thsPfBnez08mtZvMRQXMHuXYg4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgILTyS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgILTyQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:54:16 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF76721531;
        Sat, 12 Sep 2020 19:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599940455;
        bh=7T+hHqZFBmFcnTbLK7AvZXvdl/pCUGMlfKg2qn9o/Xo=;
        h=Date:From:To:Subject:From;
        b=M07Tam1cY7zZfsQn6VljOTKkDiI6oDQiUsWktLx5IxuK73Of/zkhEaWfT4z8Hqz4k
         7fODxeY94FxZRv6A3xbUe86NuQXnYEh1T6XnTusGH9Rvke0YEVIYPjJQBX9ISwmivJ
         Ept81/PTiNX0v/cZaA+T6MjlCvs9X3c4BQfYTtpE=
Date:   Sat, 12 Sep 2020 12:54:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        alex.shi@linux.alibaba.com
Subject:  + mm-remove-unused-marco-writeback.patch added to -mm tree
Message-ID: <20200912195415.p8rh1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: remove unused macro `writeback'
has been added to the -mm tree.  Its filename is
     mm-remove-unused-marco-writeback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unused-marco-writeback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unused-marco-writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memory-failure.c: remove unused macro `writeback'

Unlike others we don't use the marco writeback.  so let's remove it to
tame gcc warning:

mm/memory-failure.c:827: warning: macro "writeback" is not used
[-Wunused-macros]

Link: https://lkml.kernel.org/r/1599715096-20369-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory-failure.c~mm-remove-unused-marco-writeback
+++ a/mm/memory-failure.c
@@ -825,7 +825,6 @@ static int me_huge_page(struct page *p,
 #define sc		((1UL << PG_swapcache) | (1UL << PG_swapbacked))
 #define unevict		(1UL << PG_unevictable)
 #define mlock		(1UL << PG_mlocked)
-#define writeback	(1UL << PG_writeback)
 #define lru		(1UL << PG_lru)
 #define head		(1UL << PG_head)
 #define slab		(1UL << PG_slab)
@@ -874,7 +873,6 @@ static struct page_state {
 #undef sc
 #undef unevict
 #undef mlock
-#undef writeback
 #undef lru
 #undef head
 #undef slab
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-remove-unused-marco-writeback.patch

