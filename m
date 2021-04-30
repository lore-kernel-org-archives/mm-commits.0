Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76697C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51B02613A9
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhD3GAg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhD3GAf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F2536147E;
        Fri, 30 Apr 2021 05:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762386;
        bh=Qzgh6fard9AtLUmTW/4xzZxidPIS98HeJzwg2Gsv4qg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hbgg9Ws56k8/+H0pJPc9/JSlolbjEy+tPlBOQ8qZz2HJnghZba6WbmUoVuxLshAaS
         zysFkvyqFHJDT+sV1KDaRrV3PHykczdRTtwAnNXcIOk98JcviyZPT0AIxo2iJOSSZo
         tLfiFdTvpj17Mid7Iytg1bP6WSTFgNLmwfOEufFw=
Date:   Thu, 29 Apr 2021 22:59:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        pcc@google.com, torvalds@linux-foundation.org
Subject:  [patch 128/178] kasan: fix kasan_byte_accessible() to be
 consistent with actual checks
Message-ID: <20210430055946.mvvemtpUY%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>
Subject: kasan: fix kasan_byte_accessible() to be consistent with actual checks

We can sometimes end up with kasan_byte_accessible() being called on
non-slab memory.  For example ksize() and krealloc() may end up calling it
on KFENCE allocated memory.  In this case the memory will be tagged with
KASAN_SHADOW_INIT, which a subsequent patch ("kasan: initialize shadow to
TAG_INVALID for SW_TAGS") will set to the same value as KASAN_TAG_INVALID,
causing kasan_byte_accessible() to fail when called on non-slab memory.

This highlighted the fact that the check in kasan_byte_accessible() was
inconsistent with checks as implemented for loads and stores
(kasan_check_range() in SW tags mode and hardware-implemented checks in HW
tags mode).  kasan_check_range() does not have a check for
KASAN_TAG_INVALID, and instead has a comparison against
KASAN_SHADOW_START.  In HW tags mode, we do not have either, but we do set
TCR_EL1.TCMA which corresponds with the comparison against
KASAN_TAG_KERNEL.

Therefore, update kasan_byte_accessible() for both SW and HW tags modes to
correspond with the respective checks on loads and stores.

Link: https://linux-review.googlesource.com/id/Ic6d40803c57dcc6331bd97fbb9a60b0d38a65a36
Link: https://lkml.kernel.org/r/20210405220647.1965262-1-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h   |    3 +--
 mm/kasan/sw_tags.c |   10 +++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/mm/kasan/kasan.h~kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks
+++ a/mm/kasan/kasan.h
@@ -396,8 +396,7 @@ static inline bool kasan_byte_accessible
 	u8 ptr_tag = get_tag(addr);
 	u8 mem_tag = hw_get_mem_tag((void *)addr);
 
-	return (mem_tag != KASAN_TAG_INVALID) &&
-		(ptr_tag == KASAN_TAG_KERNEL || ptr_tag == mem_tag);
+	return ptr_tag == KASAN_TAG_KERNEL || ptr_tag == mem_tag;
 }
 
 #else /* CONFIG_KASAN_HW_TAGS */
--- a/mm/kasan/sw_tags.c~kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks
+++ a/mm/kasan/sw_tags.c
@@ -121,10 +121,14 @@ bool kasan_check_range(unsigned long add
 bool kasan_byte_accessible(const void *addr)
 {
 	u8 tag = get_tag(addr);
-	u8 shadow_byte = READ_ONCE(*(u8 *)kasan_mem_to_shadow(kasan_reset_tag(addr)));
+	void *untagged_addr = kasan_reset_tag(addr);
+	u8 shadow_byte;
 
-	return (shadow_byte != KASAN_TAG_INVALID) &&
-		(tag == KASAN_TAG_KERNEL || tag == shadow_byte);
+	if (untagged_addr < kasan_shadow_to_mem((void *)KASAN_SHADOW_START))
+		return false;
+
+	shadow_byte = READ_ONCE(*(u8 *)kasan_mem_to_shadow(untagged_addr));
+	return tag == KASAN_TAG_KERNEL || tag == shadow_byte;
 }
 
 #define DEFINE_HWASAN_LOAD_STORE(size)					\
_
