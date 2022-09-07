Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FA1C38145
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiIGWnM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIGWnL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:43:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06230647F0
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:43:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 803B0619B9
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE88C433D6;
        Wed,  7 Sep 2022 22:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662590589;
        bh=foz61TBOuZ/9TSsxzPvubRvc8lJA+d5a6ulNNcYj5EI=;
        h=Date:To:From:Subject:From;
        b=hL7FT8+xx2Yi8+CmsYqPkMtuCOLNcuv2kFeVOjBGcvqT+gW23t78Xx9czNpwy+sMq
         xYDoRFRr1MLX86DZ2WsBu8otLPfjscU18JjYDL4UVgm3rt/6MXf/Pd/c41knzhvFHR
         hXAlQ7SLzmJ9PVi8VSzGgWEHS3KV6hBadUR13Gfk=
Date:   Wed, 07 Sep 2022 15:43:09 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        quic_zhenhuah@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ownerc-remove-redudant-drain_all_pages.patch added to mm-unstable branch
Message-Id: <20220907224309.CEE88C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: remove redudant drain_all_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ownerc-remove-redudant-drain_all_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ownerc-remove-redudant-drain_all_pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Subject: mm/page_owner.c: remove redudant drain_all_pages
Date: Wed, 7 Sep 2022 16:01:13 +0800

Page owner info of pages in pcp list has already been reset:

	free_unref_page
		-> free_unref_page_prepare
			-> free_pcp_prepare
				-> free_pages_prepare which does page owner
				   reset
		-> free_unref_page_commit which add pages into pcp list

It can also be confirmed from dump that page owner info of pcp pages are
correct.  Hence there is no more need to drain when reading.

Link: https://lkml.kernel.org/r/1662537673-9392-1-git-send-email-quic_zhenhuah@quicinc.com
Signed-off-by: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_owner.c~mm-page_ownerc-remove-redudant-drain_all_pages
+++ a/mm/page_owner.c
@@ -524,8 +524,6 @@ read_page_owner(struct file *file, char
 	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
 		pfn++;
 
-	drain_all_pages(NULL);
-
 	/* Find an allocated page */
 	for (; pfn < max_pfn; pfn++) {
 		/*
_

Patches currently in -mm which might be from quic_zhenhuah@quicinc.com are

mm-page_ownerc-remove-redudant-drain_all_pages.patch

