Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CC6C43217
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiKOWdX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbiKOWcr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADF52FC24
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 473ED61A6C
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F777C433D7;
        Tue, 15 Nov 2022 22:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551550;
        bh=CiYP0O4kQzP3Ap2GF/5kxrPCxGicIgaGxIy+LpahHQE=;
        h=Date:To:From:Subject:From;
        b=0iB5roPHnwJnJ48wLmmTIdqTfuk2iPS0jBM05vzIFhiDTkN5hpJilaeR7PYkgDast
         GS1+g44aMCE1JYx5Tpav5XZmEjiZ1WJWpPzajRGmrkKKq03vYNXBAFPSeQyiNXmTEK
         yPher5BXl2MIAIEx5BXmER6KzRdxR3XTe+PoyinE=
Date:   Tue, 15 Nov 2022 14:32:30 -0800
To:     mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        christophe.jaillet@wanadoo.fr, arnd@arndb.de, alex.bou9@gmail.com,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-tsi721-replace-flush_scheduled_work-with-flush_work.patch removed from -mm tree
Message-Id: <20221115223230.9F777C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rapidio/tsi721: replace flush_scheduled_work() with flush_work()
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-replace-flush_scheduled_work-with-flush_work.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: rapidio/tsi721: replace flush_scheduled_work() with flush_work()
Date: Sat, 24 Sep 2022 14:11:25 +0900

Like commit c4f135d643823a86 ("workqueue: Wrap flush_workqueue() using a
macro") says, flush_scheduled_work() is dangerous and will be forbidden. 
We are on the way for removing all flush_scheduled_work() callers from the
kernel, and this patch is for removing flush_scheduled_work() call from
tsi721 driver.

Since "struct tsi721_device" is per a device struct, I assume that
tsi721_remove() needs to wait for only two works associated with that
device.  Therefore, wait for only these works using flush_work().

Link: https://lkml.kernel.org/r/0e8a2023-7526-f03a-f520-efafbb0ef45c@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-replace-flush_scheduled_work-with-flush_work
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2941,7 +2941,8 @@ static void tsi721_remove(struct pci_dev
 
 	tsi721_disable_ints(priv);
 	tsi721_free_irq(priv);
-	flush_scheduled_work();
+	flush_work(&priv->idb_work);
+	flush_work(&priv->pw_work);
 	rio_unregister_mport(&priv->mport);
 
 	tsi721_unregister_dma(priv);
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


