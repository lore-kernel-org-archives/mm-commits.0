Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1050FC0015E
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jul 2023 02:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjGTCDC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 22:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjGTCDB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 22:03:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA5D10A
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 19:03:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E90BC6188D
        for <mm-commits@vger.kernel.org>; Thu, 20 Jul 2023 02:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB01C433C8;
        Thu, 20 Jul 2023 02:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689818579;
        bh=PaW547mxL0kHbqWj6j+KWh7pg4v09KQJ4J0GRnXFe8E=;
        h=Date:To:From:Subject:From;
        b=OvSWd6JdhV74SdMIc5PINYAYCCo9kJv/lTT9H208AWPuISlSzgy9QAB7WQ3+03GJn
         +qK9tiA9TvOOOJD8ko++ii9U4f8slpYoa33K7/3MMtTFOXTcVHT+b7VekSKNB2z2Lw
         ig+TuS0ILyvRhM6rPSx56yt4555N49KxlN/N6v0k=
Date:   Wed, 19 Jul 2023 19:02:58 -0700
To:     mm-commits@vger.kernel.org, sboyd@kernel.org,
        mturquette@baylibre.com, lkp@intel.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] clk-fixed-mmio-make-common_clk_fixed_mmio-depend-on-has_iomem.patch removed from -mm tree
Message-Id: <20230720020259.3EB01C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: clk: fixed-mmio: make COMMON_CLK_FIXED_MMIO depend on HAS_IOMEM
has been removed from the -mm tree.  Its filename was
     clk-fixed-mmio-make-common_clk_fixed_mmio-depend-on-has_iomem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: clk: fixed-mmio: make COMMON_CLK_FIXED_MMIO depend on HAS_IOMEM
Date: Fri, 7 Jul 2023 21:58:51 +0800

On s390 systems (aka mainframes), it has classic channel devices for
networking and permanent storage that are currently even more common than
PCI devices.  Hence it could have a fully functional s390 kernel with
CONFIG_PCI=n, then the relevant iomem mapping functions [including
ioremap(), devm_ioremap(), etc.] are not available.

Here let COMMON_CLK_FIXED_MMIO depend on HAS_IOMEM so that it won't
be built to cause below compiling error if PCI is unset:

------
ld: drivers/clk/clk-fixed-mmio.o: in function `fixed_mmio_clk_setup':
clk-fixed-mmio.c:(.text+0x5e): undefined reference to `of_iomap'
ld: clk-fixed-mmio.c:(.text+0xba): undefined reference to `iounmap'
------

Link: https://lkml.kernel.org/r/20230707135852.24292-8-bhe@redhat.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306211329.ticOJCSv-lkp@intel.com/
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/Kconfig~clk-fixed-mmio-make-common_clk_fixed_mmio-depend-on-has_iomem
+++ a/drivers/clk/Kconfig
@@ -444,6 +444,7 @@ config COMMON_CLK_BD718XX
 config COMMON_CLK_FIXED_MMIO
 	bool "Clock driver for Memory Mapped Fixed values"
 	depends on COMMON_CLK && OF
+	depends on HAS_IOMEM
 	help
 	  Support for Memory Mapped IO Fixed clocks
 
_

Patches currently in -mm which might be from bhe@redhat.com are

asm-generic-iomaph-remove-arch_has_ioremap_xx-macros.patch
hexagon-mm-convert-to-generic_ioremap.patch
openrisc-mm-remove-unneeded-early-ioremap-code.patch
mm-ioremap-allow-arch-to-have-its-own-ioremap-method-definition.patch
mm-ioremap-add-slab-availability-checking-in-ioremap_prot.patch
arc-mm-convert-to-generic_ioremap.patch
ia64-mm-convert-to-generic_ioremap.patch
openrisc-mm-convert-to-generic_ioremap.patch
s390-mm-convert-to-generic_ioremap.patch
sh-add-asm-generic-ioh-including.patch
sh-mm-convert-to-generic_ioremap.patch
xtensa-mm-convert-to-generic_ioremap.patch
parisc-mm-convert-to-generic_ioremap.patch
mm-move-is_ioremap_addr-into-new-header-file.patch
arm64-mm-add-wrapper-function-ioremap_prot.patch
mm-ioremap-remove-unneeded-ioremap_allowed-and-iounmap_allowed.patch
char-xillybus-make-xillybus_of-depend-on-has_iomem.patch
misc-open-dice-make-open_dice-depend-on-has_iomem.patch
pcmcia-make-pcmcia-depend-on-has_iomem.patch
net-altera-tse-make-altera_tse-depend-on-has_iomem.patch
irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

