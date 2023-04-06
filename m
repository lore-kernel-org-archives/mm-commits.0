Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC5EC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbjDFCag (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbjDFCaf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:30:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9547ED3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2205262B47
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3C2C433D2;
        Thu,  6 Apr 2023 02:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748233;
        bh=333EF/J8duC1lwqRGGStU5icWvibsXocs7ZKEdrjQSw=;
        h=Date:To:From:Subject:From;
        b=qsAKV8Hd6P5gjP+c95r2c0N5YJ2o5CkJsCBMjbzjQ4VoAPmHneu0n4DStSnuJHVAv
         QAKewhwsRJaMj+9xmY0pURjy28OD5Ok5BHnj6F13kOIu0/ADgwPHqNxD1WCpxmxhvo
         9WLL5YeYmKnZKJt8wU/9mmuW7wZC96zhalTa4uOs=
Date:   Wed, 05 Apr 2023 19:30:32 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        ouyangweizhao@zeku.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-arm64-add-arch_suppress_tag_checks_start-stop-v2.patch removed from -mm tree
Message-Id: <20230406023033.7A3C2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan, arm64: add arch_suppress_tag_checks_start/stop
has been removed from the -mm tree.  Its filename was
     kasan-arm64-add-arch_suppress_tag_checks_start-stop-v2.patch

This patch was dropped because it was folded into kasan-arm64-add-arch_suppress_tag_checks_start-stop.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: add arch_suppress_tag_checks_start/stop
Date: Wed, 29 Mar 2023 20:37:47 +0200

drop __ from mte_disable/enable_tco names, as those functions are to be
exported to KASAN code

Link: https://lkml.kernel.org/r/7ad5e5a9db79e3aba08d8f43aca24350b04080f6.1680114854.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Weizhao Ouyang <ouyangweizhao@zeku.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/memory.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/memory.h~kasan-arm64-add-arch_suppress_tag_checks_start-stop-v2
+++ a/arch/arm64/include/asm/memory.h
@@ -264,8 +264,8 @@ static inline const void *__tag_set(cons
 #define arch_enable_tag_checks_sync()		mte_enable_kernel_sync()
 #define arch_enable_tag_checks_async()		mte_enable_kernel_async()
 #define arch_enable_tag_checks_asymm()		mte_enable_kernel_asymm()
-#define arch_suppress_tag_checks_start()	__mte_enable_tco()
-#define arch_suppress_tag_checks_stop()		__mte_disable_tco()
+#define arch_suppress_tag_checks_start()	mte_enable_tco()
+#define arch_suppress_tag_checks_stop()		mte_disable_tco()
 #define arch_force_async_tag_fault()		mte_check_tfsr_exit()
 #define arch_get_random_tag()			mte_get_random_tag()
 #define arch_get_mem_tag(addr)			mte_get_mem_tag(addr)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-empty-tagging-related-defines.patch
kasan-arm64-rename-tagging-related-routines.patch
kasan-arm64-add-arch_suppress_tag_checks_start-stop.patch
kasan-suppress-recursive-reports-for-hw_tags.patch
kasan-suppress-recursive-reports-for-hw_tags-v2.patch
kcov-improve-documentation.patch
kcov-improve-documentation-v2.patch
kcov-improve-documentation-v3.patch

