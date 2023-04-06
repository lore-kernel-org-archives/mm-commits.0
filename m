Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E41AC77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbjDFCou (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234957AbjDFCo1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4BC9008
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DCAC6429F
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FAFC433D2;
        Thu,  6 Apr 2023 02:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749064;
        bh=bsQ6amaBOX6Icp44UBcMcsknI/7QUr1I31ExG/lHGWQ=;
        h=Date:To:From:Subject:From;
        b=mn0VgC3RZBhwZRhrY8nZ0bOCGTC+9V3T6shtELoKn+SeCR7JCiJDk4yqq4gTRK0qW
         grk49uINR9d8y+C0i/0S3peJBpF/nDC8hg+pcirNVZynDdY2eMvjSinptbJJpMhKCb
         IZxGeXeR0UE3/FOCz1366Wy32L+xP1X+DO6/kF4Y=
Date:   Wed, 05 Apr 2023 19:44:24 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        ouyangweizhao@zeku.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-arm64-add-arch_suppress_tag_checks_start-stop.patch removed from -mm tree
Message-Id: <20230406024424.A7FAFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan, arm64: add arch_suppress_tag_checks_start/stop
has been removed from the -mm tree.  Its filename was
     kasan-arm64-add-arch_suppress_tag_checks_start-stop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: add arch_suppress_tag_checks_start/stop
Date: Sat, 11 Mar 2023 00:43:32 +0100

Add two new tagging-related routines arch_suppress_tag_checks_start/stop
that suppress MTE tag checking via the TCO register.

These rouines are used in the next patch.

[andreyknvl@google.com: drop __ from mte_disable/enable_tco names]
  Link: https://lkml.kernel.org/r/7ad5e5a9db79e3aba08d8f43aca24350b04080f6.1680114854.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/75a362551c3c54b70ae59a3492cabb51c105fa6b.1678491668.git.andreyknvl@google.com
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

 arch/arm64/include/asm/memory.h |    2 ++
 mm/kasan/kasan.h                |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/arm64/include/asm/memory.h~kasan-arm64-add-arch_suppress_tag_checks_start-stop
+++ a/arch/arm64/include/asm/memory.h
@@ -264,6 +264,8 @@ static inline const void *__tag_set(cons
 #define arch_enable_tag_checks_sync()		mte_enable_kernel_sync()
 #define arch_enable_tag_checks_async()		mte_enable_kernel_async()
 #define arch_enable_tag_checks_asymm()		mte_enable_kernel_asymm()
+#define arch_suppress_tag_checks_start()	mte_enable_tco()
+#define arch_suppress_tag_checks_stop()		mte_disable_tco()
 #define arch_force_async_tag_fault()		mte_check_tfsr_exit()
 #define arch_get_random_tag()			mte_get_random_tag()
 #define arch_get_mem_tag(addr)			mte_get_mem_tag(addr)
--- a/mm/kasan/kasan.h~kasan-arm64-add-arch_suppress_tag_checks_start-stop
+++ a/mm/kasan/kasan.h
@@ -398,6 +398,8 @@ static inline const void *arch_kasan_set
 #define hw_enable_tag_checks_sync()		arch_enable_tag_checks_sync()
 #define hw_enable_tag_checks_async()		arch_enable_tag_checks_async()
 #define hw_enable_tag_checks_asymm()		arch_enable_tag_checks_asymm()
+#define hw_suppress_tag_checks_start()		arch_suppress_tag_checks_start()
+#define hw_suppress_tag_checks_stop()		arch_suppress_tag_checks_stop()
 #define hw_force_async_tag_fault()		arch_force_async_tag_fault()
 #define hw_get_random_tag()			arch_get_random_tag()
 #define hw_get_mem_tag(addr)			arch_get_mem_tag(addr)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kcov-improve-documentation.patch
kcov-improve-documentation-v2.patch
kcov-improve-documentation-v3.patch

