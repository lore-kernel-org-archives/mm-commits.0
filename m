Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3523DC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 247B861252
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhKEUk7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhKEUk6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2179611C0;
        Fri,  5 Nov 2021 20:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144698;
        bh=ATPv8/v4Nqm+039u6nxvoHetifbhpBxKrXQN0Sbsr2o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lIY8ZrQVk5rqK+ZedOqf+z2Qqp16S4s4W1wkwqumB89hebWjVxiOuntTWMNqZn5JJ
         3K2LcxA0cSefESaJlajGzp0naUwMjOmAZN8TbvxuLU4x/6rg57AolreHVs4AlNV7vc
         VDMs14ulayNxgSN/O/zBaZWR1vUcDbMWkXnP85Ic=
Date:   Fri, 05 Nov 2021 13:38:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit.kachhap@arm.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        Vincenzo.Frascino@arm.com
Subject:  [patch 070/262] mm/memory.c: avoid unnecessary
 kernel/user pointer conversion
Message-ID: <20211105203818.RLrQbH0Iv%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
