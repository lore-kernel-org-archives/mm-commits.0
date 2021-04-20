Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720FDC43462
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3806161406
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhDTW4O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 18:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhDTW4N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 18:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD92E613E7;
        Tue, 20 Apr 2021 22:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618959341;
        bh=9qzy94FBfYd3BGJ02vY3GwZ59cwVXej+NaDEcNeXulg=;
        h=Date:From:To:Subject:From;
        b=HcRJ9nUA4ECM2ALmcj1prLMv4zK5MDKMOTa037Erajw12oxN9Hx3VpcvwGa8cyMLs
         EbhcKkw0zefbBrVIidLhezMhuZhumNuZSOV3JZ0tTvbGVNcUcvm5NjoZyVHEDpOAIH
         ek6L0YdRMvtspdJh9JTMo080J5ud/+guzrBxsxAQ=
Date:   Tue, 20 Apr 2021 15:55:40 -0700
From:   akpm@linux-foundation.org
To:     fenghua.yu@intel.com, geert@linux-m68k.org, hch@lst.de,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        tony.luck@intel.com
Subject:  [merged]
 ia64-remove-duplicate-entries-in-generic_defconfig.patch removed from -mm
 tree
Message-ID: <20210420225540.O70He0YDX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: remove duplicate entries in generic_defconfig
has been removed from the -mm tree.  Its filename was
     ia64-remove-duplicate-entries-in-generic_defconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

vfs-fs_parser-clean-up-kernel-doc-warnings.patch
lib-parser-clean-up-kernel-doc.patch

