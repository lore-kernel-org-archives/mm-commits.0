Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354A327FD72
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 20:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761080033; cv=none; b=oYi8tjJ63rrfYYvBQtKC/EBQdcKPig2AWRqlIwqZFr5PXTZ7MRGZNy+p4i8O3mkuAfWFRR7PXf16Qypo03c3ZX+ly55y0iDSojgkDBxs0hSg6HozgcNigy8hdGThIkisLBsmfNzvMe56FSAeQhcKujs0OWWND+ks0d33MBykgvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761080033; c=relaxed/simple;
	bh=8iLJ7SpADup2Qz3gPYNUF5OSltTSXqrd9m6W5nNrGV0=;
	h=Date:To:From:Subject:Message-Id; b=rypN3U9kffUN2fhW+488EzlpnzGjUqTz4AYFtgyoxD0GWWNppd1uPaYE8QSf4UQLB06MyP+wvAgPRe5JVVanzgrOa36XvtrMqPaOa8WXkQ6NEFFEDqU3NBqfyuGdoA1ElHOh3NVVcwfpaKbtGKFDXhP0x5lLJtK0Fl/kPzFTW1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eENSCQkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eENSCQkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA16DC4CEF7;
	Tue, 21 Oct 2025 20:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761080031;
	bh=8iLJ7SpADup2Qz3gPYNUF5OSltTSXqrd9m6W5nNrGV0=;
	h=Date:To:From:Subject:From;
	b=eENSCQkcrE/wwJLHmrdI1A6q4Ml2Yp/Y4ftAPdMjdEeh7F07E0QZdGHvL03QCjn6a
	 ApPYmin6KQtGcRG8mEKdbQI0voYh3Oq5cyEP+JJu8fQz2qunBhLvwPVHWKnJLzJ9qc
	 EWrzt1ENWfxu16G7LifDqwxh9p+bOjCt3RIVx5OA=
Date: Tue, 21 Oct 2025 13:53:51 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,skhawaja@google.com,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,graf@amazon.com,dmatlack@google.com,corbet@lwn.net,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch added to mm-new branch
Message-Id: <20251021205351.AA16DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: increase metadata bitmap size to PAGE_SIZE
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch

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
Subject: kho: increase metadata bitmap size to PAGE_SIZE
Date: Mon, 20 Oct 2025 20:08:51 -0400

KHO memory preservation metadata is preserved in 512 byte chunks which
requires their allocation from slab allocator.  Slabs are not safe to be
used with KHO because of kfence, and because partial slabs may lead leaks
to the next kernel.  Change the size to be PAGE_SIZE.

The kfence specifically may cause memory corruption, where it randomly
provides slab objects that can be within the scratch area.  The reason for
that is that kfence allocates its objects prior to KHO scratch is marked
as CMA region.

While this change could potentially increase metadata overhead on systems
with sparsely preserved memory, this is being mitigated by ongoing work to
reduce sparseness during preservation via 1G guest pages.  Furthermore,
this change aligns with future work on a stateless KHO, which will also
use page-sized bitmaps for its radix tree metadata.

Link: https://lkml.kernel.org/r/20251021000852.2924827-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/kernel/kexec_handover.c~liveupdate-kho-increase-metadata-bitmap-size-to-page_size
+++ a/kernel/kexec_handover.c
@@ -69,10 +69,10 @@ early_param("kho", kho_parse_enable);
  * Keep track of memory that is to be preserved across KHO.
  *
  * The serializing side uses two levels of xarrays to manage chunks of per-order
- * 512 byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order of a
- * 1TB system would fit inside a single 512 byte bitmap. For order 0 allocations
- * each bitmap will cover 16M of address space. Thus, for 16G of memory at most
- * 512K of bitmap memory will be needed for order 0.
+ * PAGE_SIZE byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order
+ * of a 8TB system would fit inside a single 4096 byte bitmap. For order 0
+ * allocations each bitmap will cover 128M of address space. Thus, for 16G of
+ * memory at most 512K of bitmap memory will be needed for order 0.
  *
  * This approach is fully incremental, as the serialization progresses folios
  * can continue be aggregated to the tracker. The final step, immediately prior
@@ -80,12 +80,14 @@ early_param("kho", kho_parse_enable);
  * successor kernel to parse.
  */
 
-#define PRESERVE_BITS (512 * 8)
+#define PRESERVE_BITS (PAGE_SIZE * 8)
 
 struct kho_mem_phys_bits {
 	DECLARE_BITMAP(preserve, PRESERVE_BITS);
 };
 
+static_assert(sizeof(struct kho_mem_phys_bits) == PAGE_SIZE);
+
 struct kho_mem_phys {
 	/*
 	 * Points to kho_mem_phys_bits, a sparse bitmap array. Each bit is sized
@@ -133,19 +135,19 @@ static struct kho_out kho_out = {
 	.finalized = false,
 };
 
-static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
+static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
 {
 	void *res = xa_load(xa, index);
 
 	if (res)
 		return res;
 
-	void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
+	void *elm __free(kfree) = kzalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
 
-	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), PAGE_SIZE)))
 		return ERR_PTR(-EINVAL);
 
 	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
@@ -218,8 +220,7 @@ static int __kho_preserve_order(struct k
 		}
 	}
 
-	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
-				sizeof(*bits));
+	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
 	if (IS_ERR(bits))
 		return PTR_ERR(bits);
 
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

