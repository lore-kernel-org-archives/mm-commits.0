Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5908326AF3
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247723; cv=none; b=qGfVDTczWJACmIe0Y6eSatmAEIFhGlGuZo9rCsJyIYILaU7CWbWZrO6WK5noG3rdccducX/TGUPg90AEPaMLedPj2ODHwP28lnpFDHmmWx9h9t9wj78Sn8NGzbdiweblxplhdOm6Ayg8P92FlCFZmdNbtIiGW2DzNfiHP1PYpKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247723; c=relaxed/simple;
	bh=NBhI+jJvAGaHnvah7BESJU4Yo1XCMivFNiml8QpKOGg=;
	h=Date:To:From:Subject:Message-Id; b=A2Kd99lXJBU4YbySTRuDsrWytsNxkXo3h6Zk0XsJX6V+9Xf3YAuP/UQ0rR1cF0B/iW29iXq++v/H1OU/8zIUZvHAyIFc3e+A8eZZMyhp4K+M6IK9IuPuz40wt6bm+ALYLUa5Xu8YWqHhHkvkYEifM2m5svh095nlOycr/W6OWgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f45ZJJ2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f45ZJJ2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D8EC4CEC2;
	Mon,  2 Sep 2024 03:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247723;
	bh=NBhI+jJvAGaHnvah7BESJU4Yo1XCMivFNiml8QpKOGg=;
	h=Date:To:From:Subject:From;
	b=f45ZJJ2IOR5D0IW2Y1ylO8htz0sVv7ESyGOU0w7WF93u/IzUp050zd/NngWRyBu7x
	 jZgH2w5W14mziMnlKGW+LkcbPF7MyrAfOeykCoXlr7EEQfV48TJ+5UvRaDv/nOyDS2
	 J+a4MlxUy1486NT/RQaIwo/f5eim2QRodsHDEtVQ=
Date: Sun, 01 Sep 2024 20:28:42 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-change-the-addition-of-totalcma_pages-in-the-cma_init_reserved_mem.patch removed from -mm tree
Message-Id: <20240902032843.30D8EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: change the addition of totalcma_pages in the cma_init_reserved_mem
has been removed from the -mm tree.  Its filename was
     mm-cma-change-the-addition-of-totalcma_pages-in-the-cma_init_reserved_mem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/cma: change the addition of totalcma_pages in the cma_init_reserved_mem
Date: Mon, 29 Jul 2024 16:04:31 +0800

Replace the unnecessary division calculation with cma->count when update
the value of totalcma_pages.

Link: https://lkml.kernel.org/r/20240729080431.70916-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-change-the-addition-of-totalcma_pages-in-the-cma_init_reserved_mem
+++ a/mm/cma.c
@@ -202,7 +202,7 @@ int __init cma_init_reserved_mem(phys_ad
 	cma->order_per_bit = order_per_bit;
 	*res_cma = cma;
 	cma_area_count++;
-	totalcma_pages += (size / PAGE_SIZE);
+	totalcma_pages += cma->count;
 
 	return 0;
 }
_

Patches currently in -mm which might be from gehao@kylinos.cn are


