Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09605C6FD1C
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 21:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCWVrV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 17:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjCWVrT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 17:47:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A033172D
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 14:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A40EF628D3
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 21:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071D4C433EF;
        Thu, 23 Mar 2023 21:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679608036;
        bh=OB/y5V1EoD6+rxJX/vwNfrMezZbsLpVloL0yPGRMSNM=;
        h=Date:To:From:Subject:From;
        b=r4arXMqQpd+m7tdAQtNixMS/sfxb4W39qGlYPvOr+0wSiumjEvggShTr6ZeQurMub
         ucRYDRFUv1h8Ss5mmpckxaKRo5AKIDwWopY8dVL1cLQz8ucIv9Bfku0K/MWW2o6qB5
         Y8usGXlpOPHruqI7moDzzzEqdNL01bVehAu291fw=
Date:   Thu, 23 Mar 2023 14:47:15 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        cai.huoqing@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-tsi721-remove-redundant-pci_clear_master.patch added to mm-nonmm-unstable branch
Message-Id: <20230323214716.071D4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: remove redundant pci_clear_master
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-tsi721-remove-redundant-pci_clear_master.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-tsi721-remove-redundant-pci_clear_master.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Cai Huoqing <cai.huoqing@linux.dev>
Subject: rapidio/tsi721: remove redundant pci_clear_master
Date: Thu, 23 Mar 2023 19:37:09 +0800

Remove pci_clear_master to simplify the code, the bus-mastering is also
cleared in do_pci_disable_device, like this:

./drivers/pci/pci.c:2197
static void do_pci_disable_device(struct pci_dev *dev)
{
	u16 pci_command;

	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
	if (pci_command & PCI_COMMAND_MASTER) {
		pci_command &= ~PCI_COMMAND_MASTER;
		pci_write_config_word(dev, PCI_COMMAND, pci_command);
	}

	pcibios_disable_device(dev);
}.
And dev->is_busmaster is set to 0 in pci_disable_device.

Link: https://lkml.kernel.org/r/20230323113711.10523-1-cai.huoqing@linux.dev
Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-remove-redundant-pci_clear_master
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2924,7 +2924,6 @@ err_unmap_bars:
 		iounmap(priv->odb_base);
 err_free_res:
 	pci_release_regions(pdev);
-	pci_clear_master(pdev);
 err_disable_pdev:
 	pci_disable_device(pdev);
 err_clean:
@@ -2962,7 +2961,6 @@ static void tsi721_remove(struct pci_dev
 		pci_disable_msi(priv->pdev);
 #endif
 	pci_release_regions(pdev);
-	pci_clear_master(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 	kfree(priv);
@@ -2977,7 +2975,6 @@ static void tsi721_shutdown(struct pci_d
 
 	tsi721_disable_ints(priv);
 	tsi721_dma_stop_all(priv);
-	pci_clear_master(pdev);
 	pci_disable_device(pdev);
 }
 
_

Patches currently in -mm which might be from cai.huoqing@linux.dev are

rapidio-tsi721-remove-redundant-pci_clear_master.patch

