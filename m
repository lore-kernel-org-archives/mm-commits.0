Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B20EC04A94
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjHLWFY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjHLWFT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A6A171C
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D760360B81
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C111C433C8;
        Sat, 12 Aug 2023 22:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877921;
        bh=E3lM8hzai5Ok+elUsRC8fsZhocZDxyjKR3EoWww+HQM=;
        h=Date:To:From:Subject:From;
        b=HseGNUtcsDXjaY0hwAjwS6e5jELAWM8ShCBdeS3t5CzlB9RnVFvstxtN91sJho04X
         vUUXc1mPue5VNoHUqD2qp7m6TOPMXxQgZ9XnmAFndZyvieTyJtcpyKyKj3QUFyN+4Y
         P4BTg/YtSyZoIpxGjdsIsPIE7Fo/mGFzbNwytsis=
Date:   Sat, 12 Aug 2023 15:05:20 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, maz@kernel.org,
        lkp@intel.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch removed from -mm tree
Message-Id: <20230812220521.3C111C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: irqchip/al-fic: make AL_FIC depend on HAS_IOMEM
has been removed from the -mm tree.  Its filename was
     irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: irqchip/al-fic: make AL_FIC depend on HAS_IOMEM
Date: Fri, 7 Jul 2023 21:58:50 +0800

On s390 systems (aka mainframes), it has classic channel devices for
networking and permanent storage that are currently even more common than
PCI devices.  Hence it could have a fully functional s390 kernel with
CONFIG_PCI=n, then the relevant iomem mapping functions [including
ioremap(), devm_ioremap(), etc.] are not available.

Here let AL_FIC depend on HAS_IOMEM so that it won't be built
to cause below compiling error if PCI is unset:

------
ld: drivers/irqchip/irq-al-fic.o: in function `al_fic_init_dt':
irq-al-fic.c:(.init.text+0x76): undefined reference to `of_iomap'
ld: irq-al-fic.c:(.init.text+0x4ce): undefined reference to `iounmap'
------

Link: https://lkml.kernel.org/r/20230707135852.24292-7-bhe@redhat.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306211329.ticOJCSv-lkp@intel.com/
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/irqchip/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/irqchip/Kconfig~irqchip-al-fic-make-al_fic-depend-on-has_iomem
+++ a/drivers/irqchip/Kconfig
@@ -89,6 +89,7 @@ config ALPINE_MSI
 config AL_FIC
 	bool "Amazon's Annapurna Labs Fabric Interrupt Controller"
 	depends on OF
+	depends on HAS_IOMEM
 	select GENERIC_IRQ_CHIP
 	select IRQ_DOMAIN
 	help
_

Patches currently in -mm which might be from bhe@redhat.com are


