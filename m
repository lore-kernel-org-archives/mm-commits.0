Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E998C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 02:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CBA561056
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 02:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhIOCDN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 22:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231979AbhIOCDM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 22:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AA1E61056;
        Wed, 15 Sep 2021 02:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631671314;
        bh=PjmpZ5VgwIMDx3wrjLw2PPYQAFbVMgEQz3vvOYImojs=;
        h=Date:From:To:Subject:From;
        b=Wp1PIj1200PPBwCoFzZus0UK7FNmPNnRF03tQbnx1MzwIRj3nn1NA2OzXCn4vys9l
         V4DTncL+o0m9cUMH9ctN6Zarv8pKfvswu4RM1BHUviA5SFab3Y8iu8vuFgO+jEAsEt
         eXnB0BqGxqHwV9TQ/VbpZ8+1VhfeuAH1wdg2FIno=
Date:   Tue, 14 Sep 2021 19:01:54 -0700
From:   akpm@linux-foundation.org
To:     amit.kachhap@arm.com, mm-commits@vger.kernel.org,
        Vincenzo.Frascino@arm.com
Subject:  +
 mm-memory-avoid-unnecessary-kernel-user-pointer-conversion.patch added to
 -mm tree
Message-ID: <20210915020154.PrFUDb_bq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: avoid unnecessary kernel/user pointer conversion
has been added to the -mm tree.  Its filename is
     mm-memory-avoid-unnecessary-kernel-user-pointer-conversion.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-avoid-unnecessary-kernel-user-pointer-conversion.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-avoid-unnecessary-kernel-user-pointer-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: mm/memory.c: avoid unnecessary kernel/user pointer conversion

Annotating a pointer from __user to kernel and then back again might
confuse sparse.  In copy_huge_page_from_user() it can be avoided by
removing the intermediate variable since it is never used.

Link: https://lkml.kernel.org/r/20210914150820.19326-1-amit.kachhap@arm.com
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Vincenzo Frascino <Vincenzo.Frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memory.c~mm-memory-avoid-unnecessary-kernel-user-pointer-conversion
+++ a/mm/memory.c
@@ -5411,7 +5411,6 @@ long copy_huge_page_from_user(struct pag
 				unsigned int pages_per_huge_page,
 				bool allow_pagefault)
 {
-	void *src = (void *)usr_src;
 	void *page_kaddr;
 	unsigned long i, rc = 0;
 	unsigned long ret_val = pages_per_huge_page * PAGE_SIZE;
@@ -5424,8 +5423,7 @@ long copy_huge_page_from_user(struct pag
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

mm-memory-avoid-unnecessary-kernel-user-pointer-conversion.patch

