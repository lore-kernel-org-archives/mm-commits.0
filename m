Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72019C4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 19:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EA9223B75
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 19:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgLRTgR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 14:36:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbgLRTgR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 14:36:17 -0500
Date:   Fri, 18 Dec 2020 11:35:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608320136;
        bh=78gYtKlt7noJXwOfumbGQIv5PU1Umq/MdP2HF9n2sdk=;
        h=From:To:Subject:From;
        b=yUi6YfViIKc5/JgPGFhZIAjnorWKwP4NOkHzyLmd7yVVGNggVhqnd4XMJ6b5KZiEA
         QmFlBY8uENQfpvDGeoGOPVf3WXtxfrTcQdkXM8JnP41Ja3U/09TMhPVOErFnQanIAX
         fmTytyofSj0EjKUYJ/9z3bsawdA9cEM3lrRRddOE=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        sandipan@linux.ibm.com, kirill.shutemov@linux.intel.com,
        jhubbard@nvidia.com, dave.hansen@intel.com, harish@linux.ibm.com
Subject:  + selftests-vm-fix-building-protection-keys-test.patch
 added to -mm tree
Message-ID: <20201218193536.O__MO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix building protection keys test
has been added to the -mm tree.  Its filename is
     selftests-vm-fix-building-protection-keys-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-fix-building-protection-keys-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-fix-building-protection-keys-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Harish <harish@linux.ibm.com>
Subject: selftests/vm: fix building protection keys test

The patch d8cbe8bfa7d tries to include a ARCH check for powerpc, however
ARCH is not defined in the Makefile before including lib.mk.  This makes
test building to skip on both x86 and powerpc.  Fix the arch check by
replacing it using machine type as it is already defined and used in the
test.

Link: https://lkml.kernel.org/r/20201215100402.257376-1-harish@linux.ibm.com
Fixes: d8cbe8bfa7d ("tools/testing/selftests/vm: fix build error")
Signed-off-by: Harish <harish@linux.ibm.com>
Reviewed-by: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-fix-building-protection-keys-test
+++ a/tools/testing/selftests/vm/Makefile
@@ -4,7 +4,7 @@
 include local_config.mk
 
 uname_M := $(shell uname -m 2>/dev/null || echo not)
-MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/')
+MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/ppc64/')
 
 # Without this, failed build products remain, with up-to-date timestamps,
 # thus tricking Make (and you!) into believing that All Is Well, in subsequent
@@ -43,7 +43,7 @@ TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 
-ifeq ($(ARCH),x86_64)
+ifeq ($(MACHINE),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_32bit_program.c -m32)
 CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_program.c -no-pie)
@@ -65,13 +65,13 @@ TEST_GEN_FILES += $(BINARIES_64)
 endif
 else
 
-ifneq (,$(findstring $(ARCH),powerpc))
+ifneq (,$(findstring $(MACHINE),ppc64))
 TEST_GEN_FILES += protection_keys
 endif
 
 endif
 
-ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64))
+ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sh64 sparc64 x86_64))
 TEST_GEN_FILES += va_128TBswitch
 TEST_GEN_FILES += virtual_address_range
 TEST_GEN_FILES += write_to_hugetlbfs
@@ -84,7 +84,7 @@ TEST_FILES := test_vmalloc.sh
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
 
-ifeq ($(ARCH),x86_64)
+ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
 BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
 
_

Patches currently in -mm which might be from harish@linux.ibm.com are

selftests-vm-fix-building-protection-keys-test.patch

