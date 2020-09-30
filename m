Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F9CC4363D
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B541120888
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601502015;
	bh=SS5MNMZ2/GhR/Yo5g74UMwT6imuWsW54FuYahtVkYF4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=d0Y2O2KPVKGn27Ve/Y744ObiFUxi9YIJTHm3AnWdUXM8F/HArSnknQjGbKfLINgJt
	 GhEm1UHZO5HJqvI14z6Oq1Lyhfe36q4AII2XEFSRc3DHBmz1sNoVWQzYUEhcHhqhJH
	 WdeKfdVDqMzukd1sfRYZwzSGPUtyKV19AKx1vtDQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730873AbgI3VkP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbgI3VkP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 17:40:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F0C520791;
        Wed, 30 Sep 2020 21:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601502014;
        bh=SS5MNMZ2/GhR/Yo5g74UMwT6imuWsW54FuYahtVkYF4=;
        h=Date:From:To:Subject:From;
        b=HG2pKAvLjgX7i6t9Tgf7mRv5gWJLWV72q/AeErNhVoNegXUXJatFl+6KF0W15dPr3
         IklY3jX3tMd1hqKiJ8FMVCRbWYEhlJw4/0ZjzzWe4eSC5y6hOcYRz1LdfIZvXChEYS
         HsV7mqgNM5doORsm03+YqbM/7USGWtqwIOrIJXoU=
Date:   Wed, 30 Sep 2020 14:40:13 -0700
From:   akpm@linux-foundation.org
To:     boris.ostrovsky@oracle.com, chris@chris-wilson.co.uk, hch@lst.de,
        jani.nikula@linux.intel.com, jgross@suse.com,
        joonas.lahtinen@linux.intel.com, matthew.auld@intel.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, tvrtko.ursulin@intel.com,
        willy@infradead.org
Subject:  +
 x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch added to -mm
 tree
Message-ID: <20200930214013.9fmRN6dNT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

Link: https://lkml.kernel.org/r/20200930175133.1252382-10-hch@lst.de
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
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch
mm-remove-alloc_vm_area.patch

