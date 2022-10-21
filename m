Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0BCC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 18:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJUSvo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 14:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJUSvn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 14:51:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EED261AC0
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 11:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E4261E92
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 18:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08928C433D6;
        Fri, 21 Oct 2022 18:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666378302;
        bh=5WeSzy+Y/5w1/I+JkC7SY8kLPahV2Ok3UEVZHcvH6SM=;
        h=Date:To:From:Subject:From;
        b=hUIAJnCNRtpIu2zwYO5yokDCrQptLN3go8zbjugQO8SoIKQx/Km+wPGRTgzWifetU
         Vzc3BqyZeia4sEqNJkWRA3UMerFS4i7jjUV519PqPit7+7zGmEsyToNij/Jj7Wx9e+
         sWxF0kvLScrr/wVryICW5gnWK46KwjrRhqDsipOQ=
Date:   Fri, 21 Oct 2022 11:51:41 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@linux.intel.com,
        opendmb@gmail.com, mike.kravetz@oracle.com, david@redhat.com,
        quic_aiquny@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-fix-clang-deadcode-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20221021185142.08928C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: fix clang deadcode warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_isolation-fix-clang-deadcode-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-fix-clang-deadcode-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

mm-page_isolation-fix-clang-deadcode-warning.patch

