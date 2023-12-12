Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFA980028
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="giV24s7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB442C433C8;
	Tue, 12 Dec 2023 18:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407594;
	bh=yklaUUgeEdF8xErcrUI7d2XOd4wdItz/uel1QWUa7c8=;
	h=Date:To:From:Subject:From;
	b=giV24s7+HLhlaVZG5m+9PHMyqJOXZb4dNX4Yg53d41lqS4bUP2Zs/9w0Z42vadne7
	 jWyNveMtpypnyFGn3PYl4104QHGmFRjwGYvGm/oqzMfuMXaYYM9cf+nkO3VCSeDpl8
	 Uj9lh200I2vhV9u8OLA3TsMTDkz/BHGlkYWb8fng=
Date: Tue, 12 Dec 2023 10:59:53 -0800
To: mm-commits@vger.kernel.org,chen.haonan2@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-vma_pages-for-vma-objects.patch removed from -mm tree
Message-Id: <20231212185953.DB442C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use vma_pages() for vma objects
has been removed from the -mm tree.  Its filename was
     mm-use-vma_pages-for-vma-objects.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Haonan <chen.haonan2@zte.com.cn>
Subject: mm: use vma_pages() for vma objects
Date: Wed, 6 Dec 2023 18:36:27 +0800

vma_pages() is more readable and also better at avoiding error codes, so
use vma_pages() instead of direct operations on vma

Link: https://lkml.kernel.org/r/tencent_151850CF327EB055BBC83298A929BD06CD0A@qq.com
Signed-off-by: Chen Haonan <chen.haonan2@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-use-vma_pages-for-vma-objects
+++ a/mm/internal.h
@@ -616,7 +616,7 @@ folio_within_range(struct folio *folio,
 		unsigned long start, unsigned long end)
 {
 	pgoff_t pgoff, addr;
-	unsigned long vma_pglen = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	unsigned long vma_pglen = vma_pages(vma);
 
 	VM_WARN_ON_FOLIO(folio_test_ksm(folio), folio);
 	if (start > end)
_

Patches currently in -mm which might be from chen.haonan2@zte.com.cn are


