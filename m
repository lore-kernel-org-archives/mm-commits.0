Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495EDC4363D
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1718C21707
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601674168;
	bh=M3voeVOsiwUMKfMMXsTzALHTgB7JJAIKrg7DP2JOyUw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yExqjAnBWRn44FHxCNzE1Xaw8RQyOlTcPSJE+1/D9r6xk5ykPKbv16GQ3X+uzBjdv
	 BSKPLp+QXvO/CwjB6tVLGYkygqL9kc17qYwZ4L/mRVscd98ffbqUXIbNm0CMFjoqMv
	 6zDTtpWl4Dxl6q18UgQ50I08crKle2Q0HddnMAqU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725355AbgJBV31 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:29:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgJBV30 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:29:26 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C562321481;
        Fri,  2 Oct 2020 21:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601674165;
        bh=M3voeVOsiwUMKfMMXsTzALHTgB7JJAIKrg7DP2JOyUw=;
        h=Date:From:To:Subject:From;
        b=144+HQ6faFIq1qOakvpIPTTtYsF6I+DixnspYk3aP6Fn/O8PyUvWmPUHQH45Jsyal
         NHSuEIo5huDn4s64AuMLJB+85q8AIU2BykftsEKMb7MSZ9JTObUR19JsVZlJ95taeU
         AG5Jav6PIYY0TCdbpi6F2l1Gg35e/UzwF9H8GDBU=
Date:   Fri, 02 Oct 2020 14:29:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        tvrtko.ursulin@intel.com, sstabellini@kernel.org,
        rodrigo.vivi@intel.com, peterz@infradead.org, ngupta@vflare.org,
        minchan@kernel.org, matthew.auld@intel.com,
        joonas.lahtinen@linux.intel.com, jgross@suse.com,
        jani.nikula@linux.intel.com, chris@chris-wilson.co.uk,
        boris.ostrovsky@oracle.com, hch@lst.de
Subject:  +
 x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch added to -mm tree
Message-ID: <20201002212924.LzRWo%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/xen: open code alloc_vm_area in arch_gnttab_valloc
has been added to the -mm tree.  Its filename is
     x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch

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
Subject: x86/xen: open code alloc_vm_area in arch_gnttab_valloc

Replace the last call to alloc_vm_area with an open coded version using an
iterator in struct gnttab_vm_area instead of the triple indirection magic
in alloc_vm_area.

Link: https://lkml.kernel.org/r/20201002122204.1534411-11-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/grant-table.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/arch/x86/xen/grant-table.c~x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc
+++ a/arch/x86/xen/grant-table.c
@@ -25,6 +25,7 @@
 static struct gnttab_vm_area {
 	struct vm_struct *area;
 	pte_t **ptes;
+	int idx;
 } gnttab_shared_vm_area, gnttab_status_vm_area;
 
 int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
@@ -90,19 +91,31 @@ void arch_gnttab_unmap(void *shared, uns
 	}
 }
 
+static int gnttab_apply(pte_t *pte, unsigned long addr, void *data)
+{
+	struct gnttab_vm_area *area = data;
+
+	area->ptes[area->idx++] = pte;
+	return 0;
+}
+
 static int arch_gnttab_valloc(struct gnttab_vm_area *area, unsigned nr_frames)
 {
 	area->ptes = kmalloc_array(nr_frames, sizeof(*area->ptes), GFP_KERNEL);
 	if (area->ptes == NULL)
 		return -ENOMEM;
-
-	area->area = alloc_vm_area(PAGE_SIZE * nr_frames, area->ptes);
-	if (area->area == NULL) {
-		kfree(area->ptes);
-		return -ENOMEM;
-	}
-
+	area->area = get_vm_area(PAGE_SIZE * nr_frames, VM_IOREMAP);
+	if (!area->area)
+		goto out_free_ptes;
+	if (apply_to_page_range(&init_mm, (unsigned long)area->area->addr,
+			PAGE_SIZE * nr_frames, gnttab_apply, area))
+		goto out_free_vm_area;
 	return 0;
+out_free_vm_area:
+	free_vm_area(area->area);
+out_free_ptes:
+	kfree(area->ptes);
+	return -ENOMEM;
 }
 
 static void arch_gnttab_vfree(struct gnttab_vm_area *area)
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

