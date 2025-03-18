Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6341C700A
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274638; cv=none; b=Pbtf5mKwbz07ZOmu+JckwPU74BWLhk7QFvk8GLDK1uYSoGgfYeOocxQsVokBvWedDX0/Dn+yB7RwFpw3boYwTDMVLy0sFcnHoQQrjXwoaf23xGt5sDpsHzTfsPUx6pEKUdPGXqZmfvOQi1gAOhXHlNNJMN6acDUa07oJx0aUn3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274638; c=relaxed/simple;
	bh=TnzquSwoKGPS2YJl3ImF7p4ItfRlJzhmrNQfFwBqn2I=;
	h=Date:To:From:Subject:Message-Id; b=H4YcrY3yEoYhMy1VZYv8i+gOJHAuRUaDZKrtIIjl37VUpTpzWJ6eMDVmLxMGeIZjOXpktYgtv5dGuhAdr4P88gkSy8A/g4LrtxSxoDYcWAH8SdNEA/b80kta5TfeBAfF43PwuJyZMsbdOlvQn/smCVWQIwYfSXNXrWq0HuB339w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZtLmFhUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZtLmFhUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0131DC4CEDD;
	Tue, 18 Mar 2025 05:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274638;
	bh=TnzquSwoKGPS2YJl3ImF7p4ItfRlJzhmrNQfFwBqn2I=;
	h=Date:To:From:Subject:From;
	b=ZtLmFhUb8g/fqHrf1oVpHOpiGBFcmgP+uLRntCy4RILaB8gKp2czs7vD21wc8ZZcj
	 SvBk2x4pakHjrc0mvil91F0Br9UZF1zEWNmDHQJB+3sqvCfyE0oOHuUDNMw91G/MzN
	 TSqcXJJY5kSpI6GJE62E7Qbf+E5kg7ubZwzSyJEg=
Date: Mon, 17 Mar 2025 22:10:37 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-ptep_get-instead-of-directly-dereferencing-pte_t.patch removed from -mm tree
Message-Id: <20250318051038.0131DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use ptep_get() instead of directly dereferencing pte_t*
has been removed from the -mm tree.  Its filename was
     mm-use-ptep_get-instead-of-directly-dereferencing-pte_t.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: use ptep_get() instead of directly dereferencing pte_t*
Date: Mon, 10 Mar 2025 14:04:17 +0000

It is best practice for all pte accesses to go via the arch helpers, to
ensure non-torn values and to allow the arch to intervene where needed
(contpte for arm64 for example).  While in this case it was probably safe
to directly dereference, let's tidy it up for consistency.

Link: https://lkml.kernel.org/r/20250310140418.1737409-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-use-ptep_get-instead-of-directly-dereferencing-pte_t
+++ a/mm/migrate.c
@@ -202,7 +202,7 @@ static bool try_to_map_unused_to_zeropag
 		return false;
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(pte_present(*pvmw->pte), page);
+	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


