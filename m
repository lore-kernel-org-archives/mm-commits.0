Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB1AC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiCVTF3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiCVTF2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:05:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66A6DE85
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:04:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89F78B81D5F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407D0C340F0;
        Tue, 22 Mar 2022 19:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647975838;
        bh=eIIuCZRYnTvSmZ2rggyDPxzjOB5sYYRyf+PCGqED8WU=;
        h=Date:To:From:Subject:From;
        b=An0YBZ+017Ks4i19NFYh2AhOyawjN8njM/CPWEYeaL7LeDKx3Eu/rUtEEVslcdbcH
         kfDweXON5JpX9vcFEq6J+goTRtcA6x4lEke76BE4wNWq/8gg2I0kTXMsNzvCToeQKd
         7rc313Mt48ts9YzBzj2G8+i0lEnqxwB3y0PaFW18=
Date:   Tue, 22 Mar 2022 12:03:57 -0700
To:     mm-commits@vger.kernel.org, neilb@suse.de,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch removed from -mm tree
Message-Id: <20220322190358.407D0C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: remove-bdi_congested-and-wb_congested-and-related-functions-fix
has been removed from the -mm tree.  Its filename was
     remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch

This patch was dropped because it was folded into remove-bdi_congested-and-wb_congested-and-related-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: remove-bdi_congested-and-wb_congested-and-related-functions-fix

fix build

fs/nilfs2/segbuf.c: In function 'nilfs_segbuf_submit_bio':
fs/nilfs2/segbuf.c:344:13: error: unused variable 'err' [-Werror=unused-variable]
  344 |         int err;

Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nilfs2/segbuf.c~remove-bdi_congested-and-wb_congested-and-related-functions-fix
+++ a/fs/nilfs2/segbuf.c
@@ -341,7 +341,6 @@ static int nilfs_segbuf_submit_bio(struc
 				   int mode_flags)
 {
 	struct bio *bio = wi->bio;
-	int err;
 
 	bio->bi_end_io = nilfs_end_bio_write;
 	bio->bi_private = segbuf;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-typesh-remove-unnecessary-__bitwise__-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

