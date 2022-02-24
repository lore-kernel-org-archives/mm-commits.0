Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048BDC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 03:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiBXDuk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 22:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiBXDuj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 22:50:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C260C20D82F
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 19:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D49F616CC
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 03:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B509AC340E9;
        Thu, 24 Feb 2022 03:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645674609;
        bh=oFD6S3d484UEcMMNlS79p9PX/PMp/2usuGMjJ2Bxmjo=;
        h=Date:To:From:Subject:From;
        b=OCPuS4b7HhcslBgNmcYhuEp7bRq1nnM7OclOI/ApZkUff5Kb6Q8KlLk1ZAMBJqFZZ
         h7B/ptz4C/XxafovKm0m4bSRri4rZ22W/oxuU9AK2KmF1ELXVlGYN5+Kt+dCsKXyJd
         SgjfGom9dUCG3HnVHQwOYVxnqiZKDtG1FUf7RatM=
Date:   Wed, 23 Feb 2022 19:50:09 -0800
To:     mm-commits@vger.kernel.org, neilb@suse.de,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch added to -mm tree
Message-Id: <20220224035009.B509AC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: remove-bdi_congested-and-wb_congested-and-related-functions-fix
has been added to the -mm tree.  Its filename is
     remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch

