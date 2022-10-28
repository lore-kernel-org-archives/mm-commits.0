Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BFC5FA3743
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiJ1VHR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJ1VHP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DBE249885
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9868F62A79
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC5BC433D7;
        Fri, 28 Oct 2022 21:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991233;
        bh=PtDXpnovyBu2s+pd96N1d/Udm4K8kX234vX9FrAXLA8=;
        h=Date:To:From:Subject:From;
        b=rV7lTf9cYUIB+DSC39TY2tg02tpbjbbvKMo3fheG7bWudLNwaBiVF4exxdhy0m1Ei
         A27taK6maTYtZNQ9L9n2h0WX155njK7BDSdmsFl8sgzKsaaUOlrAHAkE8TO2aylwMU
         UN6UCRVdDXg/SVN/TNlXZoGOhUBHYBLMfITmZdes=
Date:   Fri, 28 Oct 2022 14:07:12 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@linux.intel.com,
        opendmb@gmail.com, mike.kravetz@oracle.com, david@redhat.com,
        quic_aiquny@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_isolation-fix-clang-deadcode-warning.patch removed from -mm tree
Message-Id: <20221028210712.DFC5BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_isolation: fix clang deadcode warning
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-fix-clang-deadcode-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maria Yu <quic_aiquny@quicinc.com>
Subject: mm/page_isolation: fix clang deadcode warning
Date: Fri, 21 Oct 2022 18:15:55 +0800

When !CONFIG_VM_BUG_ON, there is warning of
clang-analyzer-deadcode.DeadStores:
Value stored to 'mt' during its initialization is never read.

Link: https://lkml.kernel.org/r/20221021101555.7992-2-quic_aiquny@quicinc.com
Signed-off-by: Maria Yu <quic_aiquny@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_isolation.c~mm-page_isolation-fix-clang-deadcode-warning
+++ a/mm/page_isolation.c
@@ -330,7 +330,7 @@ static int isolate_single_pageblock(unsi
 				      zone->zone_start_pfn);
 
 	if (skip_isolation) {
-		int mt = get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
+		int mt __maybe_unused = get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
 
 		VM_BUG_ON(!is_migrate_isolate(mt));
 	} else {
_

Patches currently in -mm which might be from quic_aiquny@quicinc.com are


