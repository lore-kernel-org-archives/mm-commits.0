Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232C2C001E0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjHLWFZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjHLWFS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4462E9F
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7E0B60B81
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35661C433C8;
        Sat, 12 Aug 2023 22:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877920;
        bh=jLFaG8g/wr53vVqXDrXrG0C0gB1HTKSh+PHNim+upy4=;
        h=Date:To:From:Subject:From;
        b=WkDbXvvW69vomECDgfe/ANO2PuOsATt/ROLR+Drsy0svHS0yuo/o5NlRUEt+fxrMR
         Lfbsb19GijC2R1DJuWTYsNrKQ3yiK3xxjG+yzL08++oMv2zIvGFCGI2I+T8seYjwA0
         HIOab3WYTQ8stUAzGYv7xoyLBsLkDm6euwd8BAmg=
Date:   Sat, 12 Aug 2023 15:05:19 -0700
To:     mm-commits@vger.kernel.org, pabeni@redhat.com, lkp@intel.com,
        kuba@kernel.org, joyce.ooi@intel.com, edumazet@google.com,
        davem@davemloft.net, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] net-altera-tse-make-altera_tse-depend-on-has_iomem.patch removed from -mm tree
Message-Id: <20230812220520.35661C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: net: altera-tse: make ALTERA_TSE depend on HAS_IOMEM
has been removed from the -mm tree.  Its filename was
     net-altera-tse-make-altera_tse-depend-on-has_iomem.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: net: altera-tse: make ALTERA_TSE depend on HAS_IOMEM
Date: Fri, 7 Jul 2023 21:58:49 +0800

On s390 systems (aka mainframes), it has classic channel devices for
networking and permanent storage that are currently even more common than
PCI devices.  Hence it could have a fully functional s390 kernel with
CONFIG_PCI=n, then the relevant iomem mapping functions [including
ioremap(), devm_ioremap(), etc.] are not available.

Here let ALTERA_TSE depend on HAS_IOMEM so that it won't be built to cause
below compiling error if PCI is unset:

------
ERROR: modpost: "devm_ioremap" [drivers/net/ethernet/altera/altera_tse.ko] undefined!
------

Link: https://lkml.kernel.org/r/20230707135852.24292-6-bhe@redhat.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306211329.ticOJCSv-lkp@intel.com/
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Joyce Ooi <joyce.ooi@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/altera/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/altera/Kconfig~net-altera-tse-make-altera_tse-depend-on-has_iomem
+++ a/drivers/net/ethernet/altera/Kconfig
@@ -2,6 +2,7 @@
 config ALTERA_TSE
 	tristate "Altera Triple-Speed Ethernet MAC support"
 	depends on HAS_DMA
+	depends on HAS_IOMEM
 	select PHYLIB
 	select PHYLINK
 	select PCS_LYNX
_

Patches currently in -mm which might be from bhe@redhat.com are


