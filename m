Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C2F220687
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343128; cv=none; b=gYNxVUhbodtte43lVaUPEupTZcgvhqAYa10w5LTPzvEPXLqYVXZnkT8wziiu9MFBRETN0WGxYkqS7WbDp866HTcLIM//DLuGs4d0J1/7pTDxce6dmuGig7DeamH1sSSz+H7WO3hN8pM+KUXWofVnQqp/3Nq2gnjE5IrbZHgnpXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343128; c=relaxed/simple;
	bh=yt0y3eU9XyLguLB9RSDXtM8NvB+BrCzqg2UijQ+nKmE=;
	h=Date:To:From:Subject:Message-Id; b=dvckaKhU+M7cd+P/xejuT0ZRjwDPULhGccRGolM4su5mJDVcnRA1LMR7OARE3FGnUosvLX58Sw0np4+l/8Z1ZCAe5+s9hhXuUxEquwnDojfy+pf3cdwEx+WqCtZ8QTnKgoKdWDqIJWHj4gwlm5vSXhBeEkh1mW7dItFfVg09+HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rqR9sH2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rqR9sH2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68288C4CEF5;
	Mon, 17 Nov 2025 01:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343128;
	bh=yt0y3eU9XyLguLB9RSDXtM8NvB+BrCzqg2UijQ+nKmE=;
	h=Date:To:From:Subject:From;
	b=rqR9sH2aX+zgR3Tr3vrNtnFLdmEK8atm/uP0yO+ZAXCgyiaNvaA0POXcqwIUfiKQy
	 cHIvQ+CPP+XzNIk7GW0WExt5bAvvZLmeaqCw0Q9VvEvpojd1vRnLUOTIuo/XW3wNUB
	 wlQYokRuJPx/MI5QWcjBdDvzwghVQzNwQgVSo1qQ=
Date: Sun, 16 Nov 2025 17:32:07 -0800
To: mm-commits@vger.kernel.org,mhocko@kernel.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-update-__vmalloc_node_noprof-documentation.patch removed from -mm tree
Message-Id: <20251117013208.68288C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: update __vmalloc_node_noprof() documentation
has been removed from the -mm tree.  Its filename was
     vmalloc-update-__vmalloc_node_noprof-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: update __vmalloc_node_noprof() documentation
Date: Mon, 13 Oct 2025 19:42:22 +0200

The kernel-doc for __vmalloc_node_noprof() incorrectly states that
__GFP_NOFAIL reclaim modifier is not supported.  In fact it has been
supported since commit 9376130c390a ("mm/vmalloc: add support for
__GFP_NOFAIL").

To avoid duplication and future drift, point this helper's doc to
__vmalloc_node_range_noprof() for details and the full description.

Link: https://lkml.kernel.org/r/20251013174222.90123-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~vmalloc-update-__vmalloc_node_noprof-documentation
+++ a/mm/vmalloc.c
@@ -4034,11 +4034,8 @@ fail:
  * Allocate enough pages to cover @size from the page level allocator with
  * @gfp_mask flags.  Map them into contiguous kernel virtual space.
  *
- * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
- * and __GFP_NOFAIL are not supported
- *
- * Any use of gfp flags outside of GFP_KERNEL should be consulted
- * with mm people.
+ * Semantics of @gfp_mask(including reclaim/retry modifiers such as
+ * __GFP_NOFAIL) are the same as in __vmalloc_node_range_noprof().
  *
  * Return: pointer to the allocated memory or %NULL on error
  */
_

Patches currently in -mm which might be from urezki@gmail.com are


