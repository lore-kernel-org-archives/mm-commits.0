Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0ABDC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjBCF3y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjBCF3r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:29:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44E34E533
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:29:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ABE961D68
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBBEC433D2;
        Fri,  3 Feb 2023 05:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675402184;
        bh=w7Ykikazb1h19vEEk9W/nLZl1h6B8aZLnXS7coIsZ2M=;
        h=Date:To:From:Subject:From;
        b=QMVOJNB1CiyZxwkMaasdVVXQGK6ugxM8qZ3lPppUb/5/xdIIYeCXfr/bYyHYI9S+m
         OGK/9eS0DYYM0knYbOweEdyLp/gl6mlum2gtCzbJZXOa19s5fZ/o3U9yPUhdeRWN5W
         1p+XFv8Lejwo3plqQto+0O0YSS41Ai2LcFQzwI/U=
Date:   Thu, 02 Feb 2023 21:29:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        hch@infradead.org, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch removed from -mm tree
Message-Id: <20230203052944.ADBBEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc: mm: add VM_IOREMAP flag to the vmalloc area
has been removed from the -mm tree.  Its filename was
     powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: powerpc: mm: add VM_IOREMAP flag to the vmalloc area
Date: Fri, 13 Jan 2023 11:19:20 +0800

Currently, for vmalloc areas with flag VM_IOREMAP set, except of the
specific alignment clamping in __get_vm_area_node(), they will be

 1) Shown as ioremap in /proc/vmallocinfo;
 2) Ignored by /proc/kcore reading via vread()

So for the io mapping in ioremap_phb() of ppc, we should set VM_IOREMAP in
flag to make it handled correctly as above.

Link: https://lkml.kernel.org/r/20230113031921.64716-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
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

sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

