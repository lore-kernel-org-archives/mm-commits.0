Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EADD8821
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 01:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302353; cv=none; b=pHdpOeMgc4gt/kH4CJ/Mi+Jks52MZ9hPN8VjHWZXkXMilyv+2y4turj4xFHBopJnVFM/PTTjD2mS6jkt39FyMpFqN4xAFzqHHvQjgXTEijwf5KjbxXzZW2ynb8X1d1co8vCQGoF9PaxQJciiV4+b752QCrp6H+v+HTzgyWe8EFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302353; c=relaxed/simple;
	bh=FI/tDxnusXOBhWtNy4x/QHROV+2oJqUTbxO70aWjhvM=;
	h=Date:To:From:Subject:Message-Id; b=sXvSXFszc/ZRH1ZydbQg+1K0x+uewPGbXaPRkajP8xkyRlLaSV3tHerVnVkdivlTO/D5/UdNYlx4Zuw6rxzJOLYv/GkVpdaJuyaKoVda1a9xbfzSjf5b6ljm5a/69IuOkT5Un5tztXmxdE0tHCQWbE4UsTPHSDR5tBi3yGpXHJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ijVyUVcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ijVyUVcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476F0C32786;
	Tue, 30 Jul 2024 01:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722302353;
	bh=FI/tDxnusXOBhWtNy4x/QHROV+2oJqUTbxO70aWjhvM=;
	h=Date:To:From:Subject:From;
	b=ijVyUVcWYYhnP4LQJpCTcHgxhxGVtgp81G8/iGPNZ60QkKwShLKCUC+MyhIpwMwqS
	 Xe/0hXjgZ2yc15LvOCfrUWslXt22XocJgvYDhhMemCorVwxBHKdlb6+QdBhk+mR1Qr
	 2IzdFxXEZVlCKwDU1aQ1iJfaIrS2Jyt/3X3wHpTU=
Date: Mon, 29 Jul 2024 18:19:12 -0700
To: mm-commits@vger.kernel.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-change-the-addition-of-totalcma_pages-in-the-cma_init_reserved_mem.patch added to mm-unstable branch
Message-Id: <20240730011913.476F0C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: change the addition of totalcma_pages in the cma_init_reserved_mem
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-change-the-addition-of-totalcma_pages-in-the-cma_init_reserved_mem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-change-the-addition-of-totalcma_pages-in-the-cma_init_reserved_mem.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/cma: change the addition of totalcma_pages in the cma_init_reserved_mem
Date: Mon, 29 Jul 2024 16:04:31 +0800

Replace the unnecessary division calculation with cma->count when update
the value of totalcma_pages.

Link: https://lkml.kernel.org/r/20240729080431.70916-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <gehao@kylinos.cn>
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

mm-cma-change-the-addition-of-totalcma_pages-in-the-cma_init_reserved_mem.patch

