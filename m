Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05521C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB0F961108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhKKCpX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234146AbhKKCpX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99588611F2;
        Thu, 11 Nov 2021 02:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598554;
        bh=BMTTZPjmTK6EhupD8PmQgSewn1XBNqWN5Dwb8bOXvzc=;
        h=Date:From:To:Subject:From;
        b=Pka2u7Cgl+13mIV/K9VMrpXWtFjrfpibVCJN7gGPW5JmqdGoddY3gXfNv/WeAHcWd
         w/ATuLvMnBue1ewEQU8iqwc6MvOU3BqAHyTrLdT/7qSeJpLp1TvDqmjZqOY3fRutHU
         HCFW06cbAz5vTSbeTXFomWJyqH5YtHI/enn2FjAc=
Date:   Wed, 10 Nov 2021 18:42:34 -0800
From:   akpm@linux-foundation.org
To:     amit.kachhap@arm.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, Vincenzo.Frascino@arm.com
Subject:  [merged]
 mm-memory-avoid-unnecessary-kernel-user-pointer-conversion.patch removed
 from -mm tree
Message-ID: <20211111024234.IM7M2bIGN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: avoid unnecessary kernel/user pointer conversion
has been removed from the -mm tree.  Its filename was
     mm-memory-avoid-unnecessary-kernel-user-pointer-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: mm/memory.c: avoid unnecessary kernel/user pointer conversion

Annotating a pointer from __user to kernel and then back again might
confuse sparse.  In copy_huge_page_from_user() it can be avoided by
removing the intermediate variable since it is never used.

Link: https://lkml.kernel.org/r/20210914150820.19326-1-amit.kachhap@arm.com
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vincenzo Frascino <Vincenzo.Frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memory.c~mm-memory-avoid-unnecessary-kernel-user-pointer-conversion
+++ a/mm/memory.c
@@ -5421,7 +5421,6 @@ long copy_huge_page_from_user(struct pag
 				unsigned int pages_per_huge_page,
 				bool allow_pagefault)
 {
-	void *src = (void *)usr_src;
 	void *page_kaddr;
 	unsigned long i, rc = 0;
 	unsigned long ret_val = pages_per_huge_page * PAGE_SIZE;
@@ -5434,8 +5433,7 @@ long copy_huge_page_from_user(struct pag
 		else
 			page_kaddr = kmap_atomic(subpage);
 		rc = copy_from_user(page_kaddr,
-				(const void __user *)(src + i * PAGE_SIZE),
-				PAGE_SIZE);
+				usr_src + i * PAGE_SIZE, PAGE_SIZE);
 		if (allow_pagefault)
 			kunmap(subpage);
 		else
_

Patches currently in -mm which might be from amit.kachhap@arm.com are


