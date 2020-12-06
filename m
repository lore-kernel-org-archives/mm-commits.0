Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588C7C4361B
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 06:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1802E22D2A
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 06:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgLFGQC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Dec 2020 01:16:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgLFGQB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 6 Dec 2020 01:16:01 -0500
Date:   Sat, 05 Dec 2020 22:15:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607235303;
        bh=19d+bCl5PW06u7fz0lTdoweffI2aFMvA4VGQHKFoQoU=;
        h=From:To:Subject:In-Reply-To:From;
        b=mL7aKVMl85/+NbgIqrXHhhfPcoxmNItnOXGB6lAgI+MjIZ+ZRXvoTu/PzMi4XY1a+
         qJk++DnjryGIZ0/ZDb3bH684D6iWIaC8YOd+Cy6/j/wkngaqS6z81KC74LWrngVigV
         qi8uiykVDy5S9WoAKKIDuuZs8Eqza05VISb062n0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        bgeffon@google.com, dave.hansen@intel.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sandipan@linux.ibm.com,
        shuah@kernel.org, suxingxing@loongson.cn,
        torvalds@linux-foundation.org
Subject:  [patch 08/12] tools/testing/selftests/vm: fix build error
Message-ID: <20201206061502.wIrp8YXQT%akpm@linux-foundation.org>
In-Reply-To: <20201205221412.67f14b9b3a5ef531c76dd452@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xingxing Su <suxingxing@loongson.cn>
Subject: tools/testing/selftests/vm: fix build error

Only x86 and PowerPC implement the pkey-xxx.h, and an error was reported
when compiling protection_keys.c.

Add a Arch judgment to compile "protection_keys" in the Makefile.

If other arch implement this, add the arch name to the Makefile.
eg:
    ifneq (,$(findstring $(ARCH),powerpc mips ... ))

Following build errors:
    pkey-helpers.h:93:2: error: #error Architecture not supported
     #error Architecture not supported
    pkey-helpers.h:96:20: error: `PKEY_DISABLE_ACCESS' undeclared
     #define PKEY_MASK (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
                        ^
    protection_keys.c:218:45: error: `PKEY_DISABLE_WRITE' undeclared
     pkey_assert(flags & (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE));
                                                ^

Link: https://lkml.kernel.org/r/1606826876-30656-1-git-send-email-suxingxing@loongson.cn
Signed-off-by: Xingxing Su <suxingxing@loongson.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/vm/Makefile~selftest-vm-fix-build-error
+++ a/tools/testing/selftests/vm/Makefile
@@ -60,9 +60,13 @@ ifeq ($(CAN_BUILD_X86_64),1)
 TEST_GEN_FILES += $(BINARIES_64)
 endif
 else
+
+ifneq (,$(findstring $(ARCH),powerpc))
 TEST_GEN_FILES += protection_keys
 endif
 
+endif
+
 ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64))
 TEST_GEN_FILES += va_128TBswitch
 TEST_GEN_FILES += virtual_address_range
_
