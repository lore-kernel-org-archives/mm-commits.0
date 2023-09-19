Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686E6CE79A9
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 20:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjISUWJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjISUWJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 16:22:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D50BA
        for <mm-commits@vger.kernel.org>; Tue, 19 Sep 2023 13:22:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CEBC433C8;
        Tue, 19 Sep 2023 20:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695154922;
        bh=BP+xSp00AG1uQInmGbLGQ9daai0zUYWJjvFxPoITet8=;
        h=Date:To:From:Subject:From;
        b=rCBPmAxFNuT4M3rMOcr6gU14TQb/hFN/1ZVJScwrdM0RP2Mgvj8R97tzzIfPkxowT
         qn2P5JPbcilQcQ3qidLDDkf7snAWk0yx0JyiUKuTvLxsV5K9G+LXj/WKLrL45K7VM9
         BkmLOnJOn57xcKyxiknwZMYlg/TlHEDRid8LbVL0=
Date:   Tue, 19 Sep 2023 13:22:02 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        glaubitz@physik.fu-berlin.de, dalias@libc.org, bhe@redhat.com,
        geert+renesas@glider.be, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] sh-mm-re-add-lost-__ref-to-ioremap_prot-to-fix-modpost-warning.patch removed from -mm tree
Message-Id: <20230919202202.C2CEBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh: mm: re-add lost __ref to ioremap_prot() to fix modpost warning
has been removed from the -mm tree.  Its filename was
     sh-mm-re-add-lost-__ref-to-ioremap_prot-to-fix-modpost-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: sh: mm: re-add lost __ref to ioremap_prot() to fix modpost warning
Date: Mon, 11 Sep 2023 11:38:50 +0200

When __ioremap_caller() was replaced by ioremap_prot(), the __ref
annotation added in commit af1415314a4190b8 ("sh: Flag __ioremap_caller()
__init_refok.") was removed, causing a modpost warning:

    WARNING: modpost: vmlinux: section mismatch in reference: ioremap_prot+0x88 (section: .text) -> ioremap_fixed (section: .init.text)

ioremap_prot() calls ioremap_fixed() (which is marked __init), but only
before mem_init_done becomes true, so this is safe.  Hence fix this by
re-adding the lost __ref.

Link: https://lkml.kernel.org/r/20230911093850.1517389-1-geert+renesas@glider.be
Fixes: 0453c9a78015cb22 ("sh: mm: convert to GENERIC_IOREMAP")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/ioremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sh/mm/ioremap.c~sh-mm-re-add-lost-__ref-to-ioremap_prot-to-fix-modpost-warning
+++ a/arch/sh/mm/ioremap.c
@@ -72,8 +72,8 @@ __ioremap_29bit(phys_addr_t offset, unsi
 #define __ioremap_29bit(offset, size, prot)		NULL
 #endif /* CONFIG_29BIT */
 
-void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
-			   unsigned long prot)
+void __iomem __ref *ioremap_prot(phys_addr_t phys_addr, size_t size,
+				 unsigned long prot)
 {
 	void __iomem *mapped;
 	pgprot_t pgprot = __pgprot(prot);
_

Patches currently in -mm which might be from geert+renesas@glider.be are


