Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAF3C433B4
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8149610CB
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhDKWSo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235474AbhDKWSn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 18:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC689601FB;
        Sun, 11 Apr 2021 22:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618179506;
        bh=BHutUrtGeYzZ9jDet3i4r+BUCTzbheX20IKrU23jCAU=;
        h=Date:From:To:Subject:From;
        b=bGblaiHVOHAsfL6SvlwMXNMbILlrqmaBzdjffZdjBKLmrFc5xIVEJubYvAVJ2y62Q
         yqsJYTFuffxhvIDJnu0ufgWH7uttqzGM6UDhiZtkYcumRTKc5jm/MVRYuzMEBgH01q
         FSDAZmUfXWfhF16v73ZKrxOnWGKZJpOzMJx38ZQ8=
Date:   Sun, 11 Apr 2021 15:18:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com, hch@lst.de,
        geert@linux-m68k.org, fenghua.yu@intel.com, rdunlap@infradead.org
Subject:  + ia64-remove-duplicate-entries-in-generic_defconfig.patch
 added to -mm tree
Message-ID: <20210411221826.gfOfd%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: remove duplicate entries in generic_defconfig
has been added to the -mm tree.  Its filename is
     ia64-remove-duplicate-entries-in-generic_defconfig.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-remove-duplicate-entries-in-generic_defconfig.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-remove-duplicate-entries-in-generic_defconfig.patch

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
Subject: ia64: remove duplicate entries in generic_defconfig

Fix ia64 generic_defconfig duplicate entries, as warned by:

  + arch/ia64/configs/generic_defconfig: warning: override: reassigning to symbol ATA:  => 58
  + arch/ia64/configs/generic_defconfig: warning: override: reassigning to symbol ATA_PIIX:  => 59

These 2 symbols still have the same value as in the removed lines.

Link: https://lkml.kernel.org/r/20210411020255.18052-1-rdunlap@infradead.org
Fixes: c331649e6371 ("ia64: Use libata instead of the legacy ide driver in defconfigs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/configs/generic_defconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/ia64/configs/generic_defconfig~ia64-remove-duplicate-entries-in-generic_defconfig
+++ a/arch/ia64/configs/generic_defconfig
@@ -55,8 +55,6 @@ CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_FC_ATTRS=y
 CONFIG_SCSI_SYM53C8XX_2=y
 CONFIG_SCSI_QLOGIC_1280=y
-CONFIG_ATA=y
-CONFIG_ATA_PIIX=y
 CONFIG_SATA_VITESSE=y
 CONFIG_MD=y
 CONFIG_BLK_DEV_MD=m
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-eliminate-expecting-prototype-kernel-doc-warnings.patch
csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error.patch
ia64-remove-duplicate-entries-in-generic_defconfig.patch
vfs-fs_parser-clean-up-kernel-doc-warnings.patch
lib-parser-clean-up-kernel-doc.patch

