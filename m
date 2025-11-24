Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F69132F74B
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025859; cv=none; b=cDId45vmJfwqKT9cslWax+GOiKMgJdWQY9gzZuf/uK/n0JC+sSX9nIw6OdZCQClwHq+sSvL2bWb0YWl/YcTyW70hovplDB1+iINSRxgUqm4FZ2lpKpYdykQ80nz49C9meFQeSHGTo+k1ObEy9zkcdzWd9SxMLrq/ISfmDa3RV+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025859; c=relaxed/simple;
	bh=5ZPCM8c63//A+iC656CqcXVzcY+GvPOCG+dVL1Wo3r0=;
	h=Date:To:From:Subject:Message-Id; b=ZhVgXUZa+eFbCCtaI9Vo73O2WyM+jyRUSiC6ifEd0Meu2mMC2Ln35YlznAwS4OJLgbx7QYyXl7F9QAaWig1tJ3tHnYzKYnA29cnRx8yZBq5PpEiT3xlb5GqlUjeY1Hk6Qao9trgezSJv7BvaWD3bRBwWgfasLNOMbOPKE/1SodQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FG4GSGIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FG4GSGIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD45EC4CEF1;
	Mon, 24 Nov 2025 23:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025858;
	bh=5ZPCM8c63//A+iC656CqcXVzcY+GvPOCG+dVL1Wo3r0=;
	h=Date:To:From:Subject:From;
	b=FG4GSGIfp+A3d7+JgGOyn7JxeOWN9rw7cTs2SlCQHXWelTlzaUK/bE9MkTK44Gy+V
	 eRocAW2PEntVlEyc3T8UMEskt2IyDGMxvsRkcmB3rWy0MfBQ4eaMtisqSl0p1BetPq
	 9aRp2OFd2FJdArf+vQ92j28JM+GE+PQ9v+HzmJMw=
Date: Mon, 24 Nov 2025 15:10:58 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,sj@kernel.org,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch removed from -mm tree
Message-Id: <20251124231058.AD45EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: warn on invalid vmalloc gfp flags
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


