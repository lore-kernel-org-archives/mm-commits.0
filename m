Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F0BC433ED
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 218E86101D
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbhDKWLD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235718AbhDKWLC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 18:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97E296008E;
        Sun, 11 Apr 2021 22:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618179045;
        bh=y+7oUbF+MIuZYp8NjazWFihj0LT00GHoqCC8Zgt4zxE=;
        h=Date:From:To:Subject:From;
        b=xmm95LyYLL9TizSy03dhA7mR4NVopcTj2JXdojxHAZxLqu0LK8xA6Amm1US1ezkLO
         KuP8SHAndqTRZhLdG/L2vJPe4TVqRG2xun87OKgu7XxHF/fh5YC9q+iGgPcF2rS/0f
         yUel2byOSuMQ+27JBx9F6PduHrUi9dVSCyhcx3Fk=
Date:   Sun, 11 Apr 2021 15:10:45 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        jesse.brandeburg@intel.com, guoren@kernel.org,
        rdunlap@infradead.org
Subject:  +
 csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error.patch added to -mm
 tree
Message-ID: <20210411221045.mujiB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: csky: change a Kconfig symbol name to fix e1000 build error
has been added to the -mm tree.  Its filename is
     csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-eliminate-expecting-prototype-kernel-doc-warnings.patch
csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error.patch
vfs-fs_parser-clean-up-kernel-doc-warnings.patch
lib-parser-clean-up-kernel-doc.patch

