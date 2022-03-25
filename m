Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A0CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357209AbiCYBNT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357204AbiCYBM7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5571CBD2CC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:11:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09D04B82707
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A169EC340ED;
        Fri, 25 Mar 2022 01:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170683;
        bh=q5N2S4SWRunyk43FvDn8H/Tz9RbgaA1YkUtsaYodh78=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Tg6vQBg5flC7N/fDTCmbR6II1CfniF9PzlPW4BUw6XJ9CciP9lGLhlEB5uzAsHu1C
         pdPLl5HkhBa1nhkYUI2ZLaiT3XgsgT3uV1t/o+2IA5OVi5dAffz92+1ktq+Oj3xmPV
         8ixUVQggAkoQ0GDf6QWzMKVkkOZEQ2YmoPBBmFoc=
Date:   Thu, 24 Mar 2022 18:11:23 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 056/114] kasan, mm: only define ___GFP_SKIP_KASAN_POISON with HW_TAGS
Message-Id: <20220325011123.A169EC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: only define ___GFP_SKIP_KASAN_POISON with HW_TAGS

Only define the ___GFP_SKIP_KASAN_POISON flag when CONFIG_KASAN_HW_TAGS is
enabled.

This patch it not useful by itself, but it prepares the code for additions
of new KASAN-specific GFP patches.

Link: https://lkml.kernel.org/r/44e5738a584c11801b2b8f1231898918efc8634a.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h            |    8 +++++++-
 include/trace/events/mmflags.h |   12 +++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/include/linux/gfp.h~kasan-mm-only-define-___gfp_skip_kasan_poison-with-hw_tags
+++ a/include/linux/gfp.h
@@ -54,7 +54,11 @@ struct vm_area_struct;
 #define ___GFP_THISNODE		0x200000u
 #define ___GFP_ACCOUNT		0x400000u
 #define ___GFP_ZEROTAGS		0x800000u
+#ifdef CONFIG_KASAN_HW_TAGS
 #define ___GFP_SKIP_KASAN_POISON	0x1000000u
+#else
+#define ___GFP_SKIP_KASAN_POISON	0
+#endif
 #ifdef CONFIG_LOCKDEP
 #define ___GFP_NOLOCKDEP	0x2000000u
 #else
@@ -251,7 +255,9 @@ struct vm_area_struct;
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT (25 + IS_ENABLED(CONFIG_LOCKDEP))
+#define __GFP_BITS_SHIFT (24 +					\
+			  IS_ENABLED(CONFIG_KASAN_HW_TAGS) +	\
+			  IS_ENABLED(CONFIG_LOCKDEP))
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /**
--- a/include/trace/events/mmflags.h~kasan-mm-only-define-___gfp_skip_kasan_poison-with-hw_tags
+++ a/include/trace/events/mmflags.h
@@ -49,12 +49,18 @@
 	{(unsigned long)__GFP_RECLAIM,		"__GFP_RECLAIM"},	\
 	{(unsigned long)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},\
 	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},\
-	{(unsigned long)__GFP_ZEROTAGS,		"__GFP_ZEROTAGS"},	\
-	{(unsigned long)__GFP_SKIP_KASAN_POISON,"__GFP_SKIP_KASAN_POISON"}\
+	{(unsigned long)__GFP_ZEROTAGS,		"__GFP_ZEROTAGS"}	\
+
+#ifdef CONFIG_KASAN_HW_TAGS
+#define __def_gfpflag_names_kasan					      \
+	, {(unsigned long)__GFP_SKIP_KASAN_POISON, "__GFP_SKIP_KASAN_POISON"}
+#else
+#define __def_gfpflag_names_kasan
+#endif
 
 #define show_gfp_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
-	__def_gfpflag_names						\
+	__def_gfpflag_names __def_gfpflag_names_kasan			\
 	) : "none"
 
 #ifdef CONFIG_MMU
_
