Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33248C43460
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15416613D0
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbhDPWq3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234886AbhDPWq3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 18:46:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7645613C5;
        Fri, 16 Apr 2021 22:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618613164;
        bh=ytx6+4DTJiG2NCVdX4/gmn07cXj7Ez1WCP0+zhLVoWY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0fhAb9mfDfYjYErLqXXjriNrgmbi9BEyjheY+5NJlmax1tdCZwVezcfYb1NqqkWpQ
         QSkE3ucT9N8+csdQb+qWv5l11qBWLpmnNttRhNeNFz4KL3NNKbJiF3dezFHlK8Jcsf
         Txsy8xkRzxhbf73NkH4BBcjprA7VvG+4Yx8MMT/c=
Date:   Fri, 16 Apr 2021 15:46:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guoren@kernel.org,
        jesse.brandeburg@intel.com, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 04/12] csky: change a Kconfig symbol name to fix
 e1000 build error
Message-ID: <20210416224603.EETOY2Or4%akpm@linux-foundation.org>
In-Reply-To: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: csky: change a Kconfig symbol name to fix e1000 build error

e1000's #define of CONFIG_RAM_BASE conflicts with a Kconfig symbol in
arch/csky/Kconfig.

The symbol in e1000 has been around longer, so change arch/csky/ to use
DRAM_BASE instead of RAM_BASE to remove the conflict.  (although e1000 is
also a 2-line change)

Link: https://lkml.kernel.org/r/20210411055335.7111-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Guo Ren <guoren@kernel.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/Kconfig            |    2 +-
 arch/csky/include/asm/page.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/csky/include/asm/page.h~csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error
+++ a/arch/csky/include/asm/page.h
@@ -28,7 +28,7 @@
 #define SSEG_SIZE	0x20000000
 #define LOWMEM_LIMIT	(SSEG_SIZE * 2)
 
-#define PHYS_OFFSET_OFFSET (CONFIG_RAM_BASE & (SSEG_SIZE - 1))
+#define PHYS_OFFSET_OFFSET (CONFIG_DRAM_BASE & (SSEG_SIZE - 1))
 
 #ifndef __ASSEMBLY__
 
--- a/arch/csky/Kconfig~csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error
+++ a/arch/csky/Kconfig
@@ -314,7 +314,7 @@ config FORCE_MAX_ZONEORDER
 	int "Maximum zone order"
 	default "11"
 
-config RAM_BASE
+config DRAM_BASE
 	hex "DRAM start addr (the same with memory-section in dts)"
 	default 0x0
 
_
