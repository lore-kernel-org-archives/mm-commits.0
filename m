Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B35CA0EC7
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239277AbjIKWX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243869AbjIKSEq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 14:04:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81BF103
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 11:04:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BE7C433C7;
        Mon, 11 Sep 2023 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694455481;
        bh=NM/c0IeVHdLveNjD7fOJbED5Vm4qZEJii//RnbgPxao=;
        h=Date:To:From:Subject:From;
        b=ATk3P8tCNvIZCzmp6hl4FKHXi0K+irJRJ0vpJTfl/rAId12TdtTekOvQAfnZyM+Y8
         QZlNl+WrCyAw4looeTtMX14yaUwJkJ3gqhgqqUs7PiGXuYtfeEVUu47oUnkCzY4nYz
         yBkGsjhDXWIImOJ5Dpt3dtj24hClSkn38SxW+i5w=
Date:   Mon, 11 Sep 2023 11:04:40 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        glaubitz@physik.fu-berlin.de, dalias@libc.org, bhe@redhat.com,
        geert+renesas@glider.be, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-mm-re-add-lost-__ref-to-ioremap_prot-to-fix-modpost-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20230911180441.39BE7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: mm: re-add lost __ref to ioremap_prot() to fix modpost warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     sh-mm-re-add-lost-__ref-to-ioremap_prot-to-fix-modpost-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-mm-re-add-lost-__ref-to-ioremap_prot-to-fix-modpost-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

sh-mm-re-add-lost-__ref-to-ioremap_prot-to-fix-modpost-warning.patch

