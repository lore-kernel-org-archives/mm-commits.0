Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF9DEB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jun 2023 21:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjFNVY5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jun 2023 17:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbjFNVYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jun 2023 17:24:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4C72689
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 14:24:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C132861C28
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 21:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F9CC433C8;
        Wed, 14 Jun 2023 21:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686777883;
        bh=8SW8j+y7G8vRJMbrzbkG+i9vguKQVeuGwPIPgcq06JQ=;
        h=Date:To:From:Subject:From;
        b=maCzyIsgeBk1DRAWe4rvkroG1MxgtOfZuN+bavfW7KWRbd64OYhwct9esEw09kkBX
         wkco7VLETtOTFM/Gy/5Ce0QKQuhd9300+GsZeIz9V7Onw/pUo48PBOfICsL0iSIQ+r
         llpdhOIeRjKC0l+PyoL0x7BrhBhkwsrTtkaerITE=
Date:   Wed, 14 Jun 2023 14:24:42 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, shuah@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        ndesaulniers@google.com, nathan@kernel.org, aou@eecs.berkeley.edu,
        broonie@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-cross-compilation-with-llvm.patch added to mm-hotfixes-unstable branch
Message-Id: <20230614212443.21F9CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix cross compilation with LLVM
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-cross-compilation-with-llvm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-cross-compilation-with-llvm.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: fix cross compilation with LLVM
Date: Wed, 14 Jun 2023 22:18:58 +0100

Currently the MM selftests attempt to work out the target architecture by
using CROSS_COMPILE or otherwise querying the host machine, storing the
target architecture in a variable called MACHINE rather than the usual
ARCH though as far as I can tell (including for x86_64) the value is the
same as we would use for architecture.

When cross compiling with LLVM we don't need a CROSS_COMPILE as LLVM can
support many target architectures in a single build so this logic does not
work, CROSS_COMPILE is not set and we end up selecting tests for the host
rather than target architecture.  Fix this by using the more standard ARCH
to describe the architecture, taking it from the environment if specified.

Link: https://lkml.kernel.org/r/20230614-kselftest-mm-llvm-v1-1-180523f277d3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-fix-cross-compilation-with-llvm
+++ a/tools/testing/selftests/mm/Makefile
@@ -5,12 +5,15 @@ LOCAL_HDRS += $(selfdir)/mm/local_config
 
 include local_config.mk
 
+ifeq ($(ARCH),)
+
 ifeq ($(CROSS_COMPILE),)
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 else
 uname_M := $(shell echo $(CROSS_COMPILE) | grep -o '^[a-z0-9]\+')
 endif
-MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/ppc64/')
+ARCH ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/ppc64/')
+endif
 
 # Without this, failed build products remain, with up-to-date timestamps,
 # thus tricking Make (and you!) into believing that All Is Well, in subsequent
@@ -65,7 +68,7 @@ TEST_GEN_PROGS += ksm_tests
 TEST_GEN_PROGS += ksm_functional_tests
 TEST_GEN_PROGS += mdwe_test
 
-ifeq ($(MACHINE),x86_64)
+ifeq ($(ARCH),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
 CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_program.c -no-pie)
@@ -87,13 +90,13 @@ TEST_GEN_PROGS += $(BINARIES_64)
 endif
 else
 
-ifneq (,$(findstring $(MACHINE),ppc64))
+ifneq (,$(findstring $(ARCH),ppc64))
 TEST_GEN_PROGS += protection_keys
 endif
 
 endif
 
-ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sparc64 x86_64))
+ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sparc64 x86_64))
 TEST_GEN_PROGS += va_high_addr_switch
 TEST_GEN_PROGS += virtual_address_range
 TEST_GEN_PROGS += write_to_hugetlbfs
@@ -112,7 +115,7 @@ $(TEST_GEN_PROGS): vm_util.c
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
 
-ifeq ($(MACHINE),x86_64)
+ifeq ($(ARCH),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
 BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
 
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-fix-cross-compilation-with-llvm.patch

