Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D271FE46D
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343089; cv=none; b=lu4F3rrVU6YTNj4TA0EH0mFitPn/8hsvQoSak1SVTJyFy1ffh8ZN59WY9Wvw4AJ11ZRBR+NlkCKj9n2XSDMDR1GGGdiUr3cMw2YQBVT6fkr4C7FF2uQzeeNaZz54ZkHSkyC2J04pciAe1aYsxrMqxC3kCCRTaIYT6H++rZIOjJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343089; c=relaxed/simple;
	bh=5pM7qnUQjRtBXBdTWOSiCw0abwdk2Puu0NZWXC2n7Ic=;
	h=Date:To:From:Subject:Message-Id; b=jU+eoHPPh9ZYvoFowrtOboU7ZI28hLMUmhXLfXAP0Pu5ynmoGB87AecHMLnxjHwbcbcKAZObRstlAdW2sdjYOjJMiBv+oGhpjTZ+c9iRKk3LYW7sSCAhmETVMDSmjkATcYs/ASn51GEw1BEXh68I1i0BxEm+8f/F1PMoDQjti1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sw3+5e9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sw3+5e9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCDBC116D0;
	Mon, 17 Nov 2025 01:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343089;
	bh=5pM7qnUQjRtBXBdTWOSiCw0abwdk2Puu0NZWXC2n7Ic=;
	h=Date:To:From:Subject:From;
	b=sw3+5e9Sfp/xHnOSfSYWo4dTqySAq5PiHQN9zL2GX2Fq79bcsHr2w7jOSEMeHAuFe
	 QkFBJzQupojqK8p+YDIIyMOqlMLNnieWZ57wDWGCck0h59vFz5kYlofCuYGC6IIjti
	 eyIF4chFJq27hA7H9xCI6ZxTysK4DGvunBEDRKr8=
Date: Sun, 16 Nov 2025 17:31:28 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-update-__vmalloc_node_range-documentation.patch removed from -mm tree
Message-Id: <20251117013129.4DCDBC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: update __vmalloc_node_range() documentation
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-update-__vmalloc_node_range-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: update __vmalloc_node_range() documentation
Date: Tue, 7 Oct 2025 14:20:34 +0200

__vmalloc() now supports non-blocking flags such as GFP_ATOMIC and
GFP_NOWAIT.  Update the documentation accordingly.

Link: https://lkml.kernel.org/r/20251007122035.56347-10-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-update-__vmalloc_node_range-documentation
+++ a/mm/vmalloc.c
@@ -3881,19 +3881,20 @@ fail:
  * @caller:		  caller's return address
  *
  * Allocate enough pages to cover @size from the page level
- * allocator with @gfp_mask flags. Please note that the full set of gfp
- * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
- * supported.
- * Zone modifiers are not supported. From the reclaim modifiers
- * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
- * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
- * __GFP_RETRY_MAYFAIL are not supported).
+ * allocator with @gfp_mask flags and map them into contiguous
+ * virtual range with protection @prot.
  *
- * __GFP_NOWARN can be used to suppress failures messages.
+ * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
+ * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
+ * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
+ * by __vmalloc().
  *
- * Map them into contiguous kernel virtual space, using a pagetable
- * protection of @prot.
+ * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
+ * and %__GFP_RETRY_MAYFAIL are not supported.
  *
+ * %__GFP_NOWARN can be used to suppress failure messages.
+ *
+ * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
 void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
_

Patches currently in -mm which might be from urezki@gmail.com are


