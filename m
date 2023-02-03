Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5780DC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjBCFsR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjBCFsQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:48:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F564F85C
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7647761D79
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47CEC4339B;
        Fri,  3 Feb 2023 05:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675403293;
        bh=odsPvS1kVe7HoK/p3Q/YxsZS4mdc4t9uVkLLhGN9EBc=;
        h=Date:To:From:Subject:From;
        b=XjRLKqVjraeakai3rn6KeMIz++qB7pQEqHjgudeoeJihE+W4zSjz+FzWeg4cm8YyZ
         wvyNw7xPq/l0eNBkXic7vwN9FFwMeDDJVo+Y8Wxy8AcrA8R65E0+qLzC93NslFT0IE
         ICEe/eBXzFSrCRBQg6r2WnXyPmW1hLYqo6Fida2I=
Date:   Thu, 02 Feb 2023 21:48:13 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, hch@lst.de, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-remove-the-swap_readpage-return-value-fix.patch removed from -mm tree
Message-Id: <20230203054813.C47CEC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-remove-the-swap_readpage-return-value-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-the-swap_readpage-return-value-fix.patch

This patch was dropped because it was folded into mm-remove-the-swap_readpage-return-value.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-the-swap_readpage-return-value-fix
Date: Wed Jan 25 05:23:19 PM PST 2023

fix void-returning swap_readpage() stub, per Keith

Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/swap.h~mm-remove-the-swap_readpage-return-value-fix
+++ a/mm/swap.h
@@ -66,7 +66,6 @@ struct swap_iocb;
 static inline void swap_readpage(struct page *page, bool do_poll,
 		struct swap_iocb **plug)
 {
-	return 0;
 }
 static inline void swap_write_unplug(struct swap_iocb *sio)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch
mm-remove-the-swap_readpage-return-value.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

