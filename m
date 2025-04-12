Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E319D2AF1E;
	Sat, 12 Apr 2025 00:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418027; cv=none; b=oTrjDVOnPl4dMUMeo2g7xCBFYSN9m770fe5cA0tE1vUx5Bei0Tw+TVppYCJaKcdkazV/ynk/JxHPlfbvQBgXy7PVa3gifuYu3F0gsbUjMwnPikV5oXHVw31IJ0BbvZosk7qoVWShRQG03PqwQHlm3dj/z9C+igWKHg55n6WAZDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418027; c=relaxed/simple;
	bh=NeUq7VrT+XSN/l8d6hx1AgaUYOdgwGzdyuZYzSVPyOo=;
	h=Date:To:From:Subject:Message-Id; b=PLQxQSwX/Lk1UIZpM4XunKdo9ZnWixUSZpYlQgQRD4LGdfFBR5YsoNtrjE0MdENIPbgHFdW68vgPe1CTZaXYR0fdA3DhCQVPmxfZt+0ZvenmOPTZrrjv8A4NMUL+QG8jK2Pv6RTC24fNjsbFq8XCCZHB7dYkCa/km+U2w7ajsig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zDZ0rZzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zDZ0rZzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61FDC4CEE2;
	Sat, 12 Apr 2025 00:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418026;
	bh=NeUq7VrT+XSN/l8d6hx1AgaUYOdgwGzdyuZYzSVPyOo=;
	h=Date:To:From:Subject:From;
	b=zDZ0rZzYf3JsQhKXW7brOZ6tEDdYvOShk5hmj1To/7Hc9DkI4ITJ494GrPhazoAso
	 8rLWup53GER4TyRlIVia188bM2sQqjCtRy5YYYNZsrJMeGJu5FPTFMP1PVWiwfK6Yr
	 sVm5XyVM8m6THn9D2AkpC3F26aiusLJHkOKmvrfc=
Date: Fri, 11 Apr 2025 17:33:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,quwenruo.btrfs@gmx.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-filemap_get_folios_contig-returning-batches-of-identical-folios.patch removed from -mm tree
Message-Id: <20250412003346.B61FDC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix filemap_get_folios_contig returning batches of identical folios
has been removed from the -mm tree.  Its filename was
     mm-fix-filemap_get_folios_contig-returning-batches-of-identical-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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

mm-compaction-use-folio-in-hugetlb-pathway.patch

