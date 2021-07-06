Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4901EC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3078661C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhGFTWw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhGFTWv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE0EE6192B;
        Tue,  6 Jul 2021 19:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599212;
        bh=3vnkPaEMmOA8T5XPzy8vJWfvkNm0RbhLtEWSMi++WGw=;
        h=Date:From:To:Subject:From;
        b=v1XmebQWv4dVswtCy0wj6picck2nPteRP0qxnNzGueQ1M3es9IbCfFd8FLcd/R7R6
         luTsg0vrbhFPFJyx1d411EbJBTPyQfWd+yCXqymUyRmm/IeV4vU0EHQp3+TGVJrjHH
         4VWt+EDbrucrUExca+L8wvcCTNFXH8JfWPWDJXLo=
Date:   Tue, 06 Jul 2021 12:20:11 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, arnd@arndb.de, chris@zankel.net,
        dave.hansen@intel.com, david@redhat.com, deller@gmx.de,
        eike-kernel@sf-tec.de, hughd@google.com, ink@jurassic.park.msu.ru,
        James.Bottomley@HansenPartnership.com, jannh@google.com,
        jcmvbkbc@gmail.com, jgg@ziepe.ca, kirill.shutemov@linux.intel.com,
        linuxram@us.ibm.com, mattst88@gmail.com, mhocko@suse.com,
        mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        peterx@redhat.com, riel@surriel.com, rth@twiddle.net,
        shuah@kernel.org, tsbogend@alpha.franken.de, vbabka@suse.cz,
        willy@infradead.org
Subject:  [merged]
 mm-make-variable-names-for-populate_vma_page_range-consistent.patch removed
 from -mm tree
Message-ID: <20210706192011.r53CVa0qs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make variable names for populate_vma_page_range() consistent
has been removed from the -mm tree.  Its filename was
     mm-make-variable-names-for-populate_vma_page_range-consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: make variable names for populate_vma_page_range() consistent

Patch series "mm/madvise: introduce MADV_POPULATE_(READ|WRITE) to prefault page tables", v2.

Excessive details on MADV_POPULATE_(READ|WRITE) can be found in patch #2.


This patch (of 5):

Let's make the variable names in the function declaration match the
variable names used in the definition.

Link: https://lkml.kernel.org/r/20210419135443.12822-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210419135443.12822-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-make-variable-names-for-populate_vma_page_range-consistent
+++ a/mm/internal.h
@@ -344,7 +344,7 @@ void __vma_unlink_list(struct mm_struct
 
 #ifdef CONFIG_MMU
 extern long populate_vma_page_range(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, int *nonblocking);
+		unsigned long start, unsigned long end, int *locked);
 extern void munlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
 static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-complete-admin-guide-overhaul.patch

