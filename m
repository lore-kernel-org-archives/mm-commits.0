Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133DAC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4CF92078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266128;
	bh=NYQUK0oiC1itdHWJQYxrXxsQlxTLEYLwWDwitfAeTsk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gmuRvaYt9gXjj2K+K2FCJlNptJHqvhkgoB9eQ9lXm3MskzfxQ/VUgroDLkJzOrtL+
	 Kg4GLbnMoURgmGd6OfEZ/xtH4ks0jFozYJVWsjay6eZ2BePTfUUuPnUOv3S7aCnPHM
	 QnU4wK6N/e3bQFuxRx+QhpxCD0tnH/jjuufYC5v8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHLVCI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVCI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74BA920768;
        Wed, 12 Aug 2020 21:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266127;
        bh=NYQUK0oiC1itdHWJQYxrXxsQlxTLEYLwWDwitfAeTsk=;
        h=Date:From:To:Subject:From;
        b=RpMUM36fpQg99eUHs16K9mcsjkcLMJ8lWvSf8fa6JwUZpEE51jsUBOownp1A3HYVP
         qCM3Eqz73YQzKOzZu0pkKyixkagJdELghwPKMKO1Gql03oWxo839D3SgEwDV4YZHGX
         bdP5bComBfbgduyVj+dKqZPJFAvG5NxUz5s9kYOk=
Date:   Wed, 12 Aug 2020 14:02:07 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        yang.shi@linux.alibaba.com, ziy@nvidia.com
Subject:  [merged] mm-thp-remove-debug_cow-switch.patch removed
 from -mm tree
Message-ID: <20200812210207.5v9biEXdi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: remove debug_cow switch
has been removed from the -mm tree.  Its filename was
     mm-thp-remove-debug_cow-switch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: thp: remove debug_cow switch

Since commit 3917c80280c93a7123f ("thp: change CoW semantics for
anon-THP"), the CoW page fault of THP has been rewritten, debug_cow is not
used anymore.  So, just remove it.

Link: http://lkml.kernel.org/r/1592270980-116062-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    7 -------
 mm/huge_memory.c        |   21 ---------------------
 2 files changed, 28 deletions(-)

--- a/include/linux/huge_mm.h~mm-thp-remove-debug_cow-switch
+++ a/include/linux/huge_mm.h
@@ -181,13 +181,6 @@ static inline bool transhuge_vma_suitabl
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
-#ifdef CONFIG_DEBUG_VM
-#define transparent_hugepage_debug_cow()				\
-	(transparent_hugepage_flags &					\
-	 (1<<TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG))
-#else /* CONFIG_DEBUG_VM */
-#define transparent_hugepage_debug_cow() 0
-#endif /* CONFIG_DEBUG_VM */
 
 extern unsigned long thp_get_unmapped_area(struct file *filp,
 		unsigned long addr, unsigned long len, unsigned long pgoff,
--- a/mm/huge_memory.c~mm-thp-remove-debug_cow-switch
+++ a/mm/huge_memory.c
@@ -303,24 +303,6 @@ static ssize_t hpage_pmd_size_show(struc
 static struct kobj_attribute hpage_pmd_size_attr =
 	__ATTR_RO(hpage_pmd_size);
 
-#ifdef CONFIG_DEBUG_VM
-static ssize_t debug_cow_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buf)
-{
-	return single_hugepage_flag_show(kobj, attr, buf,
-				TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG);
-}
-static ssize_t debug_cow_store(struct kobject *kobj,
-			       struct kobj_attribute *attr,
-			       const char *buf, size_t count)
-{
-	return single_hugepage_flag_store(kobj, attr, buf, count,
-				 TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG);
-}
-static struct kobj_attribute debug_cow_attr =
-	__ATTR(debug_cow, 0644, debug_cow_show, debug_cow_store);
-#endif /* CONFIG_DEBUG_VM */
-
 static struct attribute *hugepage_attr[] = {
 	&enabled_attr.attr,
 	&defrag_attr.attr,
@@ -329,9 +311,6 @@ static struct attribute *hugepage_attr[]
 #ifdef CONFIG_SHMEM
 	&shmem_enabled_attr.attr,
 #endif
-#ifdef CONFIG_DEBUG_VM
-	&debug_cow_attr.attr,
-#endif
 	NULL,
 };
 
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are


