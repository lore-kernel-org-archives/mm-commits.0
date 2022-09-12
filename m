Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06FEC6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiILE5K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiILE44 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA919286C1
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74C16B80BA8
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1290EC433C1;
        Mon, 12 Sep 2022 04:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958600;
        bh=AUvodop4v/0BspFLM6QSCNc76bS5uaykEo1x1jTVHdc=;
        h=Date:To:From:Subject:From;
        b=bx9NKzO/LRJckJNuuvm28iL0AcZDgGZ/9Wmwz+GxPnLR/Hgc5g9UUbNH5dWXvjKf9
         uLCFwPiiANLulXoHKyG+g3AVKyoHT8/7r/UI7vFhDatdubTfOjSQwVTm004ZfAnFeJ
         dELQgHPdLCghOJvsnkzFG/elLWT4qSKRMsuqTVmU=
Date:   Sun, 11 Sep 2022 21:56:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        songmuchun@bytedance.com, slava@dubeyko.com,
        roman.gushchin@linux.dev, martin.petersen@oracle.com,
        keescook@chromium.org, kch@nvidia.com, jlayton@kernel.org,
        ira.weiny@intel.com, damien.lemoal@opensource.wdc.com,
        brauner@kernel.org, axboe@kernel.dk, arnd@arndb.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hfs-unmap-the-page-in-the-fail_page-label.patch removed from -mm tree
Message-Id: <20220912045640.1290EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hfs: unmap the page in the "fail_page" label
has been removed from the -mm tree.  Its filename was
     hfs-unmap-the-page-in-the-fail_page-label.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: hfs: unmap the page in the "fail_page" label
Date: Sun, 21 Aug 2022 20:03:58 +0200

Patch series "hfs: Replace kmap() with kmap_local_page()".

kmap() is being deprecated in favor of kmap_local_page().

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmaps pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts). 
It is faster than kmap() in kernels with HIGHMEM enabled.  Furthermore,
the tasks can be preempted and, when they are scheduled to run again, the
kernel virtual addresses are restored and still valid.

Since its use in fs/hfs is safe everywhere, it should be preferred.

Therefore, replace kmap() with kmap_local_page() in fs/hfs.  Where
possible, use the suited standard helpers (memzero_page(), memcpy_page())
instead of open coding kmap_local_page() plus memset() or memcpy().

Fix a bug due to a page being not unmapped if the code jumps to the
"fail_page" label (1/3).

Tested in a QEMU/KVM x86_32 VM, 6GB RAM, booting a kernel with
HIGHMEM64GB enabled.


This patch (of 3):

Several paths within hfs_btree_open() jump to the "fail_page" label where
put_page() is called while the page is still mapped.

Call kunmap() to unmap the page soon before put_page().

Link: https://lkml.kernel.org/r/20220821180400.8198-1-fmdefrancesco@gmail.com
Link: https://lkml.kernel.org/r/20220821180400.8198-2-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Matthew Wilcox <willy@infradead.org>]
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/btree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/hfs/btree.c~hfs-unmap-the-page-in-the-fail_page-label
+++ a/fs/hfs/btree.c
@@ -124,6 +124,7 @@ struct hfs_btree *hfs_btree_open(struct
 	return tree;
 
 fail_page:
+	kunmap(page);
 	put_page(page);
 free_inode:
 	tree->inode->i_mapping->a_ops = &hfs_aops;
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


