Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564D6C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 20:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1920961953
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 20:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhC1Uj4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 16:39:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231288AbhC1Uju (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 16:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C48246195E;
        Sun, 28 Mar 2021 20:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616963989;
        bh=sS86Do/hYf5ITV2NmZ4b8aWLdEbqhfMYpArj0VxIJsk=;
        h=Date:From:To:Subject:From;
        b=gHxTYHmJVXbAt9p01kQ+CGVgd3M7+Wd2kxFf20h8adtKJasZtOjr63mc6qu7ggTSg
         X0xP5a1kfaNLfFi2KfLZr50hbQLlRqwhQXruVQ+AnAmTU2Jml9Ggp2FqEGPmIo41+z
         gDe9I+DmjJ8X8KgauSN2hnvmZ/gSvspllG3pDTEw=
Date:   Sun, 28 Mar 2021 13:39:49 -0700
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org,
        slyfox@gentoo.org
Subject:  + ia64-simplify-code-flow-around-swiotlb-init.patch added
 to -mm tree
Message-ID: <20210328203949.eU6egAIf3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: simplify code flow around swiotlb init
has been added to the -mm tree.  Its filename is
     ia64-simplify-code-flow-around-swiotlb-init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-simplify-code-flow-around-swiotlb-init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-simplify-code-flow-around-swiotlb-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ia64: simplify code flow around swiotlb init

Before the change CONFIG_INTEL_IOMMU && !CONFIG_SWIOTLB && !CONFIG_FLATMEM
could skip `set_max_mapnr(max_low_pfn);` if iommu is not present on
system.

Link: https://lkml.kernel.org/r/20210328202439.403601-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/ia64/mm/init.c~ia64-simplify-code-flow-around-swiotlb-init
+++ a/arch/ia64/mm/init.c
@@ -644,13 +644,16 @@ mem_init (void)
 	 * _before_ any drivers that may need the PCI DMA interface are
 	 * initialized or bootmem has been freed.
 	 */
+	do {
 #ifdef CONFIG_INTEL_IOMMU
-	detect_intel_iommu();
-	if (!iommu_detected)
+		detect_intel_iommu();
+		if (iommu_detected)
+			break;
 #endif
 #ifdef CONFIG_SWIOTLB
 		swiotlb_init(1);
 #endif
+	} while (0);
 
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
_

Patches currently in -mm which might be from slyfox@gentoo.org are

ia64-drop-unused-ia64_fw_emu-ifdef.patch
ia64-simplify-code-flow-around-swiotlb-init.patch

