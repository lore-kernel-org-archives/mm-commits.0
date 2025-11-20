Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B33322A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 00:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763598997; cv=none; b=jAij+aqOU2ALexAbuGnfEptEmh0TZYZmAqd/BsigRhTThNOhBbxEFC2qwr4qu8ZqugQ3yQiQeN0BoUxsLujy+2f7fZCLpz9rjdn+FzGIhGJDD8XPDbK4yVRzkXWB8sQ8TO4CL/m5xdoAA16MQ4nxA6ZciUp4iezSzWWKWJnd3JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763598997; c=relaxed/simple;
	bh=qILq73EbDkBxwI5D3lgKY3ZjyBWRXVY/5yvlTuI1lhM=;
	h=Date:To:From:Subject:Message-Id; b=lmtgyyRM6fKhmV2pPDMkXZOev+B386WBcDLCKEceWsMnLn7GusBqAxrQNFnt5pxGYE6ArbpNHkh81P9i6VJq83FCQ/G7z8zUP3Dw/b6ixvvK8yMWVkcd88YRcp1NsATMulbUU9k7e9mwZ6ylVSWhwXUOFAwAiJfE39NuX0brDjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jxiJh5aE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jxiJh5aE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AB2C4CEF5;
	Thu, 20 Nov 2025 00:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763598997;
	bh=qILq73EbDkBxwI5D3lgKY3ZjyBWRXVY/5yvlTuI1lhM=;
	h=Date:To:From:Subject:From;
	b=jxiJh5aEBZ4pjpreG9lyNuGvt7nov6jOEb+q4yGqFjn2Kuc+VGYU0wdCeeb2Nq/dC
	 05WCEtT5zQbJJABJ7eqoexNvyA78re3J63ViX19/p4QDnxbeUbtwQx+3CgHzoKBmjy
	 1FxniTuJNawQ66G77kovx2z7YWowvOvFgSFkNnME=
Date: Wed, 19 Nov 2025 16:36:36 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch removed from -mm tree
Message-Id: <20251120003637.41AB2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: warn on invalid vmalloc gfp flags
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: warn on invalid vmalloc gfp flags
Date: Mon, 17 Nov 2025 09:35:27 -0800

Patch series "make vmalloc gfp flags usage more apparent", v3.

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

Link: https://lkml.kernel.org/r/20251117173530.43293-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20251117173530.43293-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
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
+ * GFP_KERNEL_ACCOUNT.
+ */
+#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
+				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
+				GFP_USER)
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

mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

