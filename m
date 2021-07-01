Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A53C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4000561241
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbhGABxn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238468AbhGABxn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A48736105A;
        Thu,  1 Jul 2021 01:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104274;
        bh=gs9zDii9CyRCJNPF36isXF8ekseigKt6pZr9N5sv9JA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D/IijvlnzdDYRCsMkqTSltTapBkC3UpuNZZiW3CxdGnHiel17nnQcDn62VN5PQ7HH
         YDcsUCTFTD7jIU6Y8CY0VkurMbGaVlwI1Dd39D/lOs1mUAdJHxHQFaKpVWf6Hm4HOu
         1jdduNlLAIkdkz6YISHB0THhMZIFIva8RbeKTW3Q=
Date:   Wed, 30 Jun 2021 18:51:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        ardb@kernel.org, catalin.marinas@arm.com, david@redhat.com,
        linux-mm@kvack.org, mark.rutland@arm.com, maz@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, wangkefeng.wang@huawei.com,
        will@kernel.org
Subject:  [patch 076/192] include/linux/mmzone.h: add documentation
 for pfn_valid()
Message-ID: <20210701015113.if3pngvZe%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: include/linux/mmzone.h: add documentation for pfn_valid()

Patch series "arm64: drop pfn_valid_within() and simplify pfn_valid()", v4.

These patches aim to remove CONFIG_HOLES_IN_ZONE and essentially hardwire
pfn_valid_within() to 1.  

The idea is to mark NOMAP pages as reserved in the memory map and restore
the intended semantics of pfn_valid() to designate availability of struct
page for a pfn.

With this the core mm will be able to cope with the fact that it cannot
use NOMAP pages and the holes created by NOMAP ranges within MAX_ORDER
blocks will be treated correctly even without the need for
pfn_valid_within.


This patch (of 4):

Add comment describing the semantics of pfn_valid() that clarifies that
pfn_valid() only checks for availability of a memory map entry (i.e. 
struct page) for a PFN rather than availability of usable memory backing
that PFN.

The most "generic" version of pfn_valid() used by the configurations with
SPARSEMEM enabled resides in include/linux/mmzone.h so this is the most
suitable place for documentation about semantics of pfn_valid().

Link: https://lkml.kernel.org/r/20210511100550.28178-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20210511100550.28178-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/mmzone.h~include-linux-mmzoneh-add-documentation-for-pfn_valid
+++ a/include/linux/mmzone.h
@@ -1445,6 +1445,17 @@ static inline int pfn_section_valid(stru
 #endif
 
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
+/**
+ * pfn_valid - check if there is a valid memory map entry for a PFN
+ * @pfn: the page frame number to check
+ *
+ * Check if there is a valid memory map entry aka struct page for the @pfn.
+ * Note, that availability of the memory map entry does not imply that
+ * there is actual usable memory at that @pfn. The struct page may
+ * represent a hole or an unusable page frame.
+ *
+ * Return: 1 for PFNs that have memory map entries and 0 otherwise
+ */
 static inline int pfn_valid(unsigned long pfn)
 {
 	struct mem_section *ms;
_
