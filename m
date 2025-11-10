Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738171C695
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 19:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762801908; cv=none; b=CS2CI3HhsSaKvXi3aD9kGOV6a8LcLwJbj/NFOXTSpLtLbQ3sWkf/cV6/GAi27gLgGS4wAB5V2nEVDZpbq0cjV34qO12ucmtN1w7G242A4C8XGT2145z1odPZX31LdgpF61Tn8DcgwXCog9pJnu5bJ389Dus9CnFIW16Xtec0xAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762801908; c=relaxed/simple;
	bh=wF/H4HNs3fjIyDUN9zPt7XrbBggcgQ0gwi/tQUj5w9s=;
	h=Date:To:From:Subject:Message-Id; b=CbYnM7HVIuzVK5/lodzWVvU2kMUKd99FVuYin3yGnqQfwSerkqgWtuo1XRnFckEBWfdKnfWUhmF8dZQhDUMM9pABcEePD4AahIcXhh0ca56BJriR1olWtD1rLNq2NTdJMfc9KbQLvLEjAT5MnVQkYqkLfKifq+sP2IYaUihTw08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VSwIiWfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VSwIiWfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2813DC2BC86;
	Mon, 10 Nov 2025 19:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762801908;
	bh=wF/H4HNs3fjIyDUN9zPt7XrbBggcgQ0gwi/tQUj5w9s=;
	h=Date:To:From:Subject:From;
	b=VSwIiWfZpM2vguHmur+g9FWukAhvM9TiU+KovBekUalrXpmOtgkmbG6U3gReMlAUP
	 wMvj8HER0imMRferYEv+spRoSWiY6aY1Rl+0NbHqtpvdstUfg5r7YomkZAB//zIvHR
	 dgqc1eCINb8RpK79Cj8Qwkj7AQkCUX10trZAXf7E=
Date: Mon, 10 Nov 2025 11:11:47 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch added to mm-new branch
Message-Id: <20251110191148.2813DC2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: warn on invalid vmalloc gfp flags
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: warn on invalid vmalloc gfp flags
Date: Mon, 10 Nov 2025 08:04:54 -0800

Patch series "make vmalloc gfp flags usage more apparent".

We should do a better job at enforcing gfp flags for vmalloc.  Right now,
we have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
supported flags.  If a caller were to pass in an unsupported flag, we may
BUG, silently clear it, or completely ignore it.

If we are more proactive about enforcing gfp flags, we can making sure
callers know when they may be asking for unsupported behavior.

This patchset lets vmalloc control the incoming gfp flags, and cleans up
some hard to read gfp code.


This patch (of 4):

Vmalloc explicitly supports a list of flags, but we never enforce them. 
vmalloc has been trying to handle unsupported flags by clearing and
setting flags wherever necessary.  This is messy and makes the code harder
to understand, when we could simply check for a supported input
immediately instead.

Define a helper mask and function telling callers they have passed in
invalid flags, and clear those unsupported vmalloc flags.

Link: https://lkml.kernel.org/r/20251110160457.61791-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20251110160457.61791-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags
+++ a/mm/vmalloc.c
@@ -3911,6 +3911,24 @@ fail:
 	return NULL;
 }
 
+/*
+ * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
+ * This gfp lists all flags currently passed through vmalloc. Currently,
+ * __GFP_ZERO is used by BFP and __GFP_NORETRY is used by percpu.
+ */
+#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
+				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY)
+
+static gfp_t vmalloc_fix_flags(gfp_t flags)
+{
+	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
+
+	flags &= GFP_VMALLOC_SUPPORTED;
+	WARN(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+			invalid_mask, &invalid_mask, flags, &flags);
+	return flags;
+}
+
 /**
  * __vmalloc_node_range - allocate virtually contiguous memory
  * @size:		  allocation size
@@ -4092,6 +4110,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof)
 
 void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
 {
+	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
@@ -4131,6 +4151,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
  */
 void *vmalloc_huge_node_noprof(unsigned long size, gfp_t gfp_mask, int node)
 {
+	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
 					   gfp_mask, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
 					   node, __builtin_return_address(0));
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-vmalloc-request-large-order-pages-from-buddy-allocator.patch
mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

