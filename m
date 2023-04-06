Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB64C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbjDFC3g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbjDFC3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:29:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2B649CA
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07A9F62D58
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E87CC4339B;
        Thu,  6 Apr 2023 02:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748173;
        bh=LxsuWQuwOlSArgDPoq5XUa4/08qtAGJ2WH3X+MmeNV0=;
        h=Date:To:From:Subject:From;
        b=Td3KnAVQrcHZykFxwXiKd6a24vHo1TmQcIRAkUwe/KtB5ArQlIZHO+MwaxSwP9JOS
         ZNPIPCVsYW+zMcsWpbLkmopo0HtoAvesH8GEzY2PO3ZV2a8gGKc1WFt8541jJnyDRG
         ChT57KOF0kwIpaUHI1r5qYbEkYyl8zGR41seIh+k=
Date:   Wed, 05 Apr 2023 19:29:32 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        ouyangweizhao@zeku.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm64-mte-rename-tco-routines-v2.patch removed from -mm tree
Message-Id: <20230406022933.5E87CC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: mte: rename TCO routines
has been removed from the -mm tree.  Its filename was
     arm64-mte-rename-tco-routines-v2.patch

This patch was dropped because it was folded into arm64-mte-rename-tco-routines.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: arm64: mte: rename TCO routines
Date: Wed, 29 Mar 2023 20:37:46 +0200

drop __ from mte_disable/enable_tco names, as those functions are to be
exported to KASAN code

Link: https://lkml.kernel.org/r/74d26337b2360733956114069e96ff11c296a944.1680114854.git.andreyknvl@google.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Weizhao Ouyang <ouyangweizhao@zeku.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/mte-kasan.h |   12 ++++++------
 arch/arm64/include/asm/uaccess.h   |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/arm64/include/asm/mte-kasan.h~arm64-mte-rename-tco-routines-v2
+++ a/arch/arm64/include/asm/mte-kasan.h
@@ -51,13 +51,13 @@ static inline bool system_uses_mte_async
  * The Tag check override (TCO) bit disables temporarily the tag checking
  * preventing the issue.
  */
-static inline void __mte_disable_tco(void)
+static inline void mte_disable_tco(void)
 {
 	asm volatile(ALTERNATIVE("nop", SET_PSTATE_TCO(0),
 				 ARM64_MTE, CONFIG_KASAN_HW_TAGS));
 }
 
-static inline void __mte_enable_tco(void)
+static inline void mte_enable_tco(void)
 {
 	asm volatile(ALTERNATIVE("nop", SET_PSTATE_TCO(1),
 				 ARM64_MTE, CONFIG_KASAN_HW_TAGS));
@@ -71,13 +71,13 @@ static inline void __mte_enable_tco(void
 static inline void __mte_disable_tco_async(void)
 {
 	if (system_uses_mte_async_or_asymm_mode())
-		__mte_disable_tco();
+		mte_disable_tco();
 }
 
 static inline void __mte_enable_tco_async(void)
 {
 	if (system_uses_mte_async_or_asymm_mode())
-		__mte_enable_tco();
+		mte_enable_tco();
 }
 
 /*
@@ -203,11 +203,11 @@ void mte_enable_kernel_asymm(void);
 
 #else /* CONFIG_ARM64_MTE */
 
-static inline void __mte_disable_tco(void)
+static inline void mte_disable_tco(void)
 {
 }
 
-static inline void __mte_enable_tco(void)
+static inline void mte_enable_tco(void)
 {
 }
 
--- a/arch/arm64/include/asm/uaccess.h~arm64-mte-rename-tco-routines-v2
+++ a/arch/arm64/include/asm/uaccess.h
@@ -138,7 +138,7 @@ static inline void __uaccess_enable_hw_p
 
 static inline void uaccess_disable_privileged(void)
 {
-	__mte_disable_tco();
+	mte_disable_tco();
 
 	if (uaccess_ttbr0_disable())
 		return;
@@ -148,7 +148,7 @@ static inline void uaccess_disable_privi
 
 static inline void uaccess_enable_privileged(void)
 {
-	__mte_enable_tco();
+	mte_enable_tco();
 
 	if (uaccess_ttbr0_enable())
 		return;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-empty-tagging-related-defines.patch
kasan-arm64-rename-tagging-related-routines.patch
arm64-mte-rename-tco-routines.patch
kasan-arm64-add-arch_suppress_tag_checks_start-stop.patch
kasan-arm64-add-arch_suppress_tag_checks_start-stop-v2.patch
kasan-suppress-recursive-reports-for-hw_tags.patch
kasan-suppress-recursive-reports-for-hw_tags-v2.patch
kcov-improve-documentation.patch
kcov-improve-documentation-v2.patch
kcov-improve-documentation-v3.patch

