Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128F7C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbiCVVpv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236335AbiCVVpd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:45:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DDC5F4F6
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D33B9614A2
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3450DC340EC;
        Tue, 22 Mar 2022 21:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985444;
        bh=xgqZDbTzEsfmPCiFaNGMAyorMwxLVu3/TxjnXbwlF0g=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=UN4AfFbF1qt7cw8LtPLdLjeWFXkhyNcLQDOXuJswVbXLEsnSXEpB3nj9jiFd3Ui1E
         kn/HrUMz+OJMTlBnAeBndv10VMw7zN1cvjGZl4/ts35fhuELeCAsoXfYH9AOp632Qk
         DwTzyhc3tnHZlYdTckVGsq3x7TJac0Yskcz9v4mo=
Date:   Tue, 22 Mar 2022 14:44:03 -0700
To:     shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, anshuman.khandual@arm.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 109/227] mm/memory-failure.c: remove obsolete comment
Message-Id: <20220322214404.3450DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/memory-failure.c: remove obsolete comment

With the introduction of mf_mutex, most of memory error handling process
is mutually exclusive, so the in-line comment about subtlety about
double-checking PageHWPoison is no more correct.  So remove it.

Link: https://lkml.kernel.org/r/20220125025601.3054511-1-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-obsolete-comment
+++ a/mm/memory-failure.c
@@ -2150,12 +2150,6 @@ static int __soft_offline_page(struct pa
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 	};
 
-	/*
-	 * Check PageHWPoison again inside page lock because PageHWPoison
-	 * is set by memory_failure() outside page lock. Note that
-	 * memory_failure() also double-checks PageHWPoison inside page lock,
-	 * so there's no race between soft_offline_page() and memory_failure().
-	 */
 	lock_page(page);
 	if (!PageHuge(page))
 		wait_on_page_writeback(page);
_
