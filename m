Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F8AC4361B
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 22:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CAEF224F9
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 22:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733021AbgLNW3B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 17:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388281AbgLNW2w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 17:28:52 -0500
Date:   Mon, 14 Dec 2020 14:28:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607984892;
        bh=YGfvl7qPtSMxLvXkAGJSfCzmoHKSGxDw5h35sHiV8g4=;
        h=From:To:Subject:From;
        b=FYU40Wg6NyJzcB480dM90nhGKntEPLj1aGaWB48F/4h7L8pX0rm7mSteMQebJmDH8
         M9/z33gDrPe8LzWM+6hjDD5X1lon5nkv6lkEz4olJ+wjnjN+kU+XD2RrLcFjZ+cO6B
         UvaTd/JrzmLeKWOQx1tTQaDL8CA7V1fol5Cln6b4=
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, bgeffon@google.com, dave.hansen@intel.com,
        harish@linux.ibm.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        sandipan@linux.ibm.com, shuah@kernel.org, suxingxing@loongson.cn
Subject:  + selftests-vm-fix-building-protection-keys-test.patch
 added to -mm tree
Message-ID: <20201214222811.MAcwrP3NF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

The previous patch tries to include a arch check for powerpc using
findstring, which prevents test from building on powerpc arch. Fix
this with filtering using machine type.

Link: https://lkml.kernel.org/r/20201214163951.141399-1-harish@linux.ibm.com
Signed-off-by: Harish <harish@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Xingxing Su <suxingxing@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-fix-building-protection-keys-test
+++ a/tools/testing/selftests/vm/Makefile
@@ -64,7 +64,7 @@ TEST_GEN_FILES += $(BINARIES_64)
 endif
 else
 
-ifneq (,$(findstring $(ARCH),powerpc))
+ifneq (,$(filter $(MACHINE),ppc64 ppc64le))
 TEST_GEN_FILES += protection_keys
 endif
 
_

Patches currently in -mm which might be from harish@linux.ibm.com are

selftests-vm-fix-building-protection-keys-test.patch

