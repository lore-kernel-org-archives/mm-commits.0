Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43E9C35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B077321789
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601674173;
	bh=c85NQ47ruLK3TQUqWi5qg4Vg2CaLSrzf70Vpecr5NAM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=B2+W78g/BF4Gi4SCP0XZMCHaSspFsQz93yfAEna4PKH7ZBcWdcsgFQAO9YOMPYHMv
	 MGRlgx5Qr6BomxEN3dJcE2x2d37pEdNj2xddLynacxlENBUGcyENNT/pG3XxTo3mIV
	 l/VvsKodPRWXc1kQQZcEV/Hbu5aNKU7C9qO32Jkk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgJBV3d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgJBV3d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:29:33 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC6C721707;
        Fri,  2 Oct 2020 21:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601674172;
        bh=c85NQ47ruLK3TQUqWi5qg4Vg2CaLSrzf70Vpecr5NAM=;
        h=Date:From:To:Subject:From;
        b=Q6njLSxl9UAblNLFPYDB1wROjmIUluif/OLBkiDA78FUbi4kkEXm806rvitMmpE5I
         o38aCmF65ZNizaDNKHFy/fgb6xnmTda4MvR9zDhApkNBgJ4gic+HmR68vllaXvEDRr
         iIpfBe3Oyy3P6LwNRfLFnthVKddmkofvnb1GuLsc=
Date:   Fri, 02 Oct 2020 14:29:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@lst.de
Subject:  +
 mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc.patch added to
 -mm tree
Message-ID: <20201002212932.bMTNN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the filename in the top of file comment in vmalloc.c
has been added to the -mm tree.  Its filename is
     mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove the filename in the top of file comment in vmalloc.c

No point in having the filename inside the file.

Link: https://lkml.kernel.org/r/20201002124035.1539300-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmalloc.c~mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc
+++ a/mm/vmalloc.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/mm/vmalloc.c
- *
  *  Copyright (C) 1993  Linus Torvalds
  *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
  *  SMP-safe vmalloc/vfree/ioremap, Tigran Aivazian <tigran@veritas.com>, May 2000
_

Patches currently in -mm which might be from hch@lst.de are

mm-add-a-vm_map_put_pages-flag-for-vmap.patch
mm-add-a-vmap_pfn-function.patch
mm-allow-a-null-fn-callback-in-apply_to_page_range.patch
zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-stop-using-kmap-in-i915_gem_object_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch
mm-remove-alloc_vm_area.patch
mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node.patch
mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc.patch

