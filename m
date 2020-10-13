Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068B5C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28E621D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630863;
	bh=XbShYEcYxHaJNCeBtL0TqVy8YgMxNXrw6njPgUUMiqQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wVg6K32W+GTmYyol813Nt5vv3SBvVFFDj88S3gKyCM07N8kxk/jWzZpdf7MS0Lw19
	 gefKw/7lZ5Y/dRTt8d2p7aRP7ZTAxMMgHFEHxVy0Ps9TgmBTj505pIP7DcpIeqVXbP
	 C99KjLFJFm95uyzRMsgpu+TFBrdvaoWMNr/yrcaw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgJMXOX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbgJMXOX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:14:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 951C620B1F;
        Tue, 13 Oct 2020 23:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630862;
        bh=XbShYEcYxHaJNCeBtL0TqVy8YgMxNXrw6njPgUUMiqQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=L/7XQxfaPpdsD5qCUbCuFCr270iDBi9dcxXCr8/I+9IACxw0ySl7EN/AaIRF7EgWv
         Myda3k1oBysuHsS9GMyc9QCCjoI1D/jidV1qVObjB2Jl/txYGggJraz29f6Ww5dnGL
         0N7dGRgYaC13sl4mJ+KKUqN9YQfcjBFH37mx8pIY=
Date:   Tue, 13 Oct 2020 16:14:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  [folded-merged]
 memblock-make-memblock_debug-and-related-functionality-private-fix.patch
 removed from -mm tree
Message-ID: <20201013231422.Yt_5EBJa2%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock-make-memblock_debug-and-related-functionality-private-fix
has been removed from the -mm tree.  Its filename was
     memblock-make-memblock_debug-and-related-functionality-private-fix.patch

This patch was dropped because it was folded into memblock-make-memblock_debug-and-related-functionality-private.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memblock-make-memblock_debug-and-related-functionality-private-fix

make memblock_dbg() safer and neater

Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memblock.c~memblock-make-memblock_debug-and-related-functionality-private-fix
+++ a/mm/memblock.c
@@ -137,8 +137,11 @@ struct memblock_type physmem = {
 	     i < memblock_type->cnt;					\
 	     i++, rgn = &memblock_type->regions[i])
 
-#define memblock_dbg(fmt, ...) \
-	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define memblock_dbg(fmt, ...)						\
+	do {								\
+		if (memblock_debug)					\
+			pr_info(fmt, ##__VA_ARGS__);			\
+	} while (0)
 
 static int memblock_debug __initdata_memblock;
 static bool system_has_some_mirror __initdata_memblock = false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memblock-make-memblock_debug-and-related-functionality-private.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mm.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

