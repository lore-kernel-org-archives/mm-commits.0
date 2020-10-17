Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A025C433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47E1F208B6
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976419;
	bh=HS242CeKxVh1MmljEzFukdz2v+/3iS3zJnh37idj+xQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=iuNb1nR/xS+2FCTeCO4mZhx2C9x41rQhZozXpF73bZjH8WVwyxJYM/f7Pyv2eUpfx
	 CFsuodu+JNA9wkma6s98zWjcf95C22UdlcDkJlz73wQiXufbLNfQv8DJd4glWs9h8S
	 JWbjys8MldtCnr9cUxEDNTtKQ44urD0cpaqKhCjk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439879AbgJQXNj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXNi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:13:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293D320878;
        Sat, 17 Oct 2020 23:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976418;
        bh=HS242CeKxVh1MmljEzFukdz2v+/3iS3zJnh37idj+xQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vaRz5bnSZs48U0meeCB9SzxTN8zGoOGOvAHbfLCExWl4sd+H44kJaI2owjxe3jJsR
         bzgp26I/6MRqs8v0+eI0emTs0ZJaTL/oLgm/djmsF+Lb/WoN3t3z4JqFC61rkbe5I2
         +SE7uqAR3mXNHeTQbIk/zgjKCa0txgJRK3id4EFc=
Date:   Sat, 17 Oct 2020 16:13:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fenghua.yu@intel.com, krzk@kernel.org,
        linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 01/40] ia64: fix build error with !COREDUMP
Message-ID: <20201017231337.Vvr0NUSA4%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: ia64: fix build error with !COREDUMP

Fix linkage error when CONFIG_BINFMT_ELF is selected but CONFIG_COREDUMP
is not:

    ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_phdrs':
    elfcore.c:(.text+0x172): undefined reference to `dump_emit'
    ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_data':
    elfcore.c:(.text+0x2b2): undefined reference to `dump_emit'

Link: https://lkml.kernel.org/r/20200819064146.12529-1-krzk@kernel.org
Fixes: 1fcccbac89f5 ("elf coredump: replace ELF_CORE_EXTRA_* macros by functions")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/Makefile~ia64-fix-build-error-with-coredump
+++ a/arch/ia64/kernel/Makefile
@@ -40,7 +40,7 @@ obj-y				+= esi_stub.o	# must be in kern
 endif
 obj-$(CONFIG_INTEL_IOMMU)	+= pci-dma.o
 
-obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o
+obj-$(CONFIG_ELF_CORE)		+= elfcore.o
 
 # fp_emulate() expects f2-f5,f16-f31 to contain the user-level state.
 CFLAGS_traps.o  += -mfixed-range=f2-f5,f16-f31
_
