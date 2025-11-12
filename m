Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D1E29AB1D
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 22:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762986035; cv=none; b=GSrV/ocFC+wiXouNn3Nrmt/aE9ujzksnWaMdYp6Pa7cTJK0ENFmz/eb5XzwfZMfLXe/k9e8csavmQAMittIXNOplZUwUDr5C2kxCxmSjpY0qF35qSjcM9ZyeLT2e0ErcCrcs6Z/0D2p6mZtA8eUvo4Z3yei+idoHCkLlC2Cz57s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762986035; c=relaxed/simple;
	bh=/Qj6COiAxYKUptUR0SY4cK4e18QXLkL2EEFL3vBVHqQ=;
	h=Date:To:From:Subject:Message-Id; b=prVqx9QNtFoqTLflr5dC2l6vWvsMvYyBH6j7sY/RO1nYtEoNlvoJmHc6wrXR6t29nK5P1xLYzleJ3iEvrNmTbs0uAnwKzU5Jj2xYddTShfrgpBte9fvZ58SihJmjxxfjc7rmMjnmnmpiJS5bhtKvvHO8nWGi2b+ENeeiz1myY/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d54pcAGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d54pcAGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B511FC19422;
	Wed, 12 Nov 2025 22:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762986034;
	bh=/Qj6COiAxYKUptUR0SY4cK4e18QXLkL2EEFL3vBVHqQ=;
	h=Date:To:From:Subject:From;
	b=d54pcAGuiDOpyvDl3uZSumVNrpPAUQLqmkSFQDiHBE0sY6ZuJl2Km4D9jwidRirK2
	 3ANcq1ls60Z9vwzGjOcKLrAP6AbmPmz8gctsBpeLqtUvRrcKYICW8BNOSOKtPOmyo8
	 TYYbLm5U7SyQIWWqraNXsvWcZqehgIpAUsYIUmj8=
Date: Wed, 12 Nov 2025 14:20:34 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch added to mm-new branch
Message-Id: <20251112222034.B511FC19422@smtp.kernel.org>
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
Date: Wed, 12 Nov 2025 10:58:30 -0800

Patch series "make vmalloc gfp flags usage more apparent", v2.

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

Link: https://lkml.kernel.org/r/20251112185834.32487-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20251112185834.32487-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags
+++ a/mm/vmalloc.c
@@ -3911,6 +3911,26 @@ fail:
 	return NULL;
 }
 
+/*
+ * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
+ * This gfp lists all flags currently passed through vmalloc. Currently,
+ * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
+ * and BPF also use GFP_USER, which is GFP_KERNEL | __GFP_HARDWALL.
+ */
+#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
+				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_HARDWALL)
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
@@ -4092,6 +4112,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof)
 
 void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
 {
+	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
@@ -4131,6 +4153,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
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
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

