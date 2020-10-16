Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F765C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16146208E4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816410;
	bh=9JcRjtlDtMmKkCFX84JMWdtXKRZgg9n5M+lUZrMptDc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=iuZ6tdrnHd7FQKK1N0DUic50W22t+zWA0pFk6QG2iN14oQAzl4pXZHypE0Uo3E15G
	 IkYqK9tY0wWVnCjNBkyTygL0F58d4fMXNCFO/I6FTryDIXU8peZdc/kFS5+V+i5HGG
	 qAogmd+ElCEoEyvXl8K0VpO/sFapbGf3TmfIBkOo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404338AbgJPCqt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404337AbgJPCqt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:46:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8234220B1F;
        Fri, 16 Oct 2020 02:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816407;
        bh=9JcRjtlDtMmKkCFX84JMWdtXKRZgg9n5M+lUZrMptDc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=W7pJfW/0prQiZQ6otooJH+PP0NxE+rCTjlZKeZ+fWB+NgzzwXbYgUVdYpRU4HAxcV
         odiu1WcvT+OIm1RUPMODpvZ4G9sSKCV5L70yZj8zSN73b5krcpx+VnZhC2GqtiQNlx
         kOH7LV6wWv3MeVJs6zMu84NW1prgWkvL53sOfqwM=
Date:   Thu, 15 Oct 2020 19:46:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ira.weiny@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 087/156] mm/highmem.c: clean up endif comments
Message-ID: <20201016024647.w9Ybt4xuB%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
