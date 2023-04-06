Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6ADC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbjDFCy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbjDFCxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A390693D3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E82364217
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D812FC433D2;
        Thu,  6 Apr 2023 02:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749597;
        bh=FO7DJcfve8Cdgqten7rLm71G13HacIq+l83kBkTuuTI=;
        h=Date:To:From:Subject:From;
        b=xXwpreDyd+DgHXXIb23epkNeIzw4IRyMG+BH1e6+8qYtVJDGsUcU7xsGN5wAebUDk
         uvtjverg25Kk7hUSOUJSoGOWnA2uIQlOtKlWAsLqg/dJ17cQc1VPKIeuClNG08iwwv
         tUv+uLG91Zz+khchj3rC5atf45Ua9FbPEGp5xhlI=
Date:   Wed, 05 Apr 2023 19:53:17 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        cai.huoqing@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-tsi721-remove-redundant-pci_clear_master.patch removed from -mm tree
Message-Id: <20230406025317.D812FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rapidio/tsi721: remove redundant pci_clear_master
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-remove-redundant-pci_clear_master.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


