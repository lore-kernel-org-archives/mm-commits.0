Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1939C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B403A223E0
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgLaSXX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:23:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgLaSXX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:23:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC0D6223DB;
        Thu, 31 Dec 2020 18:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438962;
        bh=NSL+kzgHYAQBlb7wF8KGoSjAGtr4U8T/Vk3rrHaw3Rs=;
        h=Date:From:To:Subject:From;
        b=Zk5WbrO4dly9VW0CstIshOe2UuEhK1dxlSBXUHRCpnZbIeNkHTyCHJM7bEHcqbp1a
         lFX4Y6vFyPh14sAid3K4dOx3LsRzQFFS1b7YmJY7KjqhDmoEkFbgmoM9pFwBKnlv0c
         Dlrk3oeKd16KrymB4UFB0HLOvDNzdIqFudQevxOQ=
Date:   Thu, 31 Dec 2020 10:22:41 -0800
From:   akpm@linux-foundation.org
To:     dave.hansen@intel.com, harish@linux.ibm.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        sandipan@linux.ibm.com, shuah@kernel.org
Subject:  [merged]
 selftests-vm-fix-building-protection-keys-test.patch removed from -mm tree
Message-ID: <20201231182241.SexzjZVhk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix building protection keys test
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-building-protection-keys-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


