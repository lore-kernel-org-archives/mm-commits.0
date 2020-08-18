Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E61AC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DE0E207BB
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790439;
	bh=CAlo0Lo8mrGsyeDpW+zYnxopWp8AYYAWaGqX8e05U/M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ckklyW2xUMDu9IqgfquiqlfHuns7/zRUX444PMpUugIowUXJXj76IYi3OdN+UgnW9
	 L7MyO+pKRH/uA4nY9pIu4gxDsfPZrpjdvHsn+I39UMCPSqReSu4ZZfqN0AFRnc4AWs
	 E/wRCCZSaeX2Qr3jDDJfsDNl/XsV1itfP6xRWbKU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgHRWkh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgHRWke (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8196F20786;
        Tue, 18 Aug 2020 22:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790433;
        bh=CAlo0Lo8mrGsyeDpW+zYnxopWp8AYYAWaGqX8e05U/M=;
        h=Date:From:To:Subject:From;
        b=UvG2zvasi4Sc7IJqUnJXmjfw8/nKxNEBhDYO3yIIJyQdtdK8/Rt6NQaDiXOOPz9dO
         zo/N9/jTDgfn2sCQqaX5230eW9E5Kyt7jNzd7yhw5ZV2erNhBO8mK9oFYWli4a7wQR
         JkqESGV1basGPdZbgoHyeSho8vLqjVulpbpkO9f8=
Date:   Tue, 18 Aug 2020 15:40:33 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-introduce-offset_in_thp.patch removed from
 -mm tree
Message-ID: <20200818224033.6WuOaKS3f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce offset_in_thp
has been removed from the -mm tree.  Its filename was
     mm-introduce-offset_in_thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: introduce offset_in_thp

Mirroring offset_in_page(), this gives you the offset within this
particular page, no matter what size page it is.  It optimises down to
offset_in_page() if CONFIG_TRANSPARENT_HUGEPAGE is not set.

Link: http://lkml.kernel.org/r/20200629151959.15779-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-introduce-offset_in_thp
+++ a/include/linux/mm.h
@@ -1594,6 +1594,7 @@ static inline void clear_page_pfmemalloc
 extern void pagefault_out_of_memory(void);
 
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
+#define offset_in_thp(page, p)	((unsigned long)(p) & (thp_size(page) - 1))
 
 /*
  * Flags passed to show_mem() and show_free_areas() to suppress output in
_

Patches currently in -mm which might be from willy@infradead.org are


