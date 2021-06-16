Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BFDBC49EA2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 01:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 674A9613B1
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 01:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhFPBZX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 21:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhFPBZW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 21:25:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B686761369;
        Wed, 16 Jun 2021 01:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623806597;
        bh=QKASjZC4YBYY3DdrkcmavZTXmy7gVhANBn05PKoBZ3w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ksOAFJ62ofW1ORrI9S7Uf4Wi7DUzcb0IYHUeoJck6SlHlrKy80qqXTw91DoA0U6yx
         CxX1DCtI62JW4MMTUs3IEksmU17XNgb3CLyYGrDV3+4PpBJ5lkWUg2D00sggOKCHGB
         /M72msU3aCtN4Uo3ydZ1zBY/UNIH972fRGqBIDB8=
Date:   Tue, 15 Jun 2021 18:23:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 02/18] mm/swap: fix pte_same_as_swp() not removing
 uffd-wp bit when compare
Message-ID: <20210616012316.0gJpsRaYU%akpm@linux-foundation.org>
In-Reply-To: <20210615182248.9a0ba90e8e66b9f4a53c0d23@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/swap: fix pte_same_as_swp() not removing uffd-wp bit when compare

I found it by pure code review, that pte_same_as_swp() of unuse_vma()
didn't take uffd-wp bit into account when comparing ptes. 
pte_same_as_swp() returning false negative could cause failure to swapoff
swap ptes that was wr-protected by userfaultfd.

Link: https://lkml.kernel.org/r/20210603180546.9083-1-peterx@redhat.com
Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>	[5.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   15 +++++++++++----
 mm/swapfile.c           |    2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/swapops.h~mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare
+++ a/include/linux/swapops.h
@@ -23,6 +23,16 @@
 #define SWP_TYPE_SHIFT	(BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
 #define SWP_OFFSET_MASK	((1UL << SWP_TYPE_SHIFT) - 1)
 
+/* Clear all flags but only keep swp_entry_t related information */
+static inline pte_t pte_swp_clear_flags(pte_t pte)
+{
+	if (pte_swp_soft_dirty(pte))
+		pte = pte_swp_clear_soft_dirty(pte);
+	if (pte_swp_uffd_wp(pte))
+		pte = pte_swp_clear_uffd_wp(pte);
+	return pte;
+}
+
 /*
  * Store a type+offset into a swp_entry_t in an arch-independent format
  */
@@ -66,10 +76,7 @@ static inline swp_entry_t pte_to_swp_ent
 {
 	swp_entry_t arch_entry;
 
-	if (pte_swp_soft_dirty(pte))
-		pte = pte_swp_clear_soft_dirty(pte);
-	if (pte_swp_uffd_wp(pte))
-		pte = pte_swp_clear_uffd_wp(pte);
+	pte = pte_swp_clear_flags(pte);
 	arch_entry = __pte_to_swp_entry(pte);
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
--- a/mm/swapfile.c~mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare
+++ a/mm/swapfile.c
@@ -1900,7 +1900,7 @@ unsigned int count_swap_pages(int type,
 
 static inline int pte_same_as_swp(pte_t pte, pte_t swp_pte)
 {
-	return pte_same(pte_swp_clear_soft_dirty(pte), swp_pte);
+	return pte_same(pte_swp_clear_flags(pte), swp_pte);
 }
 
 /*
_
