Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883BCC43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 493E9221EC
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600474123;
	bh=2+WFwIkzGsHp4uDi9cuWkiPxHL927jwryNE+7BvL8Fo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xx7KSGTx2E1xdW97KTZJY8QeeDgKxpMZgwxWXyrOvofT+AKHzUIPibA7XQfdMmgZC
	 EmaM+bDfcYwLkFVp1tqDqjxhjIS2Y7eKQ7bh6XIHm7Zl+Wg6CsFmQogxMRkdYnxa+Z
	 XuZHFmDJVIGQNLGNNBU8ey+SAIqB5KCGa+I5moGI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgISAIm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAIm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:08:42 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B69A21D43;
        Sat, 19 Sep 2020 00:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600474121;
        bh=2+WFwIkzGsHp4uDi9cuWkiPxHL927jwryNE+7BvL8Fo=;
        h=Date:From:To:Subject:From;
        b=p8fC5/N5aGXTsl/om73L1Tn7T/mEx2OKTp+TOg7O8qHrJijUI2fvRibRPcK1YJ5h9
         uM6shdS6RzpppqjuQtqNPfzqzkGZkdAkFVU4WpJqj4fCj+C3DtODy742WRFV01LgKR
         25QRuc3X3TJRa4RFCx3ihMgQUCVrkTsVSzPajtMc=
Date:   Fri, 18 Sep 2020 17:08:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sstabellini@kernel.org,
        rodrigo.vivi@intel.com, peterz@infradead.org, ngupta@vflare.org,
        minchan@kernel.org, joonas.lahtinen@linux.intel.com,
        jgross@suse.com, jani.nikula@linux.intel.com,
        boris.ostrovsky@oracle.com, hch@lst.de
Subject:  + zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
 added to -mm tree
Message-ID: <20200919000840.oIkkr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: switch from alloc_vm_area to get_vm_area
has been added to the -mm tree.  Its filename is
     zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch

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
Subject: zsmalloc: switch from alloc_vm_area to get_vm_area

Patch series "remove alloc_vm_area".

This series removes alloc_vm_area, which was left over from the big
vmalloc interface rework.  It is a rather arcane interface, basically the
equivalent of get_vm_area + actually faulting in all PTEs in the allocated
area.  It was originally addeds for Xen (which isn't modular to start
with), and then grew users in zsmalloc and i915 which seems to mostly
qualify as abuses of the interface, especially for i915 as a random driver
should not set up PTE bits directly.

Note that my laptop doesn't seem to actually exercise the new vmap_pfn
path, so careful review from the i915 maintainers is very welcome.

Also I wonder why zsmalloc is even doing the manual allocation of kernel
virtual address space plus mapping into it.  IMHO zsmalloc should be using
our normal vm_map_ram / vm_unmap_ram interface instead of being so
special, which would also allow building it as a module again for the
virtual mapping case.


This patch (of 6):

There is no obvious reason why zsmalloc needs to pre-fault the PTEs given
that it later uses map_kernel_range to just like vmap().

Link: https://lkml.kernel.org/r/20200918163724.2511-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-switch-from-alloc_vm_area-to-get_vm_area
+++ a/mm/zsmalloc.c
@@ -1122,7 +1122,7 @@ static inline int __zs_cpu_up(struct map
 	 */
 	if (area->vm)
 		return 0;
-	area->vm = alloc_vm_area(PAGE_SIZE * 2, NULL);
+	area->vm = get_vm_area(PAGE_SIZE * 2, 0);
 	if (!area->vm)
 		return -ENOMEM;
 	return 0;
_

Patches currently in -mm which might be from hch@lst.de are

zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
mm-add-a-vmap_pfn-function.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch

