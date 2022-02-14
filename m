Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70465C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 14 Feb 2022 21:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiBNVhp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:37:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiBNVfa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Feb 2022 16:35:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6380AF94ED
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 13:34:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 133DEB80C6D
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 21:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9636DC340E9;
        Mon, 14 Feb 2022 21:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644874488;
        bh=RI8Kq/56t5wu33vpnug6A2yv910MNYpSh9LNms2H30M=;
        h=Date:To:From:Subject:From;
        b=nFGwq9Ms1jE4VhCg6MjHvEGU9hYhUZxCFf4Z0nJdW3f5/gmCD0JSQuXFAMTF8TIEu
         +nG927TbMfHGjkCdBDIE9ZcRvlnLwk/BBlPGfpiVTTMcxgqUs1hshy0g7DgxRvPWGa
         Y00BOcaZO3jenffPXKLYRmLIRXVBVMGFiQYnQn9s=
Date:   Mon, 14 Feb 2022 13:34:48 -0800
To:     mm-commits@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-the-migrate_vma_-device-migration-code-into-its-own-file-fix.patch added to -mm tree
Message-Id: <20220214213448.9636DC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: include <asm/tlbflush.h> in migrate_device.c
has been added to the -mm tree.  Its filename is
     mm-move-the-migrate_vma_-device-migration-code-into-its-own-file-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-the-migrate_vma_-device-migration-code-into-its-own-file-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-the-migrate_vma_-device-migration-code-into-its-own-file-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: include <asm/tlbflush.h> in migrate_device.c

Fixup the split of migrate.c by adding a missing include in the new file.

Link: https://lkml.kernel.org/r/20220214072429.3302759-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/migrate_device.c~mm-move-the-migrate_vma_-device-migration-code-into-its-own-file-fix
+++ a/mm/migrate_device.c
@@ -13,6 +13,7 @@
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
 #include <linux/swapops.h>
+#include <asm/tlbflush.h>
 #include "internal.h"
 
 static int migrate_vma_collect_skip(unsigned long start,
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-page_init_poison.patch
mm-remove-a-pointless-config_zone_device-check-in-memremap_pages.patch
mm-remove-the-__kernel__-guard-from-linux-mmh.patch
mm-remove-pointless-includes-from-linux-hmmh.patch
mm-move-free_devmap_managed_page-to-memremapc.patch
mm-simplify-freeing-of-devmap-managed-pages.patch
mm-dont-include-linux-memremaph-in-linux-mmh.patch
mm-remove-the-extra-zone_device-struct-page-refcount.patch
fsdax-depend-on-zone_device-fs_dax_limited.patch
mm-generalize-the-pgmap-based-page_free-infrastructure.patch
mm-refactor-check_and_migrate_movable_pages.patch
mm-refactor-the-zone_device-handling-in-migrate_vma_insert_page.patch
mm-refactor-the-zone_device-handling-in-migrate_vma_pages.patch
mm-move-the-migrate_vma_-device-migration-code-into-its-own-file.patch
mm-move-the-migrate_vma_-device-migration-code-into-its-own-file-fix.patch
mm-build-migrate_vma_-for-all-configs-with-zone_device-support.patch

