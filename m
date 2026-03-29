Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C497624EAB1
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744851; cv=none; b=u8cmClKkU3FJ+phiBdbQ6sZV0q0dg7F/HH2V1v8bqWeQiqrje10Y+dcaJUAPJ92VPODGwxG0gXeRe5mTAalUkM7ECFoezECtl3DRYoBGCjei6ff6Qt2BhRvtilTiOP5gL2TJ5PctUoEiwNqxUtMb4kvJKCxpllzxEjZA40p0A2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744851; c=relaxed/simple;
	bh=yTYrdhPR4As8vlrmsZsvBn36xFgwzTvbV7amALMG5lU=;
	h=Date:To:From:Subject:Message-Id; b=hJSBI1LwSCqgeCgNhvhGGlo8AaNIHqts5WiJ5BaIKJk7mp6Gts/m3AhJ2inOCOhk/ZHG9Jw2ChtD/7kTJHRfb2WmTtY7DGtjHsaoxZ/sNC0YJdkMhodnDxEVO9rKv9kmh7MW1k+iemf8k3l90AdIToK0qHZUb7N2ygLhQyFiZJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U6ZjIbeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U6ZjIbeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEB6C4CEF7;
	Sun, 29 Mar 2026 00:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744851;
	bh=yTYrdhPR4As8vlrmsZsvBn36xFgwzTvbV7amALMG5lU=;
	h=Date:To:From:Subject:From;
	b=U6ZjIbeqppN5JxgdKtPb34FMGBfyua1F71HUyEX30g/VaGWuvYCZONJ2ccjbN6JA+
	 bzLDykEEQ8AHi184ur/D3vWMVup/G3hGAJAf0mieCtHU03LYTjNz2UdctGcPVrZYbL
	 eDcYo1JI6P6zsMufhsg5uAad1iojANnj7GGybttk=
Date: Sat, 28 Mar 2026 17:40:51 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kho-drop-restriction-on-maximum-page-order.patch removed from -mm tree
Message-Id: <20260329004051.9DEB6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: drop restriction on maximum page order
has been removed from the -mm tree.  Its filename was
     kho-drop-restriction-on-maximum-page-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: drop restriction on maximum page order
Date: Mon, 9 Mar 2026 12:34:07 +0000

KHO currently restricts the maximum order of a restored page to the
maximum order supported by the buddy allocator.  While this works fine for
much of the data passed across kexec, it is possible to have pages larger
than MAX_PAGE_ORDER.

For one, it is possible to get a larger order when using
kho_preserve_pages() if the number of pages is large enough, since it
tries to combine multiple aligned 0-order preservations into one higher
order preservation.

For another, upcoming support for hugepages can have gigantic hugepages
being preserved over KHO.

There is no real reason for this limit.  The KHO preservation machinery
can handle any page order.  Remove this artificial restriction on max page
order.

Link: https://lkml.kernel.org/r/20260309123410.382308-2-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-drop-restriction-on-maximum-page-order
+++ a/kernel/liveupdate/kexec_handover.c
@@ -411,7 +411,7 @@ static struct page *kho_restore_page(phy
 	 * check also implicitly makes sure phys is order-aligned since for
 	 * non-order-aligned phys addresses, magic will never be set.
 	 */
-	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
+	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC))
 		return NULL;
 	nr_pages = (1 << info.order);
 
_

Patches currently in -mm which might be from pratyush@kernel.org are


