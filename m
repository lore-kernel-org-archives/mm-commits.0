Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D761552EB
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619849; cv=none; b=kpSp1AZalFAVrv8G8F4aEw8xTqUlLw6fxnr98KhNVcYRydgKgT4b4CNIHnqUWTbaKR+GHXTHkjh6g/CyK/zGPAFPRYNymcnEDvRxR+TiZLSf98MEI//F2WoN50Qjj47cxaLjtdhD4deo7az/lz/y6M3ru/hAR1FWFvl/HjaCMwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619849; c=relaxed/simple;
	bh=4RL5qG3Icj/dAC4JXxh+lspowiZHtjuIpxazIgwyAwM=;
	h=Date:To:From:Subject:Message-Id; b=RhPIplELtVuyNvZ3PbfyvODI8866s/am9eq7RFkm1gCvQ28cPR0E1fw1dVmMnDeyyptx0ek9vE9EDmHXCRf3OidIEsU6SbUr1icTE5oxrULWl2TFKjvvM8y0TvAcWygdrOXyFr2+f5RUzuwfwX/6uitbcUSEeQs+Ejputz2KVUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oDCETHKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oDCETHKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F460C4CEDD;
	Sat, 22 Mar 2025 05:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619849;
	bh=4RL5qG3Icj/dAC4JXxh+lspowiZHtjuIpxazIgwyAwM=;
	h=Date:To:From:Subject:From;
	b=oDCETHKu4ai5u8qkpX+64dQFmjlqAeQa4tq7U1/nw19CacYXINgUANEmtzZ9FPQ4n
	 nfhPt12E43UvaA5qe0RMpejObDUNMLoxDszCY/ketvb+AXIPGe/iWfoLeUuVkGOPKC
	 8OYK1kwN56oK8rtpBvjC5bUivB6zKT5A3q0gNauA=
Date: Fri, 21 Mar 2025 22:04:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-active-damos-filter-type.patch removed from -mm tree
Message-Id: <20250322050409.7F460C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm/damon/design: document active DAMOS filter type
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-active-damos-filter-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: docs/mm/damon/design: document active DAMOS filter type
Date: Tue, 18 Mar 2025 11:30:29 -0700

Document availability and meaning of "active" DAMOS filter type on design
document.  Since introduction of the type requires no additional user ABI,
usage and ABI document need no update.

Link: https://lkml.kernel.org/r/20250318183029.2062917-3-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-active-damos-filter-type
+++ a/Documentation/mm/damon/design.rst
@@ -656,6 +656,8 @@ Below ``type`` of filters are currently
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that containing data that not stored in files.
+    - active
+        - Applied to active pages.
     - memcg
         - Applied to pages that belonging to a given cgroup.
     - young
_

Patches currently in -mm which might be from nphamcs@gmail.com are


