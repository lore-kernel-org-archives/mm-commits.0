Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A57C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiJSXZM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJSXZL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:25:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE66F70BA
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:25:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A846960EBF
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08477C433D7;
        Wed, 19 Oct 2022 23:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666221909;
        bh=UyAvvPCAWUSVNLWE4o9ksddjYjZrJFxXAuuYO6a+Ew4=;
        h=Date:To:From:Subject:From;
        b=00ZUf7ynMSMUdi2LE7Ja73jG0nNq1QZzzDiQ9JxVewOfe7UfmkNS4JH9+VIoW3WhY
         Uo4yaJRSYorRhy8/iFdxpkLGBXfxevv+YbqEUZlEmaTBWUMAaO4366Bsi3QLg5pYX9
         eyJYQhpnYTKa/MB5BPtMik/IWimvDFTZDYhgOtJE=
Date:   Wed, 19 Oct 2022 16:25:08 -0700
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com, lyude@redhat.com,
        jhubbard@nvidia.com, bskeggs@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nouveau-fix-migrate_to_ram-for-faulting-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20221019232509.08477C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nouveau: fix migrate_to_ram() for faulting page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nouveau-fix-migrate_to_ram-for-faulting-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nouveau-fix-migrate_to_ram-for-faulting-page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

nouveau-fix-migrate_to_ram-for-faulting-page.patch

