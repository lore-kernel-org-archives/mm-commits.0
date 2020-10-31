Return-Path: <SRS0=UFsa=EG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEE8C388F9
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F07B120720
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604173729;
	bh=B65pBBYBUWZS5DzW5VaHlzNO5YE/fAbryAQZfUar4/U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Xcg0iAgW/Dty7ytpaTiFqabfR4LI6/6pVYolK/mHFRX/9Yk68hFjnSZ1UPWrJBrLw
	 bpUewQ6aPxQffMQFfNwnYT6iZ/54S4lybRx5ufCRGUX5ujAmgE5EE2WUC9dFFCqTxL
	 n2C4HWS5XJ79k5hJDcxg820IVi8hpDGalr1DH24U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgJaTss (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 31 Oct 2020 15:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728475AbgJaTss (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 31 Oct 2020 15:48:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E2FC206E5;
        Sat, 31 Oct 2020 19:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604173727;
        bh=B65pBBYBUWZS5DzW5VaHlzNO5YE/fAbryAQZfUar4/U=;
        h=Date:From:To:Subject:From;
        b=QvtqbkG8UWb8sGKB/mDNMwgVfCtSqioQ9Hh6j228z95zxbeqo51I+S7a56zCnNb88
         BktgCGXGTngR0j2NyibhRlgKKmv/zp3i5RWjs07HyC08CBxM0V9HiJVvswm/gjtm8Z
         UGAWDv+1trxAQtLtaEhn8aRst6QqZCxWWeLHNZvk=
Date:   Sat, 31 Oct 2020 12:48:47 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, glider@google.com, keescook@chromium.org,
        mateusznosek0@gmail.com, mcgrof@kernel.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-page_alloc-reduce-static-keys-in-prep_new_page.patch removed from -mm
 tree
Message-ID: <20201031194847.RinR2odQe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: reduce static keys in prep_new_page()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reduce-static-keys-in-prep_new_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: reduce static keys in prep_new_page()

prep_new_page() will always zero a new page (regardless of __GFP_ZERO)
when init_on_alloc is enabled, but will also always skip zeroing if the
page was already zeroed on free by init_on_free or page poisoning.

The latter check implemented by free_pages_prezeroed() can involve two
different static keys.  As prep_new_page() is really a hot path, let's
introduce a single static key free_pages_not_prezeroed for this purpose
and initialize it in init_mem_debugging().

Link: https://lkml.kernel.org/r/20201026173358.14704-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-reduce-static-keys-in-prep_new_page
+++ a/mm/page_alloc.c
@@ -171,6 +171,8 @@ EXPORT_SYMBOL(init_on_alloc);
 DEFINE_STATIC_KEY_FALSE_RO(init_on_free);
 EXPORT_SYMBOL(init_on_free);
 
+static DEFINE_STATIC_KEY_TRUE_RO(free_pages_not_prezeroed);
+
 static bool _init_on_alloc_enabled_early __read_mostly
 				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
 static int __init early_init_on_alloc(char *buf)
@@ -777,6 +779,16 @@ void init_mem_debugging(void)
 		}
 	}
 
+	/*
+	 * We have a special static key that controls whether prep_new_page will
+	 * never need to zero the page. This mode is enabled when page is
+	 * already zeroed by init_on_free or page_poisoning zero mode.
+	 */
+	if (_init_on_free_enabled_early ||
+			(IS_ENABLED(CONFIG_PAGE_POISONING_ZERO)
+				&& page_poisoning_enabled()))
+		static_branch_disable(&free_pages_not_prezeroed);
+
 #ifdef CONFIG_PAGE_POISONING
 	/*
 	 * Page poisoning is debug page alloc for some arches. If
@@ -2216,12 +2228,6 @@ static inline int check_new_page(struct
 	return 1;
 }
 
-static inline bool free_pages_prezeroed(void)
-{
-	return (IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
-		page_poisoning_enabled_static()) || want_init_on_free();
-}
-
 #ifdef CONFIG_DEBUG_VM
 /*
  * With DEBUG_VM enabled, order-0 pages are checked for expected state when
@@ -2291,7 +2297,8 @@ static void prep_new_page(struct page *p
 {
 	post_alloc_hook(page, order, gfp_flags);
 
-	if (!free_pages_prezeroed() && want_init_on_alloc(gfp_flags))
+	if (static_branch_likely(&free_pages_not_prezeroed)
+					&& want_init_on_alloc(gfp_flags))
 		kernel_init_free_pages(page, 1 << order);
 
 	if (order && (gfp_flags & __GFP_COMP))
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch

