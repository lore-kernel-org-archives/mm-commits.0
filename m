Return-Path: <SRS0=TlCe=A2=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE84C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jul 2020 23:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B142206D5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jul 2020 23:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594857248;
	bh=hLhca0wAVj84nCWQknTCjTgmAc3bPnVlzfCXUr1ZMq0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=H1zm5sJSh1gSfOXiUZlMqlhQxmWSdbCqzhcFkIz2usVoliCgdJPG0df8AXAuUt+EF
	 bI34y78lKHMFA8Jnca/hPeJE4ZmCUuWV+HiNThqr1I32gMTigOvSS7GzXg3OHgpacC
	 bArdQVabSxOKfvuHuw4RzAynbTt7VeAJ8Vi3KBkk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgGOXyI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jul 2020 19:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGOXyH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Jul 2020 19:54:07 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11421206D5;
        Wed, 15 Jul 2020 23:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594857246;
        bh=hLhca0wAVj84nCWQknTCjTgmAc3bPnVlzfCXUr1ZMq0=;
        h=Date:From:To:Subject:From;
        b=l4uTNb9B52TG+lQePx/c05lLC4gE+Sg8/Q5J9qVXEHBcINOomzQ+svYo4EEeeU/xn
         RvTBjrnhca2y9AZEHY3U9+ZQwYjStO+fuLf6KgogspAnXvk/v7qW7DGWzfGDIaLsJU
         8iN4c+LHKIXAaLcbVPDc1rJ7TPW290kz5VUj5xVw=
Date:   Wed, 15 Jul 2020 16:54:05 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20200715235405.QNJ08cLgu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/idxd/sysfs.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/dma/idxd/sysfs.c~linux-next-git-rejects
+++ a/drivers/dma/idxd/sysfs.c
@@ -304,14 +304,6 @@ static int idxd_config_bus_remove(struct
 
 		idxd_unregister_dma_device(idxd);
 		rc = idxd_device_disable(idxd);
-<<<<<<< HEAD
-		for (i = 0; i < idxd->max_wqs; i++) {
-			struct idxd_wq *wq = &idxd->wqs[i];
-
-			idxd_wq_disable_cleanup(wq);
-		}
-		spin_unlock_irqrestore(&idxd->dev_lock, flags);
-=======
 
 		for (i = 0; i < idxd->max_wqs; i++) {
 			struct idxd_wq *wq = &idxd->wqs[i];
@@ -321,7 +313,6 @@ static int idxd_config_bus_remove(struct
 			mutex_unlock(&wq->wq_lock);
 		}
 
->>>>>>> linux-next/akpm-base
 		module_put(THIS_MODULE);
 		if (rc < 0)
 			dev_warn(dev, "Device disable failed\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

