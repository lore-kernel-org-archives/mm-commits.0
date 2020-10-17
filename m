Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32980C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F373820EDD
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976510;
	bh=yUfqaJ02dl6ucwXHLbBungiigrhtsAK717dpjBcJtz8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RZz2yJhM00WRfPN8KswEbc8yHjGjOmvGWmWTcxobSfpc79krZycM3/Uul9gRgKhfu
	 nhiljzIwtrp6QPJ4lsWrVosVXn35EV74ZQvT9G9hJouVY9qGP8gRChFfezXjXJKCYH
	 nFXAMcSV84cY+KsOL4+Q27Gq+wyWgk+PpF8OzPFY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439911AbgJQXPJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:15:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXPI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:15:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 405BB21556;
        Sat, 17 Oct 2020 23:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976507;
        bh=yUfqaJ02dl6ucwXHLbBungiigrhtsAK717dpjBcJtz8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gwIk66QvBOO1cEnI1S05L8SgCv4tCPNAynvJ+m6o4hpBBAw6QA+wBqq8Y4Xdcfk0f
         GMgepihR/d++Fz6cRE70TS+YAlwSsHNLXjFeGKfCd2+RKX5R4egZ1EP4HxCvk9yZON
         klfBGDqjHSoXETOdTYiW0NTjCNQhOhNtUVdlEU00=
Date:   Sat, 17 Oct 2020 16:15:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, boris.ostrovsky@oracle.com,
        chris@chris-wilson.co.uk, hch@lst.de, jani.nikula@linux.intel.com,
        jgross@suse.com, joonas.lahtinen@linux.intel.com,
        linux-mm@kvack.org, matthew.auld@intel.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, torvalds@linux-foundation.org,
        tvrtko.ursulin@intel.com, urezki@gmail.com, willy@infradead.org
Subject:  [patch 28/40] mm: add a VM_MAP_PUT_PAGES flag for vmap
Message-ID: <20201017231506.vz7J_Eu6T%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: add a VM_MAP_PUT_PAGES flag for vmap

Add a flag so that vmap takes ownership of the passed in page array.  When
vfree is called on such an allocation it will put one reference on each
page, and free the page array itself.

Link: https://lkml.kernel.org/r/20201002122204.1534411-3-hch@lst.de
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
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
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
