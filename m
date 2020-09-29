Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE70C4727D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 22:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF646207F7
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 22:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601416834;
	bh=S1HTK9v+BFSY3Ai3vA9ghq1Gk2FPP0csvTi14GDXEEk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VAws/QAkOla3dQ+la5XqOT2rK4vMCMWdbRQAe6Ow1/BoVSEExcq9PpMbaRMc8fZ+G
	 oIS/iWVaoBh14p8xLKC2mLuJtj5h/vkx/ztTDC/NpbhMKVVaBo8qGR1OouTzA7Kibq
	 57iVDIzE4qoI1/a9fwWbNM2YWkbuFhRCE8E0h1o8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgI2WAd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Sep 2020 18:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgI2WAd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Sep 2020 18:00:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4200320789;
        Tue, 29 Sep 2020 22:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601416832;
        bh=S1HTK9v+BFSY3Ai3vA9ghq1Gk2FPP0csvTi14GDXEEk=;
        h=Date:From:To:Subject:From;
        b=tQXXB8Bs8wTxxyW+3AZOi3+qcJs8P36rj4xGrX/kKYBRec753/f78SOV71892l/+N
         5K09mAi6K7/qzhWXHm/PxFVXwyMhme01MTWyINLBvX3WFOTOO05kV4AbIMcZgtuRgg
         bFERnM8SD3gfAnORzD0i1trgnwMIMQ2PZCIwcLQI=
Date:   Tue, 29 Sep 2020 15:00:31 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bo.liu@linux.alibaba.com,
        dan.j.williams@intel.com, dgilbert@redhat.com,
        mm-commits@vger.kernel.org, mszeredi@redhat.com,
        sebastien.boeuf@intel.com, stefanha@redhat.com, vgoyal@redhat.com
Subject:  +
 fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
 added to -mm tree
Message-ID: <20200929220031.xAGgIIdZ4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fuse/virtio_fs.c: fix for "mm/memremap_pages: convert to 'struct range'"
has been added to the -mm tree.  Its filename is
     fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch

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
Subject: fs/fuse/virtio_fs.c: fix for "mm/memremap_pages: convert to 'struct range'"

Fix interaction with 22f3787e9d95e ("virtiofs: set up virtio_fs
dax_device").

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Sebastien Boeuf <sebastien.boeuf@intel.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/virtio_fs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/fuse/virtio_fs.c~fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range
+++ a/fs/fuse/virtio_fs.c
@@ -835,8 +835,7 @@ static int virtio_fs_setup_dax(struct vi
 	 * initialize a struct resource from scratch (only the start
 	 * and end fields will be used).
 	 */
-	pgmap->res = (struct resource){
-		.name = "virtio-fs dax window",
+	pgmap->range = (struct range){
 		.start = (phys_addr_t) cache_reg.addr,
 		.end = (phys_addr_t) cache_reg.addr + cache_reg.len - 1,
 	};
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch

