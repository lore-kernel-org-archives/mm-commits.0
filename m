Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B89C04A6A
	for <mm-commits@archiver.kernel.org>; Mon,  7 Aug 2023 15:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjHGP2J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Aug 2023 11:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjHGP1y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Aug 2023 11:27:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51771721
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 08:27:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4753F61E04
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 15:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BBAC433CA;
        Mon,  7 Aug 2023 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691422067;
        bh=n3LT/jLdw04Kc2e3yPcRJUVBwnBrXlBxCPmcRRL+kp4=;
        h=Date:To:From:Subject:From;
        b=V0aSwWxllbAx0wHiMfvs1NzTtk+j4C5cOrmmV2veV9AIrbp8Ql5zTpfRCk23PJhxn
         eX7N7gEvXK6ARw7XKhSJZklnFBpuc9EvsNzytKTTJv/ZYdC/4fivhxIMHAoolG+AAC
         uvWxuJqZBNMlA6RWyo2DcWRUNNig+Fk/GkFxHpwk=
Date:   Mon, 07 Aug 2023 08:27:46 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        gregkh@linuxfoundation.org, eli.billauer@gmail.com, arnd@arndb.de,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] char-xillybus-make-xillybus_of-depend-on-has_iomem.patch removed from -mm tree
Message-Id: <20230807152747.A1BBAC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: char: xillybus: make XILLYBUS_OF depend on HAS_IOMEM
has been removed from the -mm tree.  Its filename was
     char-xillybus-make-xillybus_of-depend-on-has_iomem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: char: xillybus: make XILLYBUS_OF depend on HAS_IOMEM
Date: Fri, 7 Jul 2023 21:58:46 +0800

On s390 systems (aka mainframes), it has classic channel devices for
networking and permanent storage that are currently even more common than
PCI devices.  Hence it could have a fully functional s390 kernel with
CONFIG_PCI=n, then the relevant iomem mapping functions [including
ioremap(), devm_ioremap(), etc.] are not available.

Here let XILLYBUS_OF depend on HAS_IOMEM so that it won't be built
to cause below compiling error if PCI is unset:

------
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/char/xillybus/xillybus_of.ko] undefined!
------

Link: https://lkml.kernel.org/r/20230707135852.24292-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306211329.ticOJCSv-lkp@intel.com/
Cc: Eli Billauer <eli.billauer@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/xillybus/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/xillybus/Kconfig~char-xillybus-make-xillybus_of-depend-on-has_iomem
+++ a/drivers/char/xillybus/Kconfig
@@ -29,7 +29,7 @@ config XILLYBUS_PCIE
 
 config XILLYBUS_OF
 	tristate "Xillybus over Device Tree"
-	depends on OF && HAS_DMA
+	depends on OF && HAS_DMA && HAS_IOMEM
 	help
 	  Set to M if you want Xillybus to find its resources from the
 	  Open Firmware Flattened Device Tree. If the target is an embedded
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
misc-open-dice-make-open_dice-depend-on-has_iomem.patch
pcmcia-make-pcmcia-depend-on-has_iomem.patch
net-altera-tse-make-altera_tse-depend-on-has_iomem.patch
irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

