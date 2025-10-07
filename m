Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E829723816C
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 21:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759872991; cv=none; b=dgFguhY+l3yu/89btAk67k5KYpKZSNis5IkrPkWxXzxuBeczNGnW70wY+OcJ/f169ERDP+xGukwYjM1NoP4Rdz/AARHTHEXpGWvpoybUOrE6/gypl196WkUHyON7CjBlJwmr9uNrPZWRfDrkM28qn7Lxv4u95dsTiSzSDQ7Y09o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759872991; c=relaxed/simple;
	bh=rZYnsIAHSnYm/UlGQ3CMd1aXVeC21IE+kvelIrSLHJU=;
	h=Date:To:From:Subject:Message-Id; b=OE3S3DToYRrJkDAZ0WSVWNOBl+IG7de0hOmbiw0Y5HKTtL8qsGWkIfqCTL3CN6Qc403kKEsGHBaQ1l9IDdlZ2WIC0ZOjhBQm7UOeRXkYc9tmcJI8il59iqNXiTDpCfKitE7qnW7xKYndWpNcPlZjlEDNXb6AXGdAjiEwfyLTwII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=03Kn8cgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="03Kn8cgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90183C4CEF1;
	Tue,  7 Oct 2025 21:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759872990;
	bh=rZYnsIAHSnYm/UlGQ3CMd1aXVeC21IE+kvelIrSLHJU=;
	h=Date:To:From:Subject:From;
	b=03Kn8cgx5THtm6utRzbL6TsI80oMmKZloIf8htg+vBTuhH3AI8Q3aRhzaZpyLuNHJ
	 wrVBVO5G/VufwC+FOjLA8EBuXw0SD10F3AA+0ZzGd/BC3aXxEiIo2cETxMz0bkS2bP
	 qy+PBrQSzw0j8PbMuGwoWI8V8TSkP3sUp6Lg1HmA=
Date: Tue, 07 Oct 2025 14:36:30 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch added to mm-new branch
Message-Id: <20251007213630.90183C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()
Date: Tue, 7 Oct 2025 14:20:28 +0200

alloc_vmap_area() currently assumes that sleeping is allowed during
allocation.  This is not true for callers which pass non-blocking GFP
flags, such as GFP_ATOMIC or GFP_NOWAIT.

This patch adds logic to detect whether the given gfp_mask permits
blocking.  It avoids invoking might_sleep() or falling back to reclaim
path if blocking is not allowed.

This makes alloc_vmap_area() safer for use in non-sleeping contexts, where
previously it could hit unexpected sleeps, trigger warnings.

It is a preparation and adjustment step to later allow both GFP_ATOMIC and
GFP_NOWAIT allocations in this series.

Link: https://lkml.kernel.org/r/20251007122035.56347-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area
+++ a/mm/vmalloc.c
@@ -2017,6 +2017,7 @@ static struct vmap_area *alloc_vmap_area
 	unsigned long freed;
 	unsigned long addr;
 	unsigned int vn_id;
+	bool allow_block;
 	int purged = 0;
 	int ret;
 
@@ -2028,7 +2029,8 @@ static struct vmap_area *alloc_vmap_area
 
 	/* Only reclaim behaviour flags are relevant. */
 	gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
-	might_sleep();
+	allow_block = gfpflags_allow_blocking(gfp_mask);
+	might_sleep_if(allow_block);
 
 	/*
 	 * If a VA is obtained from a global heap(if it fails here)
@@ -2062,7 +2064,8 @@ retry:
 		 * This is not a fast path.  Check if yielding is needed. This
 		 * is the only reschedule point in the vmalloc() path.
 		 */
-		cond_resched();
+		if (allow_block)
+			cond_resched();
 	}
 
 	trace_alloc_vmap_area(addr, size, align, vstart, vend, IS_ERR_VALUE(addr));
@@ -2071,8 +2074,16 @@ retry:
 	 * If an allocation fails, the error value is
 	 * returned. Therefore trigger the overflow path.
 	 */
-	if (IS_ERR_VALUE(addr))
-		goto overflow;
+	if (IS_ERR_VALUE(addr)) {
+		if (allow_block)
+			goto overflow;
+
+		/*
+		 * We can not trigger any reclaim logic because
+		 * sleeping is not allowed, thus fail an allocation.
+		 */
+		goto out_free_va;
+	}
 
 	va->va_start = addr;
 	va->va_end = addr + size;
@@ -2122,6 +2133,7 @@ overflow:
 		pr_warn("vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx\n",
 				size, vstart, vend);
 
+out_free_va:
 	kmem_cache_free(vmap_area_cachep, va);
 	return ERR_PTR(-EBUSY);
 }
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmalloc-add-no_block_alloc_test-case.patch
lib-test_vmalloc-remove-xfail-condition-check.patch
mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch
mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch
mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch
mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch
kmsan-remove-hard-coded-gfp_kernel-flags.patch
mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch
mm-vmalloc-update-__vmalloc_node_range-documentation.patch
mm-kvmalloc-add-non-blocking-support-for-vmalloc.patch

