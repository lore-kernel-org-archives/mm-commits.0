Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A443C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BC7422CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781470;
	bh=dhAo2gmJ4vXW1hjr+f98r/MLZV8nTeCpfrzyHlHc5/Y=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1eRD1nsUgevbIKLba3qYHBxErVh8Z9nGtIWBopOSkuVcxoduD5ZAPFtIoKC6OjFeK
	 5rQtS6RRmbNFYJ0GQla8wzDL8c0vWu6tsv4zqydgp3ufAcrRUXsxstzHgXtpB5ZhyF
	 AGryXm2u5xim6Lke1kcI62DP7xK/Jfmsjoszidhg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHGGY3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGY3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A54B522C9F;
        Fri,  7 Aug 2020 06:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781469;
        bh=dhAo2gmJ4vXW1hjr+f98r/MLZV8nTeCpfrzyHlHc5/Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kW+vVCKlqaVwFmK7anfifE6ltS7MCziCDFYmgLBnrnQ24N773J39mtn9s+1z1UMjD
         PfTtZQIjlP2o8s25VcqCOmVJo34oVOrO7uzkBSxqaozopRnhMJDvTiBA9+kn4SN3I+
         VYCBt3lhsbGpGs68yLIm1tuKBr79GRjOiha5zrgY=
Date:   Thu, 06 Aug 2020 23:24:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, arnd@arndb.de,
        aryabinin@virtuozzo.com, dja@axtens.net, dvyukov@google.com,
        elver@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, torvalds@linux-foundation.org,
        walter-zh.wu@mediatek.com
Subject:  [patch 128/163] kasan: improve and simplify Kconfig.kasan
Message-ID: <20200807062428.Ep04HKe5D%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kasan: improve and simplify Kconfig.kasan

Turn 'KASAN' into a menuconfig, to avoid cluttering its parent menu with
the suboptions if enabled.  Use 'if KASAN ...  endif' instead of having to
'depend on KASAN' for each entry.

Link: http://lkml.kernel.org/r/20200629104157.3242503-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/lib/Kconfig.kasan~kasan-improve-and-simplify-kconfigkasan
+++ a/lib/Kconfig.kasan
@@ -18,7 +18,7 @@ config CC_HAS_KASAN_SW_TAGS
 config CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	def_bool !CC_IS_GCC || GCC_VERSION >= 80300
 
-config KASAN
+menuconfig KASAN
 	bool "KASAN: runtime memory debugger"
 	depends on (HAVE_ARCH_KASAN && CC_HAS_KASAN_GENERIC) || \
 		   (HAVE_ARCH_KASAN_SW_TAGS && CC_HAS_KASAN_SW_TAGS)
@@ -29,9 +29,10 @@ config KASAN
 	  designed to find out-of-bounds accesses and use-after-free bugs.
 	  See Documentation/dev-tools/kasan.rst for details.
 
+if KASAN
+
 choice
 	prompt "KASAN mode"
-	depends on KASAN
 	default KASAN_GENERIC
 	help
 	  KASAN has two modes: generic KASAN (similar to userspace ASan,
@@ -88,7 +89,6 @@ endchoice
 
 choice
 	prompt "Instrumentation type"
-	depends on KASAN
 	default KASAN_OUTLINE
 
 config KASAN_OUTLINE
@@ -113,7 +113,6 @@ endchoice
 
 config KASAN_STACK_ENABLE
 	bool "Enable stack instrumentation (unsafe)" if CC_IS_CLANG && !COMPILE_TEST
-	depends on KASAN
 	help
 	  The LLVM stack address sanitizer has a know problem that
 	  causes excessive stack usage in a lot of functions, see
@@ -134,7 +133,7 @@ config KASAN_STACK
 
 config KASAN_S390_4_LEVEL_PAGING
 	bool "KASan: use 4-level paging"
-	depends on KASAN && S390
+	depends on S390
 	help
 	  Compiling the kernel with KASan disables automatic 3-level vs
 	  4-level paging selection. 3-level paging is used by default (up
@@ -151,7 +150,7 @@ config KASAN_SW_TAGS_IDENTIFY
 
 config KASAN_VMALLOC
 	bool "Back mappings in vmalloc space with real shadow memory"
-	depends on KASAN && HAVE_ARCH_KASAN_VMALLOC
+	depends on HAVE_ARCH_KASAN_VMALLOC
 	help
 	  By default, the shadow region for vmalloc space is the read-only
 	  zero page. This means that KASAN cannot detect errors involving
@@ -164,8 +163,10 @@ config KASAN_VMALLOC
 
 config TEST_KASAN
 	tristate "Module for testing KASAN for bug detection"
-	depends on m && KASAN
+	depends on m
 	help
 	  This is a test module doing various nasty things like
 	  out of bounds accesses, use after free. It is useful for testing
 	  kernel debugging features like KASAN.
+
+endif # KASAN
_
