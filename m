Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFB2C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7FE322CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781473;
	bh=O7UkGCmIaQsRzlwYMDLRds2JWhI++2Unus3K9L/h+Ms=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=R9Z1fy6sh/cGQukcNu9mBgQ8pZ8vrt567Ynrmv1rK1Ap2lQwr8SCKESpfZdZZ/yo/
	 gVM+Q3mg+LYTmT68zvrYO8PKzQpmPm6P0atO2QK8c72VKmtwuj90j4Ug5lQdjbRlBR
	 SnRyz2OvsTIbFZ8U4HuedifcKpbR8T+g/TQJHRkY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGGYd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGYd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C25E22CAE;
        Fri,  7 Aug 2020 06:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781472;
        bh=O7UkGCmIaQsRzlwYMDLRds2JWhI++2Unus3K9L/h+Ms=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=F4H/PHk08xSdqm1uleXkPYVAd++k470U+sAD7H6IQ/qBKxujbULjuRUggNo88JYZS
         VqLDKyrN+JotcDSNKKsK9Plim+ZzzZxiMEa7GKiYciuCT4pDrjAVt+i/Rkd3G5FNML
         coirlf8tMiAANxTZ2IsxUlqDTDAARtvj1IPwVxko=
Date:   Thu, 06 Aug 2020 23:24:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, arnd@arndb.de,
        aryabinin@virtuozzo.com, dja@axtens.net, dvyukov@google.com,
        elver@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, torvalds@linux-foundation.org,
        walter-zh.wu@mediatek.com
Subject:  [patch 129/163] kasan: update required compiler versions
 in documentation
Message-ID: <20200807062431.ohz9Pz_Qw%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kasan: update required compiler versions in documentation

Updates the recently changed compiler requirements for KASAN.  In
particular, we require GCC >= 8.3.0, and add a note that Clang 11 supports
OOB detection of globals.

Link: http://lkml.kernel.org/r/20200629104157.3242503-2-elver@google.com
Fixes: 7b861a53e46b ("kasan: Bump required compiler version")
Fixes: acf7b0bf7dcf ("kasan: Fix required compiler version")
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Axtens <dja@axtens.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    7 ++-----
 lib/Kconfig.kasan                 |   24 +++++++++++++++---------
 2 files changed, 17 insertions(+), 14 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-update-required-compiler-versions-in-documentation
+++ a/Documentation/dev-tools/kasan.rst
@@ -13,11 +13,8 @@ KASAN uses compile-time instrumentation
 memory access, and therefore requires a compiler version that supports that.
 
 Generic KASAN is supported in both GCC and Clang. With GCC it requires version
-4.9.2 or later for basic support and version 5.0 or later for detection of
-out-of-bounds accesses for stack and global variables and for inline
-instrumentation mode (see the Usage section). With Clang it requires version
-7.0.0 or later and it doesn't support detection of out-of-bounds accesses for
-global variables yet.
+8.3.0 or later. With Clang it requires version 7.0.0 or later, but detection of
+out-of-bounds accesses for global variables is only supported since Clang 11.
 
 Tag-based KASAN is only supported in Clang and requires version 7.0.0 or later.
 
--- a/lib/Kconfig.kasan~kasan-update-required-compiler-versions-in-documentation
+++ a/lib/Kconfig.kasan
@@ -40,6 +40,7 @@ choice
 	  software tag-based KASAN (a version based on software memory
 	  tagging, arm64 only, similar to userspace HWASan, enabled with
 	  CONFIG_KASAN_SW_TAGS).
+
 	  Both generic and tag-based KASAN are strictly debugging features.
 
 config KASAN_GENERIC
@@ -51,16 +52,18 @@ config KASAN_GENERIC
 	select STACKDEPOT
 	help
 	  Enables generic KASAN mode.
-	  Supported in both GCC and Clang. With GCC it requires version 4.9.2
-	  or later for basic support and version 5.0 or later for detection of
-	  out-of-bounds accesses for stack and global variables and for inline
-	  instrumentation mode (CONFIG_KASAN_INLINE). With Clang it requires
-	  version 3.7.0 or later and it doesn't support detection of
-	  out-of-bounds accesses for global variables yet.
+
+	  This mode is supported in both GCC and Clang. With GCC it requires
+	  version 8.3.0 or later. With Clang it requires version 7.0.0 or
+	  later, but detection of out-of-bounds accesses for global variables
+	  is supported only since Clang 11.
+
 	  This mode consumes about 1/8th of available memory at kernel start
 	  and introduces an overhead of ~x1.5 for the rest of the allocations.
 	  The performance slowdown is ~x3.
+
 	  For better error detection enable CONFIG_STACKTRACE.
+
 	  Currently CONFIG_KASAN_GENERIC doesn't work with CONFIG_DEBUG_SLAB
 	  (the resulting kernel does not boot).
 
@@ -73,15 +76,19 @@ config KASAN_SW_TAGS
 	select STACKDEPOT
 	help
 	  Enables software tag-based KASAN mode.
+
 	  This mode requires Top Byte Ignore support by the CPU and therefore
-	  is only supported for arm64.
-	  This mode requires Clang version 7.0.0 or later.
+	  is only supported for arm64. This mode requires Clang version 7.0.0
+	  or later.
+
 	  This mode consumes about 1/16th of available memory at kernel start
 	  and introduces an overhead of ~20% for the rest of the allocations.
 	  This mode may potentially introduce problems relating to pointer
 	  casting and comparison, as it embeds tags into the top byte of each
 	  pointer.
+
 	  For better error detection enable CONFIG_STACKTRACE.
+
 	  Currently CONFIG_KASAN_SW_TAGS doesn't work with CONFIG_DEBUG_SLAB
 	  (the resulting kernel does not boot).
 
@@ -107,7 +114,6 @@ config KASAN_INLINE
 	  memory accesses. This is faster than outline (in some workloads
 	  it gives about x2 boost over outline instrumentation), but
 	  make kernel's .text size much bigger.
-	  For CONFIG_KASAN_GENERIC this requires GCC 5.0 or later.
 
 endchoice
 
_
