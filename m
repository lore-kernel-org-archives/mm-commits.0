Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E60C35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9534A208C7
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601674149;
	bh=Tai+zPPHJRHY6HJd/IW/H/GejcBxG1OmCE2G8VLmhzA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KiA+zwUHwgTaMXenl15wAMxYhGPCUxuNAX4WNnSTKVCR1itfji7V4flt2ude/ItWX
	 mOcUl+LdX9pQHbXplXdMlz/pgCw95v733ETLQuJKAnj+/6t8CUXWSnPX8TPxUzjIib
	 nGxZl2wuRGNPzyomR6GY7XPGwW3VHMIyUD0/X234=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgJBV3J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJBV3J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:29:09 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2955206DB;
        Fri,  2 Oct 2020 21:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601674148;
        bh=Tai+zPPHJRHY6HJd/IW/H/GejcBxG1OmCE2G8VLmhzA=;
        h=Date:From:To:Subject:From;
        b=NhSQIoCqiefKjX5BU1nFk/+3nMpgMf+cYx+g4SayynOxf0wtMHTOSsH5yyhGir4lD
         6EiGsBG39ZfcSCS/9TtUojTKlLjNvfeTXSujjmhRCOpKBa7xPcy2INUjyPj2/e3TGJ
         sl2CCysloFj1AGOzuQOD1ZLbyOwslri43AcRQqXQ=
Date:   Fri, 02 Oct 2020 14:29:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        tvrtko.ursulin@intel.com, sstabellini@kernel.org,
        rodrigo.vivi@intel.com, peterz@infradead.org, ngupta@vflare.org,
        matthew.auld@intel.com, joonas.lahtinen@linux.intel.com,
        jgross@suse.com, jani.nikula@linux.intel.com,
        chris@chris-wilson.co.uk, boris.ostrovsky@oracle.com, hch@lst.de
Subject:  + mm-allow-a-null-fn-callback-in-apply_to_page_range.patch
 added to -mm tree
Message-ID: <20201002212907.Woil0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow a NULL fn callback in apply_to_page_range
has been added to the -mm tree.  Its filename is
     mm-allow-a-null-fn-callback-in-apply_to_page_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-allow-a-null-fn-callback-in-apply_to_page_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-allow-a-null-fn-callback-in-apply_to_page_range.patch

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
Subject: mm: allow a NULL fn callback in apply_to_page_range

Besides calling the callback on each page, apply_to_page_range also has
the effect of pre-faulting all PTEs for the range.  To support callers
that only need the pre-faulting, make the callback optional.

Based on a patch from Minchan Kim <minchan@kernel.org>.

Link: https://lkml.kernel.org/r/20201002122204.1534411-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
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
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-allow-a-null-fn-callback-in-apply_to_page_range
+++ a/mm/memory.c
@@ -2427,13 +2427,15 @@ static int apply_to_pte_range(struct mm_
 
 	arch_enter_lazy_mmu_mode();
 
-	do {
-		if (create || !pte_none(*pte)) {
-			err = fn(pte++, addr, data);
-			if (err)
-				break;
-		}
-	} while (addr += PAGE_SIZE, addr != end);
+	if (fn) {
+		do {
+			if (create || !pte_none(*pte)) {
+				err = fn(pte++, addr, data);
+				if (err)
+					break;
+			}
+		} while (addr += PAGE_SIZE, addr != end);
+	}
 	*mask |= PGTBL_PTE_MODIFIED;
 
 	arch_leave_lazy_mmu_mode();
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

