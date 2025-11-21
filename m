Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7251862
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763743430; cv=none; b=emGoICdnHa4araRw2ylCN6y+BuwHMxrvEgPZPw2pnkbdTAiLlFsAsFH/bdVWmGy6x7q2NZz0CYwOtMSxTlmsHgEQGHHY9FBdSQ9aZlThFu4YXGb7HoNYYZLFLiusFEl04lqwZXin97It8dmRd1Gm4vSgmwJ+YXzKFIqkiFGS6PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763743430; c=relaxed/simple;
	bh=YXg6t1rJg8u49FLsWPCSOHidWpXrgxhmxecBMqNGfyk=;
	h=Date:To:From:Subject:Message-Id; b=rIoIIerz6aiUlFtEe9Lj21tw/0J/GAuWnO4H0qcJB2A30ULCbDSz2WlO/uauEBhOx7PTrtdtbaoIoHF5EmnDxqFoqfG0XRF4g51pT720pXtwOMRPPjpUF/gU58IDfm2/vZ+CH5IeS2p2jcFzvdzCvm32t7PaXQzO7hSvmnAbN8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Av3U01SR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Av3U01SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15192C116C6;
	Fri, 21 Nov 2025 16:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763743428;
	bh=YXg6t1rJg8u49FLsWPCSOHidWpXrgxhmxecBMqNGfyk=;
	h=Date:To:From:Subject:From;
	b=Av3U01SRrOLluQ2gx5IUSL8tUBraa64CeASCryKWoLFjnywgN+53pZbyUPnLhz278
	 uBCZDw/7xItLdbQVYI/gG/kf+iupgoMDqjRfEBqnFdgF6xXNBTirfDS05T7f0nZlFv
	 VlUZv7IIC7rf8y5kSTvl6fCJ9SAI7HOsWt6indOg=
Date: Fri, 21 Nov 2025 08:43:47 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,sj@kernel.org,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch added to mm-unstable branch
Message-Id: <20251121164348.15192C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: warn on invalid vmalloc gfp flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Fri, 21 Nov 2025 01:44:02 -0800

Patch series "make vmalloc gfp flags usage more apparent", v4.

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

Link: https://lkml.kernel.org/r/20251121094405.40628-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20251121094405.40628-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags
+++ a/mm/vmalloc.c
@@ -3911,6 +3911,28 @@ fail:
 	return NULL;
 }
 
+/*
+ * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
+ * This gfp lists all flags currently passed through vmalloc. Currently,
+ * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
+ * and BPF also use GFP_USER. Additionally, various users pass
+ * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
+ */
+#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
+				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
+				GFP_USER | __GFP_NOLOCKDEP)
+
+static gfp_t vmalloc_fix_flags(gfp_t flags)
+{
+	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
+
+	flags &= GFP_VMALLOC_SUPPORTED;
+	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+		  invalid_mask, &invalid_mask, flags, &flags);
+	return flags;
+}
+
 /**
  * __vmalloc_node_range - allocate virtually contiguous memory
  * @size:		  allocation size
@@ -4092,6 +4114,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof)
 
 void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
 {
+	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
@@ -4131,6 +4155,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
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

mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

