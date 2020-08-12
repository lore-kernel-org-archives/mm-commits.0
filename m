Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE35C433E4
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC5C22076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195913;
	bh=6PQoj1I2BFw0VaGBAtiuBfSthDm1RaUJRu32hNnkB/c=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QVG01p+hr5Ld6VbhBZMg/zm2DHBzkXCtF0tyfU8Zx5gF2nmb/f9AWbcXKIKC7xrwA
	 tHOXyJm+4ALmVcJWkinRTi47BpSwrD3iDN+sYInqfJD1sikNxUGjAj/gB7u5biMs/H
	 0iEmq+g5QjkswyivpWtS0LN/3o3V7IT9SbBO7DRA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHLBbw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHLBbu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DCB22076C;
        Wed, 12 Aug 2020 01:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195908;
        bh=6PQoj1I2BFw0VaGBAtiuBfSthDm1RaUJRu32hNnkB/c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GRgyTR/86Mg49GfBFyU6kMV1yhY1xIs/JHqYL8mVFiO9+DYnM+B7JBLmzaqbaDkFw
         jfNjKauRjtEc3Fl9eMfRnKWZ1lFb16XY6oNfnNCc1NtWt4btMdBivEg2wVg+dYZbGf
         gclC0ZwPgZM3XRnilcN11zrxl5XaipedAiGJ/qjM=
Date:   Tue, 11 Aug 2020 18:31:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yang.shi@linux.alibaba.com,
        ziy@nvidia.com
Subject:  [patch 029/165] mm: thp: remove debug_cow switch
Message-ID: <20200812013148.BsZZPzfR3%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
