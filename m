Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9B1C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJCVLB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJCVJB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:09:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4D14F6A4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94F70B815E2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33274C433D7;
        Mon,  3 Oct 2022 21:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831194;
        bh=y65UqfPxRu+63nXTHFMVnepWrIdlVLSbrLMRWZcBpOo=;
        h=Date:To:From:Subject:From;
        b=KlPIEB2BZikG/4x8hVu1TjhfcixKfkm6Hj38zARgQ+JvpJ5N6D2dyJYfWw0EC21+B
         cBPNg8smZ0C8kjtrJ8gBaAVmPMpgtLaWtsRz4HgYwkIinf3ddLdFg4YBJfME8Vq9I7
         ts3Usj/mEv7+lyns8PCGsqsaZIN1pM+JY8D6XKo4=
Date:   Mon, 03 Oct 2022 14:06:33 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        quic_zhenhuah@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ownerc-remove-redudant-drain_all_pages.patch removed from -mm tree
Message-Id: <20221003210634.33274C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_owner.c: remove redundant drain_all_pages
has been removed from the -mm tree.  Its filename was
     mm-page_ownerc-remove-redudant-drain_all_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Subject: mm/page_owner.c: remove redundant drain_all_pages
Date: Wed, 7 Sep 2022 16:01:13 +0800

Remove an expensive and unnecessary operation as PCP pages are safely
skipped when reading page owner.PCP pages can be skipped because
PAGE_EXT_OWNER_ALLOCATED is cleared.

With draining PCP pages, these pages are moved to buddy list so they can
be identified as buddy pages and skipped quickly.  Although it improved
efficiency of PFN walker, the drain is guaranteed expensive that is
unlikely to be offset by a slight increase in efficiency when skipping
free pages.

PAGE_EXT_OWNER_ALLOCATED is cleared in the page owner reset path below:
	free_unref_page
		-> free_unref_page_prepare
			-> free_pcp_prepare
				-> free_pages_prepare which do page owner
				reset
		-> free_unref_page_commit which add pages into pcp list

Link: https://lkml.kernel.org/r/1662704326-15899-1-git-send-email-quic_zhenhuah@quicinc.com
Link: https://lkml.kernel.org/r/1662633204-10044-1-git-send-email-quic_zhenhuah@quicinc.com
Link: https://lkml.kernel.org/r/1662537673-9392-1-git-send-email-quic_zhenhuah@quicinc.com
Signed-off-by: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
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


