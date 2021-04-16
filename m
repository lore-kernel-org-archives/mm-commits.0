Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF74C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61333613C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhDPWqe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234937AbhDPWqd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 18:46:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D09DD613CD;
        Fri, 16 Apr 2021 22:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618613167;
        bh=5irC4jEHVy9WTnSwU42ljXApkrq11taRiIDddSVKTp0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AlxJD1rS35erCv71ylwiFUPzaLYzi/Dvq5aYv5l4EjuI0sZki/iN26Y3Ne9mIyJ2e
         d6CWL2MjcIwRZXvsj1mmlCbheyr9D2OvRc+jW6NeLztqAQTEWRRbamUdOa2a51InbR
         9q0SeQn4cnZkSFb6FQhDoJK/7uwnIEzM55/2cg/k=
Date:   Fri, 16 Apr 2021 15:46:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fenghua.yu@intel.com,
        geert@linux-m68k.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        tony.luck@intel.com, torvalds@linux-foundation.org
Subject:  [patch 05/12] ia64: remove duplicate entries in
 generic_defconfig
Message-ID: <20210416224606.D3JeuLkN5%akpm@linux-foundation.org>
In-Reply-To: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
