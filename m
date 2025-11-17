Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AB420B212
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343202; cv=none; b=p0PUNmMkQaQY6L4MDxxyFtlQ6FCu8Pc2o13LyDt3cMSzBBEkzBeE73thkMv34m3HOXY65iuTHEIPfXcHvV8jsMU3gVCGBbqnIQT12xJfrnaApseuaeI0uykZCit4N7DC6VggjB3/BttOWr3H1CizkeM7NeQu9je4aCcDFboEcNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343202; c=relaxed/simple;
	bh=0iqGmYYSIfNFd7xrsQ9wAIicpT9to5o1Bj2+9XwhIpA=;
	h=Date:To:From:Subject:Message-Id; b=tRhZsstAk8NJi6OmM3gtAwvdlusrpVtopxGYf1j50qvKW51xqK5s18J8R9rmnqRfEv+OJ6EmPrl1ZN/E5dBCyP2jZJ8n8coDsgJAaBvSSm3AhOtxc++QdFFS/2xRhIMuI/hytOd4NvxJXHwlNzpONqUKknZYZ6r7dffPG6+Ymqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZPuUgVOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZPuUgVOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584E2C4CEF1;
	Mon, 17 Nov 2025 01:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343202;
	bh=0iqGmYYSIfNFd7xrsQ9wAIicpT9to5o1Bj2+9XwhIpA=;
	h=Date:To:From:Subject:From;
	b=ZPuUgVOG/M5DeB4u0+hjmIrsS0BNZ+US3TAJuAk8uz9S3xBhJoCEtl5KZ5lhfUEbd
	 1Kh5q9qSsstb0BsXz9THwxhPFCE3MNKSyCby2EJ/xZ2e7G+7zeyD1EXj10COMw7SNa
	 IsfdFPkl/0+f4HsWMqRbrQhgvJp51MJEx9wOWdy8=
Date: Sun, 16 Nov 2025 17:33:21 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,sfr@canb.auug.org.au,bhe@redhat.com,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-separate-gfp_mask-adjunctive-parentheses-in-__vmalloc_node_noprof-kernel-doc-comment.patch removed from -mm tree
Message-Id: <20251117013322.584E2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: separate gfp_mask adjunctive parentheses in __vmalloc_node_noprof() kernel-doc comment
has been removed from the -mm tree.  Its filename was
     vmalloc-separate-gfp_mask-adjunctive-parentheses-in-__vmalloc_node_noprof-kernel-doc-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: vmalloc: separate gfp_mask adjunctive parentheses in __vmalloc_node_noprof() kernel-doc comment
Date: Mon, 20 Oct 2025 11:49:33 +0700

Sphinx reports htmldocs warning on __vmalloc_node() comment:

Documentation/core-api/mm-api:52: ./mm/vmalloc.c:4036: WARNING: Inline strong start-string without end-string. [docutils]

Fix it by separating adjunctive parentheses from preceding gfp_mask
formatting markup.

Link: https://lkml.kernel.org/r/20251020044933.15222-1-bagasdotme@gmail.com
Fixes: 32904ba6f5ef ("vmalloc: update __vmalloc_node_noprof() documentation")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20251020134902.3a11107e@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~vmalloc-separate-gfp_mask-adjunctive-parentheses-in-__vmalloc_node_noprof-kernel-doc-comment
+++ a/mm/vmalloc.c
@@ -4034,7 +4034,7 @@ fail:
  * Allocate enough pages to cover @size from the page level allocator with
  * @gfp_mask flags.  Map them into contiguous kernel virtual space.
  *
- * Semantics of @gfp_mask(including reclaim/retry modifiers such as
+ * Semantics of @gfp_mask (including reclaim/retry modifiers such as
  * __GFP_NOFAIL) are the same as in __vmalloc_node_range_noprof().
  *
  * Return: pointer to the allocated memory or %NULL on error
_

Patches currently in -mm which might be from bagasdotme@gmail.com are


