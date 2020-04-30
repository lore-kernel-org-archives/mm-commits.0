From: akpm@linux-foundation.org
Subject: + drm-remove-drm-specific-kmap_atomic-code.patch added to
 -mm tree
Date: Thu, 30 Apr 2020 14:21:24 -0700
Message-ID: <20200430212124.UsmZBHUgQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgD3VV1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 17:21:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, ray.huang@amd.com, tglx@linutronix.de, thellstrom@vmware.com, tsbogend@alpha.franken.de


The patch titled
     Subject: drm: remove drm specific kmap_atomic code
has been added to the -mm tree.  Its filename is
     drm-remove-drm-specific-kmap_atomic-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-remove-drm-specific-kmap_atomic-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-remove-drm-specific-kmap_atomic-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: drm: remove drm specific kmap_atomic code

kmap_atomic_prot() is now exported by all architectures.  Use this
function rather than open coding a driver specific kmap_atomic.

Link: http://lkml.kernel.org/r/20200430203845.582900-11-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/ttm/ttm_bo_util.c    |   56 +------------------------
 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c |   16 +++----
 include/drm/ttm/ttm_bo_api.h         |    4 -
 3 files changed, 12 insertions(+), 64 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c~drm-remove-drm-specific-kmap_atomic-code
+++ a/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -257,54 +257,6 @@ static int ttm_copy_io_page(void *dst, v
 	return 0;
 }
 
-#ifdef CONFIG_X86
-#define __ttm_kmap_atomic_prot(__page, __prot) kmap_atomic_prot(__page, __prot)
-#define __ttm_kunmap_atomic(__addr) kunmap_atomic(__addr)
-#else
-#define __ttm_kmap_atomic_prot(__page, __prot) vmap(&__page, 1, 0,  __prot)
-#define __ttm_kunmap_atomic(__addr) vunmap(__addr)
-#endif
-
-
-/**
- * ttm_kmap_atomic_prot - Efficient kernel map of a single page with
- * specified page protection.
- *
- * @page: The page to map.
- * @prot: The page protection.
- *
- * This function maps a TTM page using the kmap_atomic api if available,
- * otherwise falls back to vmap. The user must make sure that the
- * specified page does not have an aliased mapping with a different caching
- * policy unless the architecture explicitly allows it. Also mapping and
- * unmapping using this api must be correctly nested. Unmapping should
- * occur in the reverse order of mapping.
- */
-void *ttm_kmap_atomic_prot(struct page *page, pgprot_t prot)
-{
-	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL))
-		return kmap_atomic(page);
-	else
-		return __ttm_kmap_atomic_prot(page, prot);
-}
-EXPORT_SYMBOL(ttm_kmap_atomic_prot);
-
-/**
- * ttm_kunmap_atomic_prot - Unmap a page that was mapped using
- * ttm_kmap_atomic_prot.
- *
- * @addr: The virtual address from the map.
- * @prot: The page protection.
- */
-void ttm_kunmap_atomic_prot(void *addr, pgprot_t prot)
-{
-	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL))
-		kunmap_atomic(addr);
-	else
-		__ttm_kunmap_atomic(addr);
-}
-EXPORT_SYMBOL(ttm_kunmap_atomic_prot);
-
 static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
 				unsigned long page,
 				pgprot_t prot)
@@ -316,13 +268,13 @@ static int ttm_copy_io_ttm_page(struct t
 		return -ENOMEM;
 
 	src = (void *)((unsigned long)src + (page << PAGE_SHIFT));
-	dst = ttm_kmap_atomic_prot(d, prot);
+	dst = kmap_atomic_prot(d, prot);
 	if (!dst)
 		return -ENOMEM;
 
 	memcpy_fromio(dst, src, PAGE_SIZE);
 
-	ttm_kunmap_atomic_prot(dst, prot);
+	kunmap_atomic(dst);
 
 	return 0;
 }
@@ -338,13 +290,13 @@ static int ttm_copy_ttm_io_page(struct t
 		return -ENOMEM;
 
 	dst = (void *)((unsigned long)dst + (page << PAGE_SHIFT));
-	src = ttm_kmap_atomic_prot(s, prot);
+	src = kmap_atomic_prot(s, prot);
 	if (!src)
 		return -ENOMEM;
 
 	memcpy_toio(dst, src, PAGE_SIZE);
 
-	ttm_kunmap_atomic_prot(src, prot);
+	kunmap_atomic(src);
 
 	return 0;
 }
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c~drm-remove-drm-specific-kmap_atomic-code
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
@@ -374,12 +374,12 @@ static int vmw_bo_cpu_blit_line(struct v
 		copy_size = min_t(u32, copy_size, PAGE_SIZE - src_page_offset);
 
 		if (unmap_src) {
-			ttm_kunmap_atomic_prot(d->src_addr, d->src_prot);
+			kunmap_atomic(d->src_addr);
 			d->src_addr = NULL;
 		}
 
 		if (unmap_dst) {
-			ttm_kunmap_atomic_prot(d->dst_addr, d->dst_prot);
+			kunmap_atomic(d->dst_addr);
 			d->dst_addr = NULL;
 		}
 
@@ -388,8 +388,8 @@ static int vmw_bo_cpu_blit_line(struct v
 				return -EINVAL;
 
 			d->dst_addr =
-				ttm_kmap_atomic_prot(d->dst_pages[dst_page],
-						     d->dst_prot);
+				kmap_atomic_prot(d->dst_pages[dst_page],
+						 d->dst_prot);
 			if (!d->dst_addr)
 				return -ENOMEM;
 
@@ -401,8 +401,8 @@ static int vmw_bo_cpu_blit_line(struct v
 				return -EINVAL;
 
 			d->src_addr =
-				ttm_kmap_atomic_prot(d->src_pages[src_page],
-						     d->src_prot);
+				kmap_atomic_prot(d->src_pages[src_page],
+						 d->src_prot);
 			if (!d->src_addr)
 				return -ENOMEM;
 
@@ -499,9 +499,9 @@ int vmw_bo_cpu_blit(struct ttm_buffer_ob
 	}
 out:
 	if (d.src_addr)
-		ttm_kunmap_atomic_prot(d.src_addr, d.src_prot);
+		kunmap_atomic(d.src_addr);
 	if (d.dst_addr)
-		ttm_kunmap_atomic_prot(d.dst_addr, d.dst_prot);
+		kunmap_atomic(d.dst_addr);
 
 	return ret;
 }
--- a/include/drm/ttm/ttm_bo_api.h~drm-remove-drm-specific-kmap_atomic-code
+++ a/include/drm/ttm/ttm_bo_api.h
@@ -668,10 +668,6 @@ int ttm_bo_mmap_obj(struct vm_area_struc
 int ttm_bo_mmap(struct file *filp, struct vm_area_struct *vma,
 		struct ttm_bo_device *bdev);
 
-void *ttm_kmap_atomic_prot(struct page *page, pgprot_t prot);
-
-void ttm_kunmap_atomic_prot(void *addr, pgprot_t prot);
