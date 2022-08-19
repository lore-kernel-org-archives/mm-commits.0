Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3FDC32772
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 21:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiHSVv1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 17:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiHSVv0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 17:51:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F24B5E52
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 14:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 572A4B82968
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 21:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5286C433D6;
        Fri, 19 Aug 2022 21:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660945883;
        bh=TKe5a9/vCkSU/6Kv31M5iIznPNPiv/os41YP2gcx3Gg=;
        h=Date:To:From:Subject:From;
        b=pc5APYUQgJM/k7VLZ2yWaVkaXnwWWqIRrPj3/YWwcRWPnMU9BPxuzSlK/bWlpZXsd
         SEqg9sEDiaSsB1rDwy8Xk+oUiJZQnq8NZj/4Vgbab2jEsi1c+3rzqSOyf0iLQ3avBU
         cElgfsOxC4HBtPXJBjILaePMdjACDhDnfHfw1vNs=
Date:   Fri, 19 Aug 2022 14:51:22 -0700
To:     mm-commits@vger.kernel.org, treding@nvidia.com, arnd@arndb.de,
        ardb@kernel.org, quanyang.wang@windriver.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + asm-generic-sections-refactor-memory_intersects.patch added to mm-unstable branch
Message-Id: <20220819215122.E5286C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: sections: refactor memory_intersects
has been added to the -mm mm-unstable branch.  Its filename is
     asm-generic-sections-refactor-memory_intersects.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/asm-generic-sections-refactor-memory_intersects.patch

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
From: Quanyang Wang <quanyang.wang@windriver.com>
Subject: asm-generic: sections: refactor memory_intersects
Date: Fri, 19 Aug 2022 16:11:45 +0800

There are two problems with the current code of memory_intersects:

First, it doesn't check whether the region (begin, end) falls inside the
region (virt, vend), that is (virt < begin && vend > end).

The second problem is if vend is equal to begin, it will return true but
this is wrong since vend (virt + size) is not the last address of the
memory region but (virt + size -1) is.  The wrong determination will
trigger the misreporting when the function check_for_illegal_area calls
memory_intersects to check if the dma region intersects with stext region.

The misreporting is as below (stext is at 0x80100000):
 WARNING: CPU: 0 PID: 77 at kernel/dma/debug.c:1073 check_for_illegal_area+0x130/0x168
 DMA-API: chipidea-usb2 e0002000.usb: device driver maps memory from kernel text or rodata [addr=800f0000] [len=65536]
 Modules linked in:
 CPU: 1 PID: 77 Comm: usb-storage Not tainted 5.19.0-yocto-standard #5
 Hardware name: Xilinx Zynq Platform
  unwind_backtrace from show_stack+0x18/0x1c
  show_stack from dump_stack_lvl+0x58/0x70
  dump_stack_lvl from __warn+0xb0/0x198
  __warn from warn_slowpath_fmt+0x80/0xb4
  warn_slowpath_fmt from check_for_illegal_area+0x130/0x168
  check_for_illegal_area from debug_dma_map_sg+0x94/0x368
  debug_dma_map_sg from __dma_map_sg_attrs+0x114/0x128
  __dma_map_sg_attrs from dma_map_sg_attrs+0x18/0x24
  dma_map_sg_attrs from usb_hcd_map_urb_for_dma+0x250/0x3b4
  usb_hcd_map_urb_for_dma from usb_hcd_submit_urb+0x194/0x214
  usb_hcd_submit_urb from usb_sg_wait+0xa4/0x118
  usb_sg_wait from usb_stor_bulk_transfer_sglist+0xa0/0xec
  usb_stor_bulk_transfer_sglist from usb_stor_bulk_srb+0x38/0x70
  usb_stor_bulk_srb from usb_stor_Bulk_transport+0x150/0x360
  usb_stor_Bulk_transport from usb_stor_invoke_transport+0x38/0x440
  usb_stor_invoke_transport from usb_stor_control_thread+0x1e0/0x238
  usb_stor_control_thread from kthread+0xf8/0x104
  kthread from ret_from_fork+0x14/0x2c

Refactor memory_intersects to fix the two problems above.

Link: https://lkml.kernel.org/r/20220819081145.948016-1-quanyang.wang@windriver.com
Fixes: 979559362516 ("asm/sections: add helpers to check for section data")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/asm-generic/sections.h~asm-generic-sections-refactor-memory_intersects
+++ a/include/asm-generic/sections.h
@@ -110,7 +110,10 @@ static inline bool memory_intersects(voi
 {
 	void *vend = virt + size;
 
-	return (virt >= begin && virt < end) || (vend >= begin && vend < end);
+	if (virt < end && vend > begin)
+		return true;
+
+	return false;
 }
 
 /**
_

Patches currently in -mm which might be from quanyang.wang@windriver.com are

asm-generic-sections-refactor-memory_intersects.patch

