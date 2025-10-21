Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C0F283151
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 20:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761080033; cv=none; b=fmtBg7nvCoMpDif2R41PMLizG3w1sfEx5tgvk3ceQ7x41xSTfmD49PQKatqncXPIMUuoJ8SZMMdT5Uj6xXVSPVhEnVRUwRs8Tual/g24kAtd0zPCaGoxZr/uFYc0FAqiy6+AjZfvJWBhFlW62ZY3Yb2EXs7geI2daLabqXIvLBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761080033; c=relaxed/simple;
	bh=SUDf5IAQDsaFkgrIjRGGZxB3zfvR2Y8Jt8NUjoY9v/I=;
	h=Date:To:From:Subject:Message-Id; b=Kg1mkyp1UoafNImJy1csnCd4AVgURBO3yOh2BB4Ep0wiaw1E/onEB8i51m3PG+OvfzZ3gEscekiiDAvSVutU2mk+LvpdwkmEvPrC2sNFpBymj/XsA+im4N2zp3dmupYP0Pb+XCiggxdDIkbUenjgoRdEkEDQB4QWp+6aa/l4UXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N/mnE/t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N/mnE/t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421CFC4CEF1;
	Tue, 21 Oct 2025 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761080033;
	bh=SUDf5IAQDsaFkgrIjRGGZxB3zfvR2Y8Jt8NUjoY9v/I=;
	h=Date:To:From:Subject:From;
	b=N/mnE/t54u1OviVmfxNxRDVnKk4K+Fov1yOejw8o3AmrTpJpBU7wQpOcVwhXG2W37
	 mtOqXwoyGKOiiipspiTgzAFdyOXfhRj+TtP7IJWbycebrRXJEN3m6No28TIo8GsGKB
	 2TkSk//3K3GcJihNhVSKni0viiHIj03AKqNmHCxA=
Date: Tue, 21 Oct 2025 13:53:52 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,skhawaja@google.com,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,graf@amazon.com,dmatlack@google.com,corbet@lwn.net,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch added to mm-new branch
Message-Id: <20251021205353.421CFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: allocate metadata directly from the buddy allocator
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: allocate metadata directly from the buddy allocator
Date: Mon, 20 Oct 2025 20:08:52 -0400

KHO allocates metadata for its preserved memory map using the slab
allocator via kzalloc().  This metadata is temporary and is used by the
next kernel during early boot to find preserved memory.

A problem arises when KFENCE is enabled.  kzalloc() calls can be randomly
intercepted by kfence_alloc(), which services the allocation from a
dedicated KFENCE memory pool.  This pool is allocated early in boot via
memblock.

When booting via KHO, the memblock allocator is restricted to a "scratch
area", forcing the KFENCE pool to be allocated within it.  This creates a
conflict, as the scratch area is expected to be ephemeral and
overwriteable by a subsequent kexec.  If KHO metadata is placed in this
KFENCE pool, it leads to memory corruption when the next kernel is loaded.

To fix this, modify KHO to allocate its metadata directly from the buddy
allocator instead of slab.

Link: https://lkml.kernel.org/r/20251021000852.2924827-4-pasha.tatashin@soleen.com
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h     |    3 +++
 kernel/kexec_handover.c |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/gfp.h~liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator
+++ a/include/linux/gfp.h
@@ -7,6 +7,7 @@
 #include <linux/mmzone.h>
 #include <linux/topology.h>
 #include <linux/alloc_tag.h>
+#include <linux/cleanup.h>
 #include <linux/sched.h>
 
 struct vm_area_struct;
@@ -463,4 +464,6 @@ static inline struct folio *folio_alloc_
 /* This should be paired with folio_put() rather than free_contig_range(). */
 #define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
 
+DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
+
 #endif /* __LINUX_GFP_H */
--- a/kernel/kexec_handover.c~liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator
+++ a/kernel/kexec_handover.c
@@ -142,7 +142,7 @@ static void *xa_load_or_alloc(struct xar
 	if (res)
 		return res;
 
-	void *elm __free(kfree) = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	void *elm __free(free_page) = (void *)get_zeroed_page(GFP_KERNEL);
 
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
@@ -348,9 +348,9 @@ static_assert(sizeof(struct khoser_mem_c
 static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
 					  unsigned long order)
 {
-	struct khoser_mem_chunk *chunk __free(kfree) = NULL;
+	struct khoser_mem_chunk *chunk __free(free_page) = NULL;
 
-	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	chunk = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!chunk)
 		return ERR_PTR(-ENOMEM);
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch
liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch
kho-allow-to-drive-kho-from-within-kernel.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-and-page-ranes.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
kho-move-kho-debugfs-directory-to-liveupdate.patch

