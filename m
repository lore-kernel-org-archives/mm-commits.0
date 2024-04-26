Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5760A2BAE5
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102215; cv=none; b=J4R1UxjTLB82eCxUCstP3EJKTUZHXW95qog6Tug0617ew47BQ3ag9rcS8Ow9Ks0313MAUfHEr1hP27Ijr+32KtJQMuge+6brsHZLw6mgTM5g0JR8mRiz5cDUfbVT3D5owpklLiJw704frWTDZl1EE2HKKs+Yc1HDAWOZyVxn8as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102215; c=relaxed/simple;
	bh=kV+pn5+/EeF6nFa+nanApzNbFSw6PRvxMEfF4UqZgjc=;
	h=Date:To:From:Subject:Message-Id; b=fQr87BLrGvE6tEqc4/FAtXFi/FGCujiRqlJCGSpzk27fpObGPqghx+BxfgWfcPW0gytibSoxd1B02ole9LZW9/fG2bYQyecd21aXnSNfpw5J0rY+kXITc2qsBNptFNeIRn6MBweVTlszBOwHZjAS/TnpJszTCNcwBbNAWWTa3XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vfJL1Vx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vfJL1Vx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1C0C113CD;
	Fri, 26 Apr 2024 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714102214;
	bh=kV+pn5+/EeF6nFa+nanApzNbFSw6PRvxMEfF4UqZgjc=;
	h=Date:To:From:Subject:From;
	b=vfJL1Vx2Qd+INjy/KEWjDNc97kzJcFl3r7ccgdyWZaijOuqS4wQmOfE4QPBwNuBLG
	 F4S0TtpfbCLmeIZ+uWO7djvApB+c9zrvnJDIOinttitylMLV/O2jvhGxEX8pJuPF1I
	 cGI4zG+UkXn0gvJeYt1Eb9U8gqtjxXurPbMABj8Q=
Date: Thu, 25 Apr 2024 20:30:14 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zswap-replace-rb-tree-with-xarray-v10.patch removed from -mm tree
Message-Id: <20240426033014.CB1C0C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zswap: replace RB tree with xarray
has been removed from the -mm tree.  Its filename was
     zswap-replace-rb-tree-with-xarray-v10.patch

This patch was dropped because it was folded into zswap-replace-rb-tree-with-xarray.patch

------------------------------------------------------
From: Chris Li <chrisl@kernel.org>
Subject: zswap: replace RB tree with xarray
Date: Tue, 26 Mar 2024 14:17:26 -0700

restore original comment "erase" to "invalidate"

Link: https://lkml.kernel.org/r/20240326-zswap-xarray-v10-1-bf698417c968@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~zswap-replace-rb-tree-with-xarray-v10
+++ a/mm/zswap.c
@@ -1576,7 +1576,7 @@ bool zswap_load(struct folio *folio)
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
 	/*
-	 * When reading into the swapcache, erase our entry. The
+	 * When reading into the swapcache, invalidate our entry. The
 	 * swapcache can be the authoritative owner of the page and
 	 * its mappings, and the pressure that results from having two
 	 * in-memory copies outweighs any benefits of caching the
_

Patches currently in -mm which might be from chrisl@kernel.org are

zswap-replace-rb-tree-with-xarray.patch

