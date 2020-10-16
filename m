Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8893EC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355D721775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881526;
	bh=WSh+Jsx/e9t49benJ8EALh2MFnWqxOWDc2tgF9JgrRE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bi08E+x2V7SDvq/cTTtbJIovvcexj1XGdxFjnUBF4vzrYKQuPmw7wrbKhf3kEczAv
	 smH3Vn5pYpfrcf/+PRZrPzSDpqY91A0loOyBVeqs1iYLbtAIjBT3Cw1o4KgMw9ysOw
	 G3fY6xGDqH60w0aBhU17dmT+Kuj2ZIUg1dDweUyw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408233AbgJPUwF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgJPUwF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:05 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F104520878;
        Fri, 16 Oct 2020 20:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881525;
        bh=WSh+Jsx/e9t49benJ8EALh2MFnWqxOWDc2tgF9JgrRE=;
        h=Date:From:To:Subject:From;
        b=JCOJ5n+NCuTZmzefn2LCprcuudW9DeF7dF00ZBrqxNq0nev5c2pxPU/QozJnJocce
         1184SodeD//dIKCNMqC7P8uYXIQPXfw6OuvjVHkLRBtrQrr9xdzsNQI4+92bqyW7AV
         9czaII23eBg7XYXsKf9hlgsUpmVz/rqs8RyCa/xY=
Date:   Fri, 16 Oct 2020 13:52:04 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, ira.weiny@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [merged] mm-highmem-clean-up-endif-comments.patch removed
 from -mm tree
Message-ID: <20201016205204.BY2pL6HrJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem.c: clean up endif comments
has been removed from the -mm tree.  Its filename was
     mm-highmem-clean-up-endif-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/highmem.c: clean up endif comments

The #endif at the end of the file matches up with the '#if
defined(HASHED_PAGE_VIRTUAL)' on line 374.  Not the CONFIG_HIGHMEM #if
earlier.

Fix comments on both of the #endif's to indicate the correct end of
blocks for each.

Link: https://lkml.kernel.org/r/20200819184635.112579-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c~mm-highmem-clean-up-endif-comments
+++ a/mm/highmem.c
@@ -369,7 +369,7 @@ void kunmap_high(struct page *page)
 }
 
 EXPORT_SYMBOL(kunmap_high);
-#endif
+#endif	/* CONFIG_HIGHMEM */
 
 #if defined(HASHED_PAGE_VIRTUAL)
 
@@ -481,4 +481,4 @@ void __init page_address_init(void)
 	}
 }
 
-#endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
+#endif	/* defined(HASHED_PAGE_VIRTUAL) */
_

Patches currently in -mm which might be from ira.weiny@intel.com are


