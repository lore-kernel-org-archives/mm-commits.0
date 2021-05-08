Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BCCC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA1F7613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhEHWoz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWoy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A46D61426;
        Sat,  8 May 2021 22:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513832;
        bh=CPQTQGOgkOeoHm1lpbxgs1GVvy4JsuykuKqsUInyLI8=;
        h=Date:From:To:Subject:From;
        b=XcMCQoACyHfpb3w5wxJ/dMdmk4aZs06FtZrhmHVPpjZaOvxedpBvMx/OtFwWSYaSC
         GxuxR03KN8EvrWnsVctcbMvizfEe5bbEBB4pekswklqJnMr2An0J+56jH8PQH3ob79
         anGIlNnEXBboYa5gzQ1TwBoJkTI0ALydaVgaPq3A=
Date:   Sat, 08 May 2021 15:43:52 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, mm-commits@vger.kernel.org,
        pcc@google.com
Subject:  [merged]
 kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks.patch
 removed from -mm tree
Message-ID: <20210508224352.c3xdmzBWA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix kasan_byte_accessible() to be consistent with actual checks
has been removed from the -mm tree.  Its filename was
     kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from pcc@google.com are


