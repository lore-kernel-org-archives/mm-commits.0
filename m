Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CCB2DBF78
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280960; cv=none; b=l7gfG4u0YqXcdD2Dbdu+zRrsnaeYcHBR5vPtvcbzpY1mbFXypJT4o013Aa8fxPqhw9c3W3El0r/zsSIcEbO4w3fnERzWaDr6sfde0NTeERrFkXKe1UpnVxMchwHFSnXamPJJr0AGQNlHLITxOBivAbPGAsCQc0QHuFq1bOg4urY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280960; c=relaxed/simple;
	bh=U9/zufZgxshAEPfqgs5IzC+EPlEP3PytBO/Kmyemztw=;
	h=Date:To:From:Subject:Message-Id; b=mid2Obt7UMkaySK6PgUrS3gh8n4wQ/ZmVloLHVos/HXwAw4CEy3PNuJ8l7HHGvlQekVOdZzN94FmEMNI3vkmWcDYFTmqW4crRZJd6HY74/2jyDE01GSxzRCIzP1WTqTjNSR5GHt0niIsckpUX3jT7pLyhQ7qyBeFAVsxsZHVH/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fO7PFpTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fO7PFpTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301DDC116C6;
	Tue, 13 Jan 2026 05:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280960;
	bh=U9/zufZgxshAEPfqgs5IzC+EPlEP3PytBO/Kmyemztw=;
	h=Date:To:From:Subject:From;
	b=fO7PFpTPycgHjpGMPDYcdDGz5Of9nRwU/xv23jHZ3Eczj5JCrU6szeUYsQyr/eSqZ
	 9BE0PoZNO4DxN708pGjnzapqi+hnR3XOAnrzDLaUPNhOKzRepGJiKcVOpSj+viMAlw
	 k75+2uZUT+56fhX2GyrQxHueb9d7/aPwYqmPIwZU=
Date: Mon, 12 Jan 2026 21:09:19 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name.patch removed from -mm tree
Message-Id: <20260113050920.301DDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: fix up vrealloc_node_align() kernel-doc macro name
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: mm: vmalloc: fix up vrealloc_node_align() kernel-doc macro name
Date: Fri, 19 Dec 2025 08:40:06 +0700

Sphinx reports kernel-doc warning:

WARNING: ./mm/vmalloc.c:4284 expecting prototype for vrealloc_node_align_noprof(). Prototype was for vrealloc_node_align() instead

Fix the macro name in vrealloc_node_align_noprof() kernel-doc comment.

Link: https://lkml.kernel.org/r/20251219014006.16328-5-bagasdotme@gmail.com
Fixes: 4c5d3365882d ("mm/vmalloc: allow to set node and align in vrealloc")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name
+++ a/mm/vmalloc.c
@@ -4248,7 +4248,7 @@ void *vzalloc_node_noprof(unsigned long
 EXPORT_SYMBOL(vzalloc_node_noprof);
 
 /**
- * vrealloc_node_align_noprof - reallocate virtually contiguous memory; contents
+ * vrealloc_node_align - reallocate virtually contiguous memory; contents
  * remain unchanged
  * @p: object to reallocate memory for
  * @size: the size to reallocate
_

Patches currently in -mm which might be from bagasdotme@gmail.com are


