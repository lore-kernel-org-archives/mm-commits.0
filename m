Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C55423D3ED
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837083; cv=none; b=OAANBQx4MxkaMJLA3k3UNv1JuAwOJIxNYg25YeOQ4VW3bIr7DBEzubK0VXixPWGi1+RCJpmOtq4+aw/zuMCx2ycQUHR2VqlETI50U3zg1naVmexc/Utz1oGZN8WIr0/gTUdTNjwnZKY4og6G+mcwDs8tvr+B11NWE1ekIRdIBbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837083; c=relaxed/simple;
	bh=a/gwWA7RjBZbJ1BAnfXrKWY32YoeQphoPDtnUBvcTwQ=;
	h=Date:To:From:Subject:Message-Id; b=V7EqlXAPOoYdOjyVqyoiEhcm0ertrwhUz0394Ivi3nGfzXl5HhwyproSVhcVgEZYmMhyfItcBMsEvC4F1DsJ1TFmfbSE8m6qa4H+++fnCyNz7VSQMOsatjbe0g+Los3DUcSNhqIUrO+cRbGXdEkbr/miLFjylazvGOslwMrGI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EPBMxRZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPBMxRZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60931C4CEDD;
	Tue, 14 Jan 2025 06:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837083;
	bh=a/gwWA7RjBZbJ1BAnfXrKWY32YoeQphoPDtnUBvcTwQ=;
	h=Date:To:From:Subject:From;
	b=EPBMxRZMTqlpNFzzFtlkSUgkK4fI1WVofGtgfU4g8vdmYxzd5vCd1HA/A7hA9bVTM
	 DweQ1Tv74Py9viPdzVYFQHRNigBrbiOHR3vJXl/KKm9GQVPX/1+NELqNpK0Z47+YMX
	 XthA6oL5uCCUND3+w/Yr8Ka3nyGTn+zEZg0yxomw=
Date: Mon, 13 Jan 2025 22:44:42 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-unexport-apply_to_existing_page_range.patch removed from -mm tree
Message-Id: <20250114064443.60931C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: unexport apply_to_existing_page_range
has been removed from the -mm tree.  Its filename was
     mm-unexport-apply_to_existing_page_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport apply_to_existing_page_range
Date: Thu, 12 Dec 2024 08:34:23 +0100

apply_to_existing_page_range() is only used by non-modular code.

Link: https://lkml.kernel.org/r/20241212073423.1439954-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-unexport-apply_to_existing_page_range
+++ a/mm/memory.c
@@ -3082,7 +3082,6 @@ int apply_to_existing_page_range(struct
 {
 	return __apply_to_page_range(mm, addr, size, fn, data, false);
 }
-EXPORT_SYMBOL_GPL(apply_to_existing_page_range);
 
 /*
  * handle_pte_fault chooses page fault handler according to an entry which was
_

Patches currently in -mm which might be from hch@lst.de are


