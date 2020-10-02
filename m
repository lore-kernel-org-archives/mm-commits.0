Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F275C35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13854208C7
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601674158;
	bh=9RxdCTo6teBh6xRgSe9AxtljwCZ+cs+2VLYH7UdoLug=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cl8cFUOrMbcio78zFMD3dlaoWl18UYUxeNrbLlymaOBdVlmLnTYq3/VJQRbHn46ST
	 9sH/V358tvhu5r2eQrNg5UkU9MoKdju1MhcoVUlR3z/fIQ/W6QsZU7AdKQjykcKMhD
	 pj6EUMypjwJN395qB1Zzh2MVtymfceVw2arJ+OsQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJBV3R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJBV3R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:29:17 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C19162145D;
        Fri,  2 Oct 2020 21:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601674157;
        bh=9RxdCTo6teBh6xRgSe9AxtljwCZ+cs+2VLYH7UdoLug=;
        h=Date:From:To:Subject:From;
        b=gbPgwFdW0yuSMp/puDNWSZcZ6RdcDcegNlpopl9w4XhwA57mWCvTdw1wbL7wu+F6H
         NRD8XL9lvfzvV6FkirRBdTDC4LlykS86cb2rum+Xdglh6pkS9e3dqGNj9MXw/jZIng
         tTu7SJYbJiLI0LHOwi2iL2HUYECEis/iwIONgVwo=
Date:   Fri, 02 Oct 2020 14:29:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        tvrtko.ursulin@intel.com, sstabellini@kernel.org,
        rodrigo.vivi@intel.com, peterz@infradead.org, ngupta@vflare.org,
        minchan@kernel.org, matthew.auld@intel.com,
        joonas.lahtinen@linux.intel.com, jgross@suse.com,
        jani.nikula@linux.intel.com, chris@chris-wilson.co.uk,
        boris.ostrovsky@oracle.com, hch@lst.de
Subject:  + drm-i915-stop-using-kmap-in-i915_gem_object_map.patch
 added to -mm tree
Message-ID: <20201002212916.vcKB-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: stop using kmap in i915_gem_object_map
has been added to the -mm tree.  Its filename is
     drm-i915-stop-using-kmap-in-i915_gem_object_map.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drm-i915-stop-using-kmap-in-i915_gem_object_map.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drm-i915-stop-using-kmap-in-i915_gem_object_map.patch

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
Subject: drm/i915: stop using kmap in i915_gem_object_map

kmap for !PageHighmem is just a convoluted way to say page_address, and
kunmap is a no-op in that case.

Link: https://lkml.kernel.org/r/20201002122204.1534411-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
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
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_pages.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c~drm-i915-stop-using-kmap-in-i915_gem_object_map
+++ a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -162,8 +162,6 @@ static void unmap_object(struct drm_i915
 {
 	if (is_vmalloc_addr(ptr))
 		vunmap(ptr);
-	else
-		kunmap(kmap_to_page(ptr));
 }
 
 struct sg_table *
@@ -277,11 +275,10 @@ static void *i915_gem_object_map(struct
 		 * forever.
 		 *
 		 * So if the page is beyond the 32b boundary, make an explicit
-		 * vmap. On 64b, this check will be optimised away as we can
-		 * directly kmap any page on the system.
+		 * vmap.
 		 */
 		if (!PageHighMem(page))
-			return kmap(page);
+			return page_address(page);
 	}
 
 	mem = stack;
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

