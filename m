Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE201C4727C
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 934C420789
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601502006;
	bh=YN0qNOmtVYsTl07ZpAgdXDIgIxDYtwJGKUHLiscHrtU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=onBk9XsCxl13iU2yFH11fcYCnUSFQZjMofcf7Bh0GZRrFNgVm46Lz0oM9FtCanjbn
	 /5WAw3X/S+QkS7WPahLmrPc+axO2V4dXCQFa6SQX6kawe1QrLcTKbCG6u9IJvMXWqm
	 1msecU/FeGyiAzwpNW8cXRdoPziR4Lxh6lPE3fsQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbgI3VkF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbgI3VkE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 17:40:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECDAC2075F;
        Wed, 30 Sep 2020 21:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601502002;
        bh=YN0qNOmtVYsTl07ZpAgdXDIgIxDYtwJGKUHLiscHrtU=;
        h=Date:From:To:Subject:From;
        b=arQmvsyr4cgn90fRMw/PD4KezeDPBV2u8i7+EWaJEm5jDhvCKmPZ46HRyqgtMOD4C
         levzB94lU1EoFdkWYCmi5vaztlTuc+LML4pdDESa8fGRQLysBKFRfTAbBpYZaQ3Fnt
         fnDEM38c8hG1PJFQgrukmawhV8HHTBzwRvWbvVco=
Date:   Wed, 30 Sep 2020 14:40:01 -0700
From:   akpm@linux-foundation.org
To:     boris.ostrovsky@oracle.com, chris@chris-wilson.co.uk, hch@lst.de,
        jani.nikula@linux.intel.com, jgross@suse.com,
        joonas.lahtinen@linux.intel.com, matthew.auld@intel.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, tvrtko.ursulin@intel.com,
        willy@infradead.org
Subject:  + zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
 added to -mm tree
Message-ID: <20200930214001.mZ7_8I87z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

Just manually pre-fault the PTEs using apply_to_page_range.

Link: https://lkml.kernel.org/r/20200930175133.1252382-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Co-developed-by: Minchan Kim <minchan@kernel.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-switch-from-alloc_vm_area-to-get_vm_area
+++ a/mm/zsmalloc.c
@@ -1122,10 +1122,16 @@ static inline int __zs_cpu_up(struct map
 	 */
 	if (area->vm)
 		return 0;
-	area->vm = alloc_vm_area(PAGE_SIZE * 2, NULL);
+	area->vm = get_vm_area(PAGE_SIZE * 2, 0);
 	if (!area->vm)
 		return -ENOMEM;
-	return 0;
+
+	/*
+	 * Populate ptes in advance to avoid pte allocation with GFP_KERNEL
+	 * in non-preemtible context of zs_map_object.
+	 */
+	return apply_to_page_range(&init_mm, (unsigned long)area->vm->addr,
+			PAGE_SIZE * 2, NULL, NULL);
 }
 
 static inline void __zs_cpu_down(struct mapping_area *area)
_

Patches currently in -mm which might be from hch@lst.de are

mm-add-a-vm_map_put_pages-flag-for-vmap.patch
mm-add-a-vmap_pfn-function.patch
mm-allow-a-null-fn-callback-in-apply_to_page_range.patch
zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch
mm-remove-alloc_vm_area.patch

