Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22FAC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbiKWCsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiKWCsK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:48:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDF459148
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:48:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49324619EB
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EA5C433C1;
        Wed, 23 Nov 2022 02:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171687;
        bh=wY85BIWIMewAIbwMHxEESeLxlhwzzmWHmQw3W9ZY3vY=;
        h=Date:To:From:Subject:From;
        b=rY63kFQ6T9fzP4fc/9VvEgWNgtFaVJyxYAiN0OxWBymEYpA2aXFW53AcKoTEVd16X
         mHoNcG3DWXDhUF6iDPNWhXs0keJoG6nJ5ldIKJmHw6PdWL2awe+FIz/lkgPOPYmfFS
         r+BSJU0iygnYaOqqMzlFwIwzvFcqr6cKROEf6tkQ=
Date:   Tue, 22 Nov 2022 18:48:06 -0800
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, jgg@nvidia.com, dvyukov@google.com,
        akinobu.mita@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix.patch removed from -mm tree
Message-Id: <20221123024807.94EA5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix.patch

This patch was dropped because it was folded into mm-fix-unexpected-changes-to-failslabfail_page_allocattr.patch

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

mm-fix-unexpected-changes-to-failslabfail_page_allocattr.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

