Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AFA1586C8;
	Mon,  7 Apr 2025 20:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744059543; cv=none; b=JzC3EyGRHIRBNLCYWM3nJm66f5pxKE66BJqgB3asEmSBE4IpsvffJBeiqQplHc0zMbDdWFWCD8ImbqXw7nQVZftfvAJD9yjXGZSl81eN1isIueayipplIF0dreRJwZGI0J7IRvSYLvR1jSymoTOu1ocu8p9LWHm2o2k4n0munYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744059543; c=relaxed/simple;
	bh=e35dlJ5b5L77mPC7SxCd9ogNim8rLddGmPBXQZAFO08=;
	h=Date:To:From:Subject:Message-Id; b=dAFM/l7H6ejEJ1JVHeVU+96MLktasf31rixRC3S56DC6Z1vTaaBGUcae1SUZ+TksVv/EOA/G+KnqiTNe+tdN/zAFW5Utnd88k5grGGWDJkCxKDv11i8q6wBXgeH4CwoUV6fK2/mah3OG0bD/7xRdgfhvXlh6kgKn7e75lK6ZjVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Orgbi7J2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Orgbi7J2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A46C4CEDD;
	Mon,  7 Apr 2025 20:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744059542;
	bh=e35dlJ5b5L77mPC7SxCd9ogNim8rLddGmPBXQZAFO08=;
	h=Date:To:From:Subject:From;
	b=Orgbi7J2WZujHOaPHSTHI3uUSk1dc3kgChDs1hTX0jk+cnpjIvQwVLZSQcqYe1E9z
	 OR9GsYaEDLhXoJv3x+0L9DfoakB6AwfeDNrgXJzCo2nBKlzgr9y4UhBykf8/B6eFUZ
	 5bf19uLmISWarPbSNdkXDxsu8nVvDdYxt0v1n1Hg=
Date: Mon, 07 Apr 2025 13:59:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,quwenruo.btrfs@gmx.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-filemap_get_folios_contig-returning-batches-of-identical-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20250407205902.76A46C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix filemap_get_folios_contig returning batches of identical folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-filemap_get_folios_contig-returning-batches-of-identical-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-filemap_get_folios_contig-returning-batches-of-identical-folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: fix filemap_get_folios_contig returning batches of identical folios
Date: Thu, 3 Apr 2025 16:54:17 -0700

filemap_get_folios_contig() is supposed to return distinct folios found
within [start, end].  Large folios in the Xarray become multi-index
entries.  xas_next() can iterate through the sub-indexes before finding a
sibling entry and breaking out of the loop.

This can result in a returned folio_batch containing an indeterminate
number of duplicate folios, which forces the callers to skeptically handle
the returned batch.  This is inefficient and incurs a large maintenance
overhead.

We can fix this by calling xas_advance() after we have successfully adding
a folio to the batch to ensure our Xarray is positioned such that it will
correctly find the next folio - similar to filemap_get_read_batch().

Link: https://lkml.kernel.org/r/Z-8s1-kiIDkzgRbc@fedora
Fixes: 35b471467f88 ("filemap: add filemap_get_folios_contig()")
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reported-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Closes: https://lkml.kernel.org/r/b714e4de-2583-4035-b829-72cfb5eb6fc6@gmx.com
Tested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/filemap.c~mm-fix-filemap_get_folios_contig-returning-batches-of-identical-folios
+++ a/mm/filemap.c
@@ -2244,6 +2244,7 @@ unsigned filemap_get_folios_contig(struc
 			*start = folio->index + nr;
 			goto out;
 		}
+		xas_advance(&xas, folio_next_index(folio) - 1);
 		continue;
 put_folio:
 		folio_put(folio);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-compaction-fix-bug-in-hugetlb-handling-pathway.patch
mm-fix-filemap_get_folios_contig-returning-batches-of-identical-folios.patch
mm-compaction-use-folio-in-hugetlb-pathway.patch

