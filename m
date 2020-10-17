Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6345FC433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 331B82158C
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976529;
	bh=G6bNKV/FicSzR9QS63wElgYsdlKipWPVJtECbNSFAoU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=vne5W4TbIdIokNYDguS5yU/YXHZPs38W187MR10C+wyi8LcAMIlvdw9uTrTNUm2SM
	 sUQQ3JIqqSHBmPqjhG0RqxnmdW9h9v9fxNbMP0vbSm3iy7UmZkAoiVXjOoWp32KtJH
	 o5b1eFnfwB8U5XlSvvsBMzzg1+80oTgq3MyEbX+c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439916AbgJQXP2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXP2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:15:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AAC3216C4;
        Sat, 17 Oct 2020 23:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976526;
        bh=G6bNKV/FicSzR9QS63wElgYsdlKipWPVJtECbNSFAoU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=g4FQ3wuzB1YKqNWI/pFZasnUJ5/kpfpPblFqKCJq6O51zl0KreoQUnBdShkKVCOtJ
         8uttmi2Pa45KXNpzscOKDtiJ3jAU5aaqnh66LflC1QEicf9Ky8Vt0YMFPHv+8cJeai
         2cPyQemKK2VMpy3fgtXjTpD3neIHkzZ6n0wfBG8E=
Date:   Sat, 17 Oct 2020 16:15:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, boris.ostrovsky@oracle.com,
        chris@chris-wilson.co.uk, hch@lst.de, jani.nikula@linux.intel.com,
        jgross@suse.com, joonas.lahtinen@linux.intel.com,
        linux-mm@kvack.org, matthew.auld@intel.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, torvalds@linux-foundation.org,
        tvrtko.ursulin@intel.com, urezki@gmail.com, willy@infradead.org
Subject:  [patch 33/40] drm/i915: stop using kmap in
 i915_gem_object_map
Message-ID: <20201017231525.AHOtu7_aI%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
