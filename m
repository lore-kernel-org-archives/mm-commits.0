Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73FBC43219
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiJUEgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJUEfP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:35:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580B94B4A0
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EE55616E3
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9EBC433C1;
        Fri, 21 Oct 2022 04:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326899;
        bh=W4OsB8DoG5WZNcpHIYDzaLdHRo4UmhvXBuUEMG0MQP0=;
        h=Date:To:From:Subject:From;
        b=SetOUJ5dL+Jkn8SImkC9XCU5XB+sI0ICINHgNTrlPeAekU+RATep+pRgdswfUY6Fn
         DuHJKAWgZQ5dG+brSq2UOZZG7bckHt2BkHpqqwgro1hpq7p5N9c9Vw2gx3l852C3A6
         FntFM8Qnmu4vflpCmYt42guZjKEnWqfSgJgLD9pA=
Date:   Thu, 20 Oct 2022 21:34:58 -0700
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com, lyude@redhat.com,
        jhubbard@nvidia.com, bskeggs@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nouveau-fix-migrate_to_ram-for-faulting-page.patch removed from -mm tree
Message-Id: <20221021043459.8A9EBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nouveau: fix migrate_to_ram() for faulting page
has been removed from the -mm tree.  Its filename was
     nouveau-fix-migrate_to_ram-for-faulting-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: nouveau: fix migrate_to_ram() for faulting page
Date: Wed, 19 Oct 2022 23:29:34 +1100

Commit 16ce101db85d ("mm/memory.c: fix race when faulting a device private
page") changed the migrate_to_ram() callback to take a reference on the
device page to ensure it can't be freed while handling the fault. 
Unfortunately the corresponding update to Nouveau to accommodate this
change was inadvertently dropped from that patch causing GPU to CPU
migration to fail so add it here.

Link: https://lkml.kernel.org/r/20221019122934.866205-1-apopple@nvidia.com
Fixes: 16ce101db85d ("mm/memory.c: fix race when faulting a device private page")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_dmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~nouveau-fix-migrate_to_ram-for-faulting-page
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -176,6 +176,7 @@ static vm_fault_t nouveau_dmem_migrate_t
 		.src		= &src,
 		.dst		= &dst,
 		.pgmap_owner	= drm->dev,
+		.fault_page	= vmf->page,
 		.flags		= MIGRATE_VMA_SELECT_DEVICE_PRIVATE,
 	};
 
_

Patches currently in -mm which might be from apopple@nvidia.com are


