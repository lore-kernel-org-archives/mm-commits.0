Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F060DC6FD1D
	for <mm-commits@archiver.kernel.org>; Fri, 17 Mar 2023 04:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCQE0p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Mar 2023 00:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCQE0o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2023 00:26:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDEF3FB9C
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 21:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B52B6219F
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 04:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618ADC433D2;
        Fri, 17 Mar 2023 04:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679027202;
        bh=Q86o6DKoiUxJYuf6DcFpmttgnDd+K+nVRd+tCejzx7Q=;
        h=Date:To:From:Subject:From;
        b=aMVKM/z1/46KRxLlLbwdhJmukgjXMGkzYZ+MQxleUCRZIg49kSmTPqFpNGeypmgZy
         Y5p62z4OXtYEZCPoHxGjZpqqIicDn87iF7Agh3h6jij+CniyenaG4tw3FPBJs19J8B
         oKPWyHFJ9vwCCJEB/iw0jKgxMeY8C3yjEt3gdhdk=
Date:   Thu, 16 Mar 2023 21:26:41 -0700
To:     mm-commits@vger.kernel.org, nathan@kernel.org, glider@google.com,
        dvyukov@google.com, elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] kfence-kcsan-avoid-passing-g-for-tests.patch removed from -mm tree
Message-Id: <20230317042642.618ADC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kfence, kcsan: avoid passing -g for tests
has been removed from the -mm tree.  Its filename was
     kfence-kcsan-avoid-passing-g-for-tests.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence, kcsan: avoid passing -g for tests
Date: Thu, 16 Mar 2023 16:51:04 +0100

Nathan reported that when building with GNU as and a version of clang that
defaults to DWARF5:

  $ make -skj"$(nproc)" ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- \
			LLVM=1 LLVM_IAS=0 O=build \
			mrproper allmodconfig mm/kfence/kfence_test.o
  /tmp/kfence_test-08a0a0.s: Assembler messages:
  /tmp/kfence_test-08a0a0.s:14627: Error: non-constant .uleb128 is not supported
  /tmp/kfence_test-08a0a0.s:14628: Error: non-constant .uleb128 is not supported
  /tmp/kfence_test-08a0a0.s:14632: Error: non-constant .uleb128 is not supported
  /tmp/kfence_test-08a0a0.s:14633: Error: non-constant .uleb128 is not supported
  /tmp/kfence_test-08a0a0.s:14639: Error: non-constant .uleb128 is not supported
  ...

This is because `-g` defaults to the compiler debug info default.  If the
assembler does not support some of the directives used, the above errors
occur.  To fix, remove the explicit passing of `-g`.

All these tests want is that stack traces print valid function names, and
debug info is not required for that.  I currently cannot recall why I
added the explicit `-g`.

Link: https://lkml.kernel.org/r/20230316155104.594662-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/kcsan/Makefile~kfence-kcsan-avoid-passing-g-for-tests
+++ a/kernel/kcsan/Makefile
@@ -16,6 +16,6 @@ obj-y := core.o debugfs.o report.o
 KCSAN_INSTRUMENT_BARRIERS_selftest.o := y
 obj-$(CONFIG_KCSAN_SELFTEST) += selftest.o
 
-CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -g -fno-omit-frame-pointer
+CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -fno-omit-frame-pointer
 CFLAGS_kcsan_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_KCSAN_KUNIT_TEST) += kcsan_test.o
--- a/mm/kfence/Makefile~kfence-kcsan-avoid-passing-g-for-tests
+++ a/mm/kfence/Makefile
@@ -2,5 +2,5 @@
 
 obj-y := core.o report.o
 
-CFLAGS_kfence_test.o := -g -fno-omit-frame-pointer -fno-optimize-sibling-calls
+CFLAGS_kfence_test.o := -fno-omit-frame-pointer -fno-optimize-sibling-calls
 obj-$(CONFIG_KFENCE_KUNIT_TEST) += kfence_test.o
_

Patches currently in -mm which might be from elver@google.com are

kasan-powerpc-dont-rename-memintrinsics-if-compiler-adds-prefixes.patch
kfence-avoid-passing-g-for-test.patch
kcsan-avoid-passing-g-for-test.patch

