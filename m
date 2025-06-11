Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBFF19A
	for <mm-commits@vger.kernel.org>; Wed, 11 Jun 2025 01:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607061; cv=none; b=U9l7X3WdJ9GzSaHOrkgmPnCpQ1aPYH29xUsdJKYf1YAS5pjNxLNMdHPXMoKQFHI4A6LxNv9YT9FVfmCWmIWQnQVJpybp9Be01K/FD3aNlrlaL0KK+8klwSEtAcaqGPfeogZQLcicI2PYBpRp3k9cKnkRDhxrEY3zMfrQ8KbKyxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607061; c=relaxed/simple;
	bh=Zq6HkGr51lTg5lrLuo9mpf3Xq87mnoewVr+qZMhVV3k=;
	h=Date:To:From:Subject:Message-Id; b=GBJHqCifcit9ze0SPqUFnteTNM02iP4M82uvNs9z238Tr0hPDRwz4y204r8lh5f9iFKsqqiQqZ/T5FDLxEclYZkBsiVt1EpvyB7UOYOmyGtHrBjtSs7UPSyPLIgGoMvwrstdz7gNF4lgiHKhxYPI9FEKG43jFbKohxFZ14B8U2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AJm939i4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AJm939i4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE4DC4CEED;
	Wed, 11 Jun 2025 01:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749607061;
	bh=Zq6HkGr51lTg5lrLuo9mpf3Xq87mnoewVr+qZMhVV3k=;
	h=Date:To:From:Subject:From;
	b=AJm939i4KZfVo5iS47NiDU6OYeqipzBJJy1WKunoP3bUh0rF6ypShrXXgo77vHyX2
	 OTVXNn/sOLnZGnc//jsLPheaX6AeosbEGeS4u5gptFhWMk4s4kpMRvidsMzFHZX6W1
	 9gI/8KPPzT7wbJA9/xGmzu88HGO9vhsd9i7KGpaQ=
Date: Tue, 10 Jun 2025 18:57:40 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,igor.b@beldev.am,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-zblock-allocator-fix-2.patch removed from -mm tree
Message-Id: <20250611015741.3DE4DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-zblock-allocator-fix-2
has been removed from the -mm tree.  Its filename was
     mm-add-zblock-allocator-fix-2.patch

This patch was dropped because it was folded into mm-add-zblock-allocator.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-zblock-allocator-fix-2
Date: Sun May  4 02:13:54 AM PDT 2025

export try_alloc_pages_noprof() to modules for CONFIG_ZBLOCK=m

Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Igor Belousov <igor.b@beldev.am>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-add-zblock-allocator-fix-2
+++ a/mm/page_alloc.c
@@ -7403,3 +7403,4 @@ struct page *alloc_pages_nolock_noprof(i
 	kmsan_alloc_page(page, order, alloc_gfp);
 	return page;
 }
+EXPORT_SYMBOL_GPL(try_alloc_pages_noprof);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-update-vmflags-documentation-in-smaps-fix.patch
drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch
mm-add-zblock-allocator.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

