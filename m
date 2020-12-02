Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE72AC6369E
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD7221D93
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgLBX7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727474AbgLBX7H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 18:59:07 -0500
Date:   Wed, 02 Dec 2020 15:58:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606953506;
        bh=tRHcEL9hgtr0fIGx3NPNcPlzkhkAiQ0t1ZlMjCXVadI=;
        h=From:To:Subject:From;
        b=zV4ImHuLf/VXtkM9vAj5DyViUf+3L2yqZM3vf8SxDMEdrTY0bAM2YJsya/iRotCG1
         POahp6Ud+aujSShbfy9qeoLlmCS7grCQCv7xZRuoinY3GR+cHgIktAWicXhJf6QfqJ
         ZB794pa0sngnAI14LdVnWqzcWZHzx5q3+/vQmXVA=
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, bgeffon@google.com, dave.hansen@intel.com,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, sandipan@linux.ibm.com,
        shuah@kernel.org, suxingxing@loongson.cn
Subject:  + selftest-vm-fix-build-error.patch added to -mm tree
Message-ID: <20201202235825.TpsQ0bwB6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm: fix build error
has been added to the -mm tree.  Its filename is
     selftest-vm-fix-build-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-fix-build-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-fix-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from suxingxing@loongson.cn are

selftest-vm-fix-build-error.patch

