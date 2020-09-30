Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F33C4741F
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7D6C20789
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601501994;
	bh=8Neml5mVuGxPjfyb2hN2nrd7LMpSGPMpsNs7Dm5CQnc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=z2h1QHRAPjE4eWnSlOdjGrL+5yx1Dv6iBoVdJMRHOduzfo4gGVkA+KYsa8hVJ7M4y
	 B+X1DKyfYSuJlA4XreX4g+ezsQjDvPZPwdALYPWugn1t1Ic4jTpCyvOzRkaU3dYaBF
	 XNLsPdZNviln+vsvqpy6sDixdB6/IdxxIMbrPtYs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgI3Vjy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730457AbgI3Vjy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 17:39:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1845E20759;
        Wed, 30 Sep 2020 21:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601501993;
        bh=8Neml5mVuGxPjfyb2hN2nrd7LMpSGPMpsNs7Dm5CQnc=;
        h=Date:From:To:Subject:From;
        b=GA67zOKiaIOqZq9xBqfLwvYdLJD1yq19S7/WiLop0FgkrimSMVYgKPvJJso6CKsKE
         Hu1XiYoRg5DDOMuSWukC8XfPD4re4O1/HCfqFhEescw2muBlTDyALPTIofEsHJ+uNG
         5axL58KtsomQfunCkRcvSWZkLFcMePr0fBaZv5+w=
Date:   Wed, 30 Sep 2020 14:39:52 -0700
From:   akpm@linux-foundation.org
To:     boris.ostrovsky@oracle.com, chris@chris-wilson.co.uk, hch@lst.de,
        jani.nikula@linux.intel.com, jgross@suse.com,
        joonas.lahtinen@linux.intel.com, matthew.auld@intel.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, tvrtko.ursulin@intel.com,
        willy@infradead.org
Subject:  + mm-add-a-vm_map_put_pages-flag-for-vmap.patch added to
 -mm tree
Message-ID: <20200930213952.N2MUagbPS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add a VM_MAP_PUT_PAGES flag for vmap
has been added to the -mm tree.  Its filename is
     mm-add-a-vm_map_put_pages-flag-for-vmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-a-vm_map_put_pages-flag-for-vmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-a-vm_map_put_pages-flag-for-vmap.patch

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
Subject: mm: add a VM_MAP_PUT_PAGES flag for vmap

Add a flag so that vmap takes ownership of the passed in page array.  When
vfree is called on such an allocation it will put one reference on each
page, and free the page array itself.

Link: https://lkml.kernel.org/r/20200930175133.1252382-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
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
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/vmalloc.h~mm-add-a-vm_map_put_pages-flag-for-vmap
+++ a/include/linux/vmalloc.h
@@ -24,6 +24,7 @@ struct notifier_block;		/* in notifier.h
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
 #define VM_NO_GUARD		0x00000040      /* don't add guard page */
 #define VM_KASAN		0x00000080      /* has allocated kasan shadow memory */
+#define VM_MAP_PUT_PAGES	0x00000100	/* put pages and free array in vfree */
 
 /*
  * VM_KASAN is used slighly differently depending on CONFIG_KASAN_VMALLOC.
--- a/mm/vmalloc.c~mm-add-a-vm_map_put_pages-flag-for-vmap
+++ a/mm/vmalloc.c
@@ -2377,8 +2377,11 @@ EXPORT_SYMBOL(vunmap);
  * @flags: vm_area->flags
  * @prot: page protection for the mapping
  *
- * Maps @count pages from @pages into contiguous kernel virtual
- * space.
+ * Maps @count pages from @pages into contiguous kernel virtual space.
+ * If @flags contains %VM_MAP_PUT_PAGES the ownership of the pages array itself
+ * (which must be kmalloc or vmalloc memory) and one reference per pages in it
+ * are transferred from the caller to vmap(), and will be freed / dropped when
+ * vfree() is called on the return value.
  *
  * Return: the address of the area or %NULL on failure
  */
@@ -2404,6 +2407,8 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 	}
 
+	if (flags & VM_MAP_PUT_PAGES)
+		area->pages = pages;
 	return area->addr;
 }
 EXPORT_SYMBOL(vmap);
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

