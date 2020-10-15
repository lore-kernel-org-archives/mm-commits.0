Return-Path: <SRS0=txOa=DW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15257C433DF
	for <mm-commits@archiver.kernel.org>; Thu, 15 Oct 2020 23:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A58D1207C4
	for <mm-commits@archiver.kernel.org>; Thu, 15 Oct 2020 23:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602803774;
	bh=24m2zp3WdIPDhG03q08J4EmT9lhJ3IJUII0dBhT2uEs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=b8dDGsvfLe7Xm8Q7til+piafJxDd18AKNB/HxCzGbBzr7XgoHnH41iHuTXbK2MMhf
	 lTTAsr5r70IaAi+tqckNq9OLsZKAg+9eoGm4WXo75+7CihGg4nVKsGtInAIlxijIUP
	 kT5qUSWEu4Wjqtk1k/7bArUTMiIocAvRnyJae1EA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732871AbgJOXQO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 19:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732869AbgJOXQO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 19:16:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9A7620797;
        Thu, 15 Oct 2020 23:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602803772;
        bh=24m2zp3WdIPDhG03q08J4EmT9lhJ3IJUII0dBhT2uEs=;
        h=Date:From:To:Subject:From;
        b=M/yZt2xr7dOIDhWviQAryW+u8DuOV7lAs6TT8weDR6OSYQ+ScQey+j43mWAEJS/ay
         HBN1k5UJdGmwdkF5RMg/iztkVz3oC42VB0auordTK1rw+REpMImHs7yMpOirUiq3yG
         SONBIUAVVW7n91uJRR4421hHhTlLRJcR9WIcUXyY=
Date:   Thu, 15 Oct 2020 16:16:11 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bo.liu@linux.alibaba.com,
        dan.j.williams@intel.com, dgilbert@redhat.com,
        mm-commits@vger.kernel.org, mszeredi@redhat.com,
        sebastien.boeuf@intel.com, stefanha@redhat.com, vgoyal@redhat.com
Subject:  [merged]
 fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
 removed from -mm tree
Message-ID: <20201015231611.jFaSm7UN7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fuse/virtio_fs.c: fix for "mm/memremap_pages: convert to 'struct range'"
has been removed from the -mm tree.  Its filename was
     fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

