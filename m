Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450A2C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjBCFsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjBCFsp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:48:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD7D87D18
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:48:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE2B061D0D
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45834C4339B;
        Fri,  3 Feb 2023 05:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675403322;
        bh=TSV0pe2lJ2uptLSd+lUyU21zPacNGYTcuTqRkvOpByQ=;
        h=Date:To:From:Subject:From;
        b=VGITup2jeGbLNEdgilXRP9RFfbdyP3qbdTRltf9+ipXDE/lkZuyehxljTScJSKIxL
         qoKDYKGfFeT+K/HcMmCSdHZxdXqt+tU3IEuIym7dbHQj4EPOYD0h6LnVY29nQxUUSJ
         lhRACIP5+vzMfQOS6onhYaiiNLumQ60nbF1vLDyA=
Date:   Thu, 02 Feb 2023 21:48:41 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, hch@lst.de, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] block-remove-rw_page-fix.patch removed from -mm tree
Message-Id: <20230203054842.45834C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: block-remove-rw_page-fix
has been removed from the -mm tree.  Its filename was
     block-remove-rw_page-fix.patch

This patch was dropped because it was folded into block-remove-rw_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-remove-rw_page-fix
Date: Wed Jan 25 05:22:22 PM PST 2023

fix comment typo, per Dan

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


--- a/include/linux/blkdev.h~block-remove-rw_page-fix
+++ a/include/linux/blkdev.h
@@ -554,7 +554,7 @@ struct request_queue {
 #define QUEUE_FLAG_IO_STAT	7	/* do disk/partitions IO accounting */
 #define QUEUE_FLAG_NOXMERGES	9	/* No extended merges */
 #define QUEUE_FLAG_ADD_RANDOM	10	/* Contributes to random pool */
-#define QUEUE_FLAG_SYNCHRONOUS	11	/* always complets in submit context */
+#define QUEUE_FLAG_SYNCHRONOUS	11	/* always completes in submit context */
 #define QUEUE_FLAG_SAME_FORCE	12	/* force complete on same CPU */
 #define QUEUE_FLAG_INIT_DONE	14	/* queue is initialized */
 #define QUEUE_FLAG_STABLE_WRITES 15	/* don't modify blks until WB is done */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch
block-remove-rw_page.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

