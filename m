Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2F5ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiILE4O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiILE4N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8254D220CE
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8A5260CA4
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424EDC433C1;
        Mon, 12 Sep 2022 04:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958571;
        bh=9TEHVj5y9tRujK3JblJTVzzJou6z/NORFJmUVkUX0Hw=;
        h=Date:To:From:Subject:From;
        b=ul79IU2wDbRRPE3xgWDe/xqOe2Y7YKGx1xV1YZStTju5d47tuDwUmAqB7j5N2auJ+
         9FcViIe8KZuM3KOYmN5ZIAakXDgUWzRbztkqn/Y6ab0Q9rf9Tkm+KH4e7oYbaXAlRQ
         F7LjMVxOIJa/g04uu6Ry+C3Fnim8fVxQGvWfRkzM=
Date:   Sun, 11 Sep 2022 21:56:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, slava@dubeyko.com, keescook@chromium.org,
        ira.weiny@intel.com, bvanassche@acm.org, axboe@kernel.dk,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hfsplus-unmap-the-page-in-the-fail_page-label.patch removed from -mm tree
Message-Id: <20220912045611.424EDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hfsplus: unmap the page in the "fail_page" label
has been removed from the -mm tree.  Its filename was
     hfsplus-unmap-the-page-in-the-fail_page-label.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: hfsplus: unmap the page in the "fail_page" label
Date: Tue, 9 Aug 2022 22:31:02 +0200

Patch series "hfsplus: Replace kmap() with kmap_local_page()".

kmap() is being deprecated in favor of kmap_local_page().

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmap’s pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts). 
It is faster than kmap() in kernels with HIGHMEM enabled.  Furthermore,
the tasks can be preempted and, when they are scheduled to run again, the
kernel virtual addresses are restored and still valid.

Since its use in fs/hfsplus is safe everywhere, it should be preferred.

Therefore, replace kmap() with kmap_local_page() in fs/hfsplus.  Where
possible, use the suited standard helpers (memzero_page(), memcpy_page())
instead of open coding kmap_local_page() plus memset() or memcpy().

Fix a bug due to a page being not unmapped if the code jumps to the
"fail_page" label (1/4).

Tested in a QEMU/KVM x86_32 VM, 6GB RAM, booting a kernel with
HIGHMEM64GB enabled.


This patch (of 4):

Several paths within hfs_btree_open() jump to the "fail_page" label where
put_page() is called while the page is still mapped.

Call kunmap() to unmap the page soon before put_page().

Link: https://lkml.kernel.org/r/20220809203105.26183-1-fmdefrancesco@gmail.com
Link: https://lkml.kernel.org/r/20220809203105.26183-2-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/btree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/hfsplus/btree.c~hfsplus-unmap-the-page-in-the-fail_page-label
+++ a/fs/hfsplus/btree.c
@@ -245,6 +245,7 @@ struct hfs_btree *hfs_btree_open(struct
 	return tree;
 
  fail_page:
+	kunmap(page);
 	put_page(page);
  free_inode:
 	tree->inode->i_mapping->a_ops = &hfsplus_aops;
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


