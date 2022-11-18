Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F8CC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 21:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiKRVnW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Nov 2022 16:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiKRVnU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2022 16:43:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD43A7C01
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 13:43:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EA25B82559
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 21:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98BBC433D6;
        Fri, 18 Nov 2022 21:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668807796;
        bh=Uk0q2EBLKyY22NErvAFVtViCYSWsIN0l4a193JdomhA=;
        h=Date:To:From:Subject:From;
        b=IiSxs9Mzwf12pp5IvuHCDmsY1NdWYzdRbFhNEkaaLEOj/6HJ+zgVVlqDR42KytAZ6
         aHAGIYH4qW/N7+w9OgZ7I9I0Z4kkC/AAj3wdphfmg7qG98l07YtEKy4n0gHEZNLPUT
         Xe97dLBwF58aOCNwc7ADID6T0DRTF+IdA1mtJqVA=
Date:   Fri, 18 Nov 2022 13:43:16 -0800
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, jgg@nvidia.com, dvyukov@google.com,
        akinobu.mita@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20221118214316.D98BBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix
Date: Fri Nov 18 01:42:40 PM PST 2022

unexport should_fail_ex()

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/fault-inject.c~mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix
+++ a/lib/fault-inject.c
@@ -151,7 +151,6 @@ fail:
 
 	return true;
 }
-EXPORT_SYMBOL_GPL(should_fail_ex);
 
 bool should_fail(struct fault_attr *attr, ssize_t size)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix.patch
mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch

