Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096B1C43334
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 22:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiGCWnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 18:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiGCWnt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 18:43:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599CA225
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 15:43:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF044B80CE7
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 22:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9402FC341CA;
        Sun,  3 Jul 2022 22:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656888225;
        bh=A3mfdWOT8Nnh7dij6uHlEpcRQwT3Iz6pBFJ5THo576I=;
        h=Date:To:From:Subject:From;
        b=wFjw1j8+Snn0D6blXNDBiHWnWj1IPthEK3dSN4jNHeHOynI5qKSqccqN1ui8L59rN
         VHJldG86a2uT5rypkRxlgrZzj1dMrZLJbB7VUUMzQv5i0+8R9kavnaBzLrTh76Q1ZM
         yJQ8YUWiq0TDhkcG84HBe6WmjGbwagJwzLQJSLkI=
Date:   Sun, 03 Jul 2022 15:43:44 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        Jonathan.Cameron@huawei.com, hch@lst.de, geert+renesas@glider.be,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] sh-convert-nommu-ioreunmap-to-static-inline-functions.patch removed from -mm tree
Message-Id: <20220703224345.9402FC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh: convert nommu io{re,un}map() to static inline functions
has been removed from the -mm tree.  Its filename was
     sh-convert-nommu-ioreunmap-to-static-inline-functions.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: sh: convert nommu io{re,un}map() to static inline functions
Date: Mon, 20 Jun 2022 09:01:43 +0200

Recently, nommu iounmap() was converted from a static inline function to a
macro again, basically reverting commit 4580ba4ad2e6b8dd ("sh: Convert
iounmap() macros to inline functions").  With -Werror, this leads to build
failures like:

    drivers/iio/adc/xilinx-ams.c: In function `ams_iounmap_ps':
    drivers/iio/adc/xilinx-ams.c:1195:14: error: unused variable `ams' [-Werror=unused-variable]
     1195 |  struct ams *ams = data;
	  |              ^~~

Fix this by replacing the macros for ioremap() and iounmap() by static
inline functions, based on <asm-generic/io.h>.

Link: https://lkml.kernel.org/r/8d1b1766260961799b04035e7bc39a7f59729f72.1655708312.git.geert+renesas@glider.be
Fixes: 13f1fc870dd74713 ("sh: move the ioremap implementation out of line")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/io.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/sh/include/asm/io.h~sh-convert-nommu-ioreunmap-to-static-inline-functions
+++ a/arch/sh/include/asm/io.h
@@ -271,8 +271,12 @@ static inline void __iomem *ioremap_prot
 #endif /* CONFIG_HAVE_IOREMAP_PROT */
 
 #else /* CONFIG_MMU */
-#define iounmap(addr)		do { } while (0)
-#define ioremap(offset, size)	((void __iomem *)(unsigned long)(offset))
+static inline void __iomem *ioremap(phys_addr_t offset, size_t size)
+{
+	return (void __iomem *)(unsigned long)offset;
+}
+
+static inline void iounmap(volatile void __iomem *addr) { }
 #endif /* CONFIG_MMU */
 
 #define ioremap_uc	ioremap
_

Patches currently in -mm which might be from geert+renesas@glider.be are


