Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786DBC4332F
	for <mm-commits@archiver.kernel.org>; Sat, 19 Nov 2022 08:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKSIHr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Nov 2022 03:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiKSIHq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 19 Nov 2022 03:07:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59163776FB
        for <mm-commits@vger.kernel.org>; Sat, 19 Nov 2022 00:07:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E215D601DB
        for <mm-commits@vger.kernel.org>; Sat, 19 Nov 2022 08:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E3FC433D6;
        Sat, 19 Nov 2022 08:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668845264;
        bh=+I+IoVwi/vDDEwVhtHV0wrliuZnQsSzeYB7UD21UPuI=;
        h=Date:To:From:Subject:From;
        b=AQtBpmTAgjUXmzaEUKwOaEtNQIVX8Nqc/mrrNmC4Xoiw7kUn2s9xtKtcrxCjjugOr
         6RpRHPxQwXBBd6Hk31o63K/yjLyygVwLazzwwrcvvV1TWS5sJXppW0IfOhpmsR4+qT
         6vhxmOp4Ke24hwdHoVMBgknz4AFJ/uB2TU3pd3Jk=
Date:   Sat, 19 Nov 2022 00:07:43 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org,
        torvalds@linux-foundation.org, svens@linux.ibm.com,
        rdunlap@infradead.org, peterz@infradead.org, npiggin@gmail.com,
        nadav.amit@gmail.com, hughd@google.com, hca@linux.ibm.com,
        hannes@cmpxchg.org, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, bagasdotme@gmail.com,
        aneesh.kumar@linux.ibm.com, agordeev@linux.ibm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch added to mm-unstable branch
Message-Id: <20221119080744.38E3FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix
Date: Sat Nov 19 12:02:30 AM PST 2022

kerneldoc on a forward-declared struct confuses htmldocs

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix
+++ a/include/linux/mm_types.h
@@ -251,7 +251,7 @@ struct page {
 #endif
 } _struct_page_alignment;
 
-/**
+/*
  * struct encoded_page - a nonexistent type marking this pointer
  *
  * An 'encoded_page' pointer is a pointer to a regular 'struct page', but
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix.patch
mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch

