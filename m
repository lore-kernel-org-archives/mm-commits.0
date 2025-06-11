Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B7C19A
	for <mm-commits@vger.kernel.org>; Wed, 11 Jun 2025 01:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607060; cv=none; b=FsAenbhVWnoZbaXnekqjtPMscbLNT17wrlbCikClEgZCxcPGuu6RaLDfQWop0xK8rcVum+P81Sc5ndqvM7DXVQxyjE5dDatLf1B0tBn0J0rxBunMmsnQ/6YErAqnYv6qmq7TXqSKPJS/H90mTZS/tT182Gj76NQUgF1q1+tRUas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607060; c=relaxed/simple;
	bh=gce2YP5s+jQ8xcAgnHykTXH/46IRwW4D3nxJFCO6w3g=;
	h=Date:To:From:Subject:Message-Id; b=WDoGXByo1cR/ebGKZbbnp2+idggTuvt3+0tj47xJ7yN6Vo1c70l2/fxPHyCb6Tr2txQkDf48yXO2Dad/gmBxJxwvwfn3wssSgNLlQqdDkudTh4zyfYNyJL/fMrvFeVLhvudr005EJ71ZtNmVwiZ5va99XDwzCrjKv8F3mBjuYSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=flkM/Au6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="flkM/Au6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2BBC4CEED;
	Wed, 11 Jun 2025 01:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749607060;
	bh=gce2YP5s+jQ8xcAgnHykTXH/46IRwW4D3nxJFCO6w3g=;
	h=Date:To:From:Subject:From;
	b=flkM/Au6Jugw3cHHtHMPks4SuPoWXmVGiTloRITjTnTH3PEj2CWp2K6uyTq8fyDuh
	 lMEH6fQo5Nmxwnv3lasgFaHb1nKkGYDc5FAYEjc4QoWTLf3BoEfUYmdyOWj3u1VL9f
	 gXBGT+QEG+mwnmU27+Mc/QpolzwrkKP4oOooWTnw=
Date: Tue, 10 Jun 2025 18:57:39 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,igor.b@beldev.am,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-zblock-allocator-fix.patch removed from -mm tree
Message-Id: <20250611015739.EA2BBC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-zblock-allocator-fix
has been removed from the -mm tree.  Its filename was
     mm-add-zblock-allocator-fix.patch

This patch was dropped because it was folded into mm-add-zblock-allocator.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-zblock-allocator-fix
Date: Tue Apr 15 09:02:06 PM PDT 2025

fix build

Cc: Igor Belousov <igor.b@beldev.am>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zblock.c~mm-add-zblock-allocator-fix
+++ a/mm/zblock.c
@@ -328,7 +328,7 @@ static void zblock_zpool_destroy(void *p
 }
 
 static int zblock_zpool_malloc(void *pool, size_t size, gfp_t gfp,
-			unsigned long *handle)
+			unsigned long *handle, const int nid)
 {
 	return zblock_alloc(pool, size, gfp, handle);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-update-vmflags-documentation-in-smaps-fix.patch
drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch
mm-add-zblock-allocator.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

