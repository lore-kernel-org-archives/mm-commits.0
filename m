Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F1524676C
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 21:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759873005; cv=none; b=DdqT3N4zX1ojnvzZfykXzePSAu2XAocMuYamWLI8tCQNjefH6IZQJEMtyiSfk16Ju+GMdjODD6t+O7sFjX1gElw28AIuV9/qmIjP6YCacG6HCdVCvNbPTU0//bZVX40OG9lLGecJuI9Pn0qek/hepTpmpHc7sWXEeWeY+oup4ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759873005; c=relaxed/simple;
	bh=s+1BiNXhhjhbCr1GeOs98pdvV0/OCgy1MG6SH8UWhss=;
	h=Date:To:From:Subject:Message-Id; b=jHeepy7eMCrb6lACbFBhqhVngBqLTMKGYLVXnZ6mnu88XJLX67+0g78iVqPwXYkZfdDRfodeGqqJlfLxYtlH5kzM6hEulnCQx6OvEYCLOLnuWwSpoRixgI6nHgF7pWBvsYzGIMKikKRo9nfEE4pUzD/h/xE1GXjjWP7Z/E4AbSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xaRU5VdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xaRU5VdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5373BC4CEF1;
	Tue,  7 Oct 2025 21:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759873005;
	bh=s+1BiNXhhjhbCr1GeOs98pdvV0/OCgy1MG6SH8UWhss=;
	h=Date:To:From:Subject:From;
	b=xaRU5VdD44ty3Yx9edCq4WkbasAAaCC+u5zx5MUwJhAjQsTXl/eCJpJRkRtA8xrOz
	 jPXeJIV5eUKeaxAdnnX+w/OagdEsbaRTQZzXFauDv5LM2Zh4EY5Kry1ySo/QjA6YVY
	 eq14aMTqpUKUTF63xhnWxeaP+drw4RijDoVxFUFg=
Date: Tue, 07 Oct 2025 14:36:44 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-update-__vmalloc_node_range-documentation.patch added to mm-new branch
Message-Id: <20251007213645.5373BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: update __vmalloc_node_range() documentation
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-update-__vmalloc_node_range-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-update-__vmalloc_node_range-documentation.patch

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

