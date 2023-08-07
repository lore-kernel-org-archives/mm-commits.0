Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC59C00528
	for <mm-commits@archiver.kernel.org>; Mon,  7 Aug 2023 15:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjHGP2K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Aug 2023 11:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjHGP15 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Aug 2023 11:27:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389DC172D
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 08:27:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C25DA61E07
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 15:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282BDC433C9;
        Mon,  7 Aug 2023 15:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691422070;
        bh=tQx3lxmmjoGvfwwL5cMEhs+T1++NGHzgLVTLZczdVgc=;
        h=Date:To:From:Subject:From;
        b=2V2tRnLILUEOwgzVji/9bo8lQVJ3PMacio8c6H/0UsMMYeo/0wN/aDAjvpvWUhg94
         mAogmSujFOEsct65XLQByjwBN62odrIG2WzVF07CwC9MFAQOaheT5bZSGfwCTw8+nO
         OIxYaa4Tk2hcvIxemr5zY0iT3xUSOhMPajQGXlOM=
Date:   Mon, 07 Aug 2023 08:27:49 -0700
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        schnelle@linux.ibm.com, lkp@intel.com, linux@dominikbrodowski.net,
        linus.walleij@linaro.org, Jonathan.Cameron@huawei.com,
        arnd@arndb.de, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] pcmcia-make-pcmcia-depend-on-has_iomem.patch removed from -mm tree
Message-Id: <20230807152750.282BDC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: pcmcia : make PCMCIA depend on HAS_IOMEM
has been removed from the -mm tree.  Its filename was
     pcmcia-make-pcmcia-depend-on-has_iomem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: pcmcia : make PCMCIA depend on HAS_IOMEM
Date: Fri, 7 Jul 2023 21:58:48 +0800

On s390 systems (aka mainframes), it has classic channel devices for
networking and permanent storage that are currently even more common than
PCI devices.  Hence it could have a fully functional s390 kernel with
CONFIG_PCI=n, then the relevant iomem mapping functions [including
ioremap(), devm_ioremap(), etc.] are not available.

Here let depend PCMCIA on HAS_IOMEM so that it won't be built to cause
below compiling error if PCI is unset.

------
ld: drivers/pcmcia/cistpl.o: in function `set_cis_map':
cistpl.c:(.text+0x1202): undefined reference to `ioremap'
ld: cistpl.c:(.text+0x13b0): undefined reference to `iounmap'
ld: cistpl.c:(.text+0x14a6): undefined reference to `iounmap'
ld: cistpl.c:(.text+0x1544): undefined reference to `ioremap'
ld: drivers/pcmcia/cistpl.o: in function `release_cis_mem':
cistpl.c:(.text+0x3f14): undefined reference to `iounmap'
------

Besides, many other Kconfig option, e.g IPWIRELESS, PCMCIA_PCNET,
PCMCIA_FMVJ18X, PCMCIA_SMC91C92 which depends on PCMCIA also will
cause compiling error if enabled.

------
ERROR: modpost: "iounmap" [drivers/tty/ipwireless/ipwireless.ko] undefined!
ERROR: modpost: "ioremap" [drivers/tty/ipwireless/ipwireless.ko] undefined!

ERROR: modpost: "iounmap" [drivers/net/ethernet/8390/pcnet_cs.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/8390/pcnet_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/fujitsu/fmvj18x_cs.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/fujitsu/fmvj18x_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/smsc/smc91c92_cs.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/smsc/smc91c92_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/xircom/xirc2ps_cs.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/xircom/xirc2ps_cs.ko] undefined!
ERROR: modpost: "devm_ioremap" [drivers/net/ethernet/altera/altera_tse.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/arcnet/com90xx.ko] undefined!
------

Link: https://lkml.kernel.org/r/20230707135852.24292-5-bhe@redhat.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306211329.ticOJCSv-lkp@intel.com/
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pcmcia/Kconfig~pcmcia-make-pcmcia-depend-on-has_iomem
+++ a/drivers/pcmcia/Kconfig
@@ -19,6 +19,7 @@ if PCCARD
 
 config PCMCIA
 	tristate "16-bit PCMCIA support"
+	depends on HAS_IOMEM
 	select CRC32
 	default y
 	help
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
net-altera-tse-make-altera_tse-depend-on-has_iomem.patch
irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

