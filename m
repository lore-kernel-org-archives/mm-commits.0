Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B61DC4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiK3Xph (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiK3Xph (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:45:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204C8578F8
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:45:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1646B81D4C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71833C433D6;
        Wed, 30 Nov 2022 23:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669851933;
        bh=Lx6cWMZlVzwgOzer9EoRqwX/rIT+gwcU53IW+A2uxMs=;
        h=Date:To:From:Subject:From;
        b=DeoMeXg5AvTiBDuB0hsOjZW7ymR/j+fV5+Qd4kx6U0xJzlZmK6xeZ8j9OPDWuvT32
         Jogl3mmYbrZa5X0jw5flOo+W5TVAHJuxayGsZtKEkbc3LxabYCDK0W5Pv1714rA0UR
         NsE1r/K01potJrMlcSMU4uysVJROfVcSMx/LgaBs=
Date:   Wed, 30 Nov 2022 15:45:32 -0800
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
Subject: [folded-merged] mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch removed from -mm tree
Message-Id: <20221130234533.71833C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch

This patch was dropped because it was folded into mm-introduce-encoded-page-pointers-with-embedded-extra-bits.patch

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

mm-introduce-encoded-page-pointers-with-embedded-extra-bits.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

