Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D711C4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 19:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BE5623B85
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 19:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgLRTEi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 14:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbgLRTEi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 14:04:38 -0500
Date:   Fri, 18 Dec 2020 11:03:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608318237;
        bh=jgb+LCvRHtnmn9oc4qD/ihVZnR5QZzrXuTgf/e6fCv0=;
        h=From:To:Subject:From;
        b=OCgpvHywf0Rt3uOjvk0Lx+EqQHgSYYaEHH0SJb6Lf9eZkSYHSmHAn9x+252p4eFH3
         VPlLc6ayJVgkwB+nCOWn0uWTEWkszk0yn9zrb2jnyjQDepSoB4hoZ4tJ0LPqPMUIIh
         OYNVqku2XKaZ2TLtgaiBzxKyxI4Ie3Ip4g4iGHjg=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, suxingxing@loongson.cn,
        shuah@kernel.org, sandipan@linux.ibm.com,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        dave.hansen@intel.com, bgeffon@google.com, almasrymina@google.com,
        harish@linux.ibm.com
Subject:  [to-be-updated]
 selftests-vm-fix-building-protection-keys-test.patch removed from -mm tree
Message-ID: <20201218190355.MT8V9%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix building protection keys test
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-building-protection-keys-test.patch

This patch was dropped because an updated version will be merged

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
@@ -65,7 +65,7 @@ TEST_GEN_FILES += $(BINARIES_64)
 endif
 else
 
-ifneq (,$(findstring $(ARCH),powerpc))
+ifneq (,$(filter $(MACHINE),ppc64 ppc64le))
 TEST_GEN_FILES += protection_keys
 endif
 
_

Patches currently in -mm which might be from harish@linux.ibm.com are


