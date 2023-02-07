Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E6FC636D3
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjBGBSZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjBGBSY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:18:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272EB34C2E
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:18:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B14F861084
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AADC433D2;
        Tue,  7 Feb 2023 01:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675732696;
        bh=qiZvf3eGA72CYVr+MCLnorHeGMTyygmG+mFKMGjIe9c=;
        h=Date:To:From:Subject:From;
        b=D5N1D6WvwdMQ+8Cti7mlQhyQ3sHSH8HPsIa0YGgiqoOrxE3xqsCWzPSGmGK8gO421
         lCrc6XJblrfl6yn2vzUhMLnOkPhXAhZFjoTqdWxEd3uDFCpmCU5h1HPawGD+HMc2x/
         /wmsneI7B09cULRv49B6CgdIROvX/ezLXQF0uEZM=
Date:   Mon, 06 Feb 2023 17:18:15 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        error27@gmail.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch added to mm-unstable branch
Message-Id: <20230207011816.12AADC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: mm: add VM_IOREMAP flag to the vmalloc area
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch

This patch will later appear in the mm-unstable branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: powerpc: mm: add VM_IOREMAP flag to the vmalloc area
Date: Mon, 6 Feb 2023 16:40:19 +0800

Currently, for vmalloc areas with flag VM_IOREMAP set, except of the
specific alignment clamping in __get_vm_area_node(), they will be

 1) Shown as ioremap in /proc/vmallocinfo;

 2) Ignored by /proc/kcore reading via vread()

So for the io mapping in ioremap_phb() of ppc, we should set VM_IOREMAP in
flag to make it handled correctly as above.

Link: https://lkml.kernel.org/r/20230206084020.174506-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/powerpc/kernel/pci_64.c~powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area
+++ a/arch/powerpc/kernel/pci_64.c
@@ -132,7 +132,7 @@ void __iomem *ioremap_phb(phys_addr_t pa
 	 * address decoding but I'd rather not deal with those outside of the
 	 * reserved 64K legacy region.
 	 */
-	area = __get_vm_area_caller(size, 0, PHB_IO_BASE, PHB_IO_END,
+	area = __get_vm_area_caller(size, VM_IOREMAP, PHB_IO_BASE, PHB_IO_END,
 				    __builtin_return_address(0));
 	if (!area)
 		return NULL;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch
mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch
mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch
mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch
mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch
powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

