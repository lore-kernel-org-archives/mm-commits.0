From: akpm@linux-foundation.org
Subject: + drm-remove-drm-specific-kmap_atomic-code.patch added to
 -mm tree
Date: Thu, 07 May 2020 13:36:59 -0700
Message-ID: <20200507203659.kOO8PgbKp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgEGUhC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 16:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: drm: remove drm specific kmap_atomic code
has been added to the -mm tree.  Its filename is
     drm-remove-drm-specific-kmap_atomic-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-remove-drm-specific-kmap_a=
tomic-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-remove-drm-specific-kmap_a=
tomic-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: drm: remove drm specific kmap_atomic code

kmap_atomic_prot() is now exported by all architectures.  Use this
function rather than open coding a driver specific kmap_atomic.

Link: http://lkml.kernel.org/r/20200507150004.1423069-12-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Christian K=C3=B6nig <christian.koenig@amd.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/ttm/ttm_bo_util.c    |   56 +------------------------
 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c |   16 +++----
 include/drm/ttm/ttm_bo_api.h         |    4 -
 3 files changed, 12 insertions(+), 64 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c~drm-remove-drm-specific-kmap_atomic=
-code
+++ a/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -257,54 +257,6 @@ static int ttm_copy_io_page(void *dst, v
 	return 0;
 }
=20
-#ifdef CONFIG_X86
-#define __ttm_kmap_atomic_prot(__page, __prot) kmap_atomic_prot(__page, __=
prot)
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
-	if (pgprot_val(prot) =3D=3D pgprot_val(PAGE_KERNEL))
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
-	if (pgprot_val(prot) =3D=3D pgprot_val(PAGE_KERNEL))
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
=20
 	src =3D (void *)((unsigned long)src + (page << PAGE_SHIFT));
-	dst =3D ttm_kmap_atomic_prot(d, prot);
+	dst =3D kmap_atomic_prot(d, prot);
 	if (!dst)
 		return -ENOMEM;
=20
 	memcpy_fromio(dst, src, PAGE_SIZE);
=20
-	ttm_kunmap_atomic_prot(dst, prot);
+	kunmap_atomic(dst);
=20
 	return 0;
 }
@@ -338,13 +290,13 @@ static int ttm_copy_ttm_io_page(struct t
 		return -ENOMEM;
=20
 	dst =3D (void *)((unsigned long)dst + (page << PAGE_SHIFT));
-	src =3D ttm_kmap_atomic_prot(s, prot);
+	src =3D kmap_atomic_prot(s, prot);
 	if (!src)
 		return -ENOMEM;
=20
 	memcpy_toio(dst, src, PAGE_SIZE);
=20
-	ttm_kunmap_atomic_prot(src, prot);
+	kunmap_atomic(src);
=20
 	return 0;
 }
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c~drm-remove-drm-specific-kmap_ato=
mic-code
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
@@ -374,12 +374,12 @@ static int vmw_bo_cpu_blit_line(struct v
 		copy_size =3D min_t(u32, copy_size, PAGE_SIZE - src_page_offset);
=20
 		if (unmap_src) {
-			ttm_kunmap_atomic_prot(d->src_addr, d->src_prot);
+			kunmap_atomic(d->src_addr);
 			d->src_addr =3D NULL;
 		}
=20
 		if (unmap_dst) {
-			ttm_kunmap_atomic_prot(d->dst_addr, d->dst_prot);
+			kunmap_atomic(d->dst_addr);
 			d->dst_addr =3D NULL;
 		}
=20
@@ -388,8 +388,8 @@ static int vmw_bo_cpu_blit_line(struct v
 				return -EINVAL;
=20
 			d->dst_addr =3D
-				ttm_kmap_atomic_prot(d->dst_pages[dst_page],
-						     d->dst_prot);
+				kmap_atomic_prot(d->dst_pages[dst_page],
+						 d->dst_prot);
 			if (!d->dst_addr)
 				return -ENOMEM;
=20
@@ -401,8 +401,8 @@ static int vmw_bo_cpu_blit_line(struct v
 				return -EINVAL;
=20
 			d->src_addr =3D
-				ttm_kmap_atomic_prot(d->src_pages[src_page],
-						     d->src_prot);
+				kmap_atomic_prot(d->src_pages[src_page],
+						 d->src_prot);
 			if (!d->src_addr)
 				return -ENOMEM;
=20
@@ -499,9 +499,9 @@ int vmw_bo_cpu_blit(struct ttm_buffer_ob
 	}
 out:
 	if (d.src_addr)
-		ttm_kunmap_atomic_prot(d.src_addr, d.src_prot);
+		kunmap_atomic(d.src_addr);
 	if (d.dst_addr)
-		ttm_kunmap_atomic_prot(d.dst_addr, d.dst_prot);
+		kunmap_atomic(d.dst_addr);
=20
 	return ret;
 }
--- a/include/drm/ttm/ttm_bo_api.h~drm-remove-drm-specific-kmap_atomic-code
+++ a/include/drm/ttm/ttm_bo_api.h
@@ -668,10 +668,6 @@ int ttm_bo_mmap_obj(struct vm_area_struc
 int ttm_bo_mmap(struct file *filp, struct vm_area_struct *vma,
 		struct ttm_bo_device *bdev);
=20
-void *ttm_kmap_atomic_prot(struct page *page, pgprot_t prot);
-
-void ttm_kunmap_atomic_prot(void *addr, pgprot_t prot);
