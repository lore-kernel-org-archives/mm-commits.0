Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEB012DDAF
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824885; cv=none; b=Weu99faEipGJn32q5xVcG5ZyG6QCGa2HHKygkOxM+8gEymm7sY9G3e/1q1FE17t165/PaNc4agzgrWQSEQurqgjX/SzEcEBkr4ByGcTvIX9pt62e2/1p7AtnMrCXDmwJM1bgN35f/ooDZlUlHOk2OsLclWyvn3fIDz71E+6jIDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824885; c=relaxed/simple;
	bh=u8psiFkNtHHJKAYmbqr66AZSwKZHcQehONyM5TfQpTQ=;
	h=Date:To:From:Subject:Message-Id; b=T4Xm/71HodZzynaMmbxCJpNFReArdXnzoMBUSF1Tsailqt/LGqHtCBQ/QUdo8lva2upAj3XqBj1rruO/QSLreFDiU9KS/1fK+5vZlf7/iMfikF++PmKfLZIwDZpnWyyw7sXysNLtHrToaBWgnaGRfP2jh/MkMJikzXIWlsjPBqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CdStweId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CdStweId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828D6C4AF0A;
	Fri, 12 Jul 2024 22:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824885;
	bh=u8psiFkNtHHJKAYmbqr66AZSwKZHcQehONyM5TfQpTQ=;
	h=Date:To:From:Subject:From;
	b=CdStweIdJ+GYgDQAHwqjSeqFbVn0LlamsK9jSAqIu57dgy0I936r20istJvIGx0zd
	 9UTmewBSXHTogp+ZZalhPW5ur/pB3pJJV0rFEOQEYmI5xueccfzhjSkbhyhHrzQB7r
	 uKCMoipSgs49/TctVvnLn33NrmDXJhDkoADcGlDg=
Date: Fri, 12 Jul 2024 15:54:45 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,apopple@nvidia.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-unexport-vmf_insert_mixed_mkwrite.patch removed from -mm tree
Message-Id: <20240712225445.828D6C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: unexport vmf_insert_mixed_mkwrite
has been removed from the -mm tree.  Its filename was
     mm-unexport-vmf_insert_mixed_mkwrite.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport vmf_insert_mixed_mkwrite
Date: Tue, 2 Jul 2024 09:23:27 +0200

vmf_insert_mixed_mkwrite is only used by the built-in DAX code.

Link: https://lkml.kernel.org/r/20240702072327.1640911-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-unexport-vmf_insert_mixed_mkwrite
+++ a/mm/memory.c
@@ -2533,7 +2533,6 @@ vm_fault_t vmf_insert_mixed_mkwrite(stru
 {
 	return __vm_insert_mixed(vma, addr, pfn, true);
 }
-EXPORT_SYMBOL(vmf_insert_mixed_mkwrite);
 
 /*
  * maps a range of physical memory into the requested pages. the old
_

Patches currently in -mm which might be from hch@lst.de are


