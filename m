Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AF5C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ADD920897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817795;
	bh=9JcRjtlDtMmKkCFX84JMWdtXKRZgg9n5M+lUZrMptDc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QtD/bauiay6l59FOph/qqnpdRtJ6eYTMWEyHOJt14Y4iiE54Hn7AoFwlSro9NtfzR
	 jRdbKhWc/cVPoxY/prRBb7U1eV8onE+iEqNhWqLwWGqMYjl6+1eQiTbvN3V2TuSWP1
	 JDvVunWgIclqlUd1iqrVrC+bjVEZl74O2uDM071c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732225AbgJPDJz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgJPDJz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:09:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1395D20789;
        Fri, 16 Oct 2020 03:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817793;
        bh=9JcRjtlDtMmKkCFX84JMWdtXKRZgg9n5M+lUZrMptDc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v2IZ3SiNuuZQv2pIKtPkA2fJeJe5gQIdDSDaj4Bm2p6aWLBoKS1DCNHAC4IjJaHyG
         /FF04zJ4oe3T5zIzM0YWhpttxLn4rEJrcrJHla9HV7FqkWuvU8PnYX/Ded52l7nRC4
         xUJTpbzP9Pts1qPEOtY2t9Tm7ypIsSEvOHB6kFho=
Date:   Thu, 15 Oct 2020 20:09:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ira.weiny@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 087/156] mm/highmem.c: clean up endif comments
Message-ID: <20201016030952.-fkjbSOTV%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
