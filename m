Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C36ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 22:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiJaWE1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJaWE1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 18:04:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A1B12625
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 15:04:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9653614B0
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 22:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290C2C433D6;
        Mon, 31 Oct 2022 22:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667253865;
        bh=bnulJObMbQcXfjKfHS6k062x90u9ubTpgoIy07g9uVY=;
        h=Date:To:From:Subject:From;
        b=nGaiESTp2lqVVhwSy7FlFt5ei/ngA9Om5ELi7rnz8wAW/YQQ7fEtic84RI+8sSwOB
         mtDmhEDTgYtoLK3LERXEsrBr/ipwdWpcfbysphuSGUlRZ6+y1FMcK9nUtgWRFE2wb8
         G2i2bmFPE0gmhFK9/phLbh72iDal7s7PqwqwA45U=
Date:   Mon, 31 Oct 2022 15:04:24 -0700
To:     mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        christophe.jaillet@wanadoo.fr, arnd@arndb.de, alex.bou9@gmail.com,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-tsi721-replace-flush_scheduled_work-with-flush_work.patch added to mm-nonmm-unstable branch
Message-Id: <20221031220425.290C2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: replace flush_scheduled_work() with flush_work()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-tsi721-replace-flush_scheduled_work-with-flush_work.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-tsi721-replace-flush_scheduled_work-with-flush_work.patch

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

rapidio-tsi721-replace-flush_scheduled_work-with-flush_work.patch

