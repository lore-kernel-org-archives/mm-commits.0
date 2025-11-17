Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B017A1F9F47
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343090; cv=none; b=cpfx4QV7tDVqd1Us3Ka1h41bA19wYRhnybVM8SXJwrh1lKu9BdksN/5Dai7IF4jD5aCQdtJOAaKQTCoMGp4/fqHWS9FMIQnqrzGU0DXfzM3jL3NPc6Zefo8K67kb5e4PfiwS+APCrGe8JF/tSmXU1hxVRjsCvI6VkB0cjLKXTjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343090; c=relaxed/simple;
	bh=uinUXT+zKCsL6Bc7ne+BjNTKFvi9SgT1uz154TnYF1E=;
	h=Date:To:From:Subject:Message-Id; b=Nfm/A9VHAEUn9IkC3XSgPMwg9z/F4uHdfY9dJpCPtzUPzEhZmhk7knmJ/dzouixgp4+iB0TrFFxtnwIl267uhhN/lM14z/OVdsy6kygFZ3RoyCB/HvL+rRgCcN9sZ2Sv4j9mUsHMOMbAvHRfgauYXybHwiIzdS8Ddyb5PykPZDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nF47cG42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nF47cG42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AB3C4CEF5;
	Mon, 17 Nov 2025 01:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343090;
	bh=uinUXT+zKCsL6Bc7ne+BjNTKFvi9SgT1uz154TnYF1E=;
	h=Date:To:From:Subject:From;
	b=nF47cG42qf4zmP0Ra2qS0HZ2ox3E7PAuv/4M1WAdw7qdL+284kchAjjtFfIMnyUJn
	 thXyhJTAIe8OI6viCXbFeDtumWR6hJyb5MlhOYHxht6jxfOKzTb5m9bPJZbpepgYVO
	 orJx5RNo/MfLD5OYSGBnL+Ijg/CrJt6U7PjShVb8=
Date: Sun, 16 Nov 2025 17:31:30 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kvmalloc-add-non-blocking-support-for-vmalloc.patch removed from -mm tree
Message-Id: <20251117013130.84AB3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kvmalloc: add non-blocking support for vmalloc
has been removed from the -mm tree.  Its filename was
     mm-kvmalloc-add-non-blocking-support-for-vmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: kvmalloc: add non-blocking support for vmalloc
Date: Tue, 7 Oct 2025 14:20:35 +0200

Extend __kvmalloc_node_noprof() to handle non-blocking GFP flags
(GFP_NOWAIT and GFP_ATOMIC).  Previously such flags were rejected,
returning NULL.  With this change:

- kvmalloc() can fall back to vmalloc() if non-blocking contexts;
- for non-blocking allocations the VM_ALLOW_HUGE_VMAP option is
  disabled, since the huge mapping path still contains might_sleep();
- documentation update to reflect that GFP_NOWAIT and GFP_ATOMIC
  are now supported.

Link: https://lkml.kernel.org/r/20251007122035.56347-11-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-kvmalloc-add-non-blocking-support-for-vmalloc
+++ a/mm/slub.c
@@ -7090,7 +7090,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t fl
  * Uses kmalloc to get the memory but if the allocation fails then falls back
  * to the vmalloc allocator. Use kvfree for freeing the memory.
  *
- * GFP_NOWAIT and GFP_ATOMIC are not supported, neither is the __GFP_NORETRY modifier.
+ * GFP_NOWAIT and GFP_ATOMIC are supported, the __GFP_NORETRY modifier is not.
  * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
  * preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
@@ -7099,6 +7099,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t fl
 void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
 			     gfp_t flags, int node)
 {
+	bool allow_block;
 	void *ret;
 
 	/*
@@ -7111,10 +7112,6 @@ void *__kvmalloc_node_noprof(DECL_BUCKET
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
-	/* non-sleeping allocations are not supported by vmalloc */
-	if (!gfpflags_allow_blocking(flags))
-		return NULL;
-
 	/* Don't even allow crazy sizes */
 	if (unlikely(size > INT_MAX)) {
 		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
@@ -7122,13 +7119,23 @@ void *__kvmalloc_node_noprof(DECL_BUCKET
 	}
 
 	/*
+	 * For non-blocking the VM_ALLOW_HUGE_VMAP is not used
+	 * because the huge-mapping path in vmalloc contains at
+	 * least one might_sleep() call.
+	 *
+	 * TODO: Revise huge-mapping path to support non-blocking
+	 * flags.
+	 */
+	allow_block = gfpflags_allow_blocking(flags);
+
+	/*
 	 * kvmalloc() can always use VM_ALLOW_HUGE_VMAP,
 	 * since the callers already cannot assume anything
 	 * about the resulting pointer, and cannot play
 	 * protection games.
 	 */
 	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
-			flags, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
+			flags, PAGE_KERNEL, allow_block ? VM_ALLOW_HUGE_VMAP:0,
 			node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(__kvmalloc_node_noprof);
_

Patches currently in -mm which might be from urezki@gmail.com are


