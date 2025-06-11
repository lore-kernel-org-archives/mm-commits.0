Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250321B960
	for <mm-commits@vger.kernel.org>; Wed, 11 Jun 2025 01:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607067; cv=none; b=Mk2ncL+6Zwln5FLVD+uyWYQHrUPtfjgrd1PvZk1ph4zKjtVvJ73YuJepIpVgb+a1s+AsiG9+YUPAH0JzxeFfw6kuoqcUwBakIJ4xboMHw4Apiywjd8UnhOKxP48huYZHEkwu3iSVuox72K4cLatrY0CTb1Iq7tQD9Dhn4Muud+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607067; c=relaxed/simple;
	bh=M+KAhJvnOYrV6cuxrIptNnpDd7d9KlwjvTMWG2W2tKY=;
	h=Date:To:From:Subject:Message-Id; b=ps7/YtPasiRy3HgOSD3679w9tG/vGW8HnbG6p0TSDqMdq9c8v6amVG1S8sNwU5gb9Tk3gQL4/0/3LkkRDXyy897NpwmySUhX/9bbei2jKEZ96tw8KHEDnPCAvqrR7yqMZgSUuNLqHLMWE5YmoBzRP4uQ7PeBkQnqqdCoztnenhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vYWwkZPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vYWwkZPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B868C4CEED;
	Wed, 11 Jun 2025 01:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749607066;
	bh=M+KAhJvnOYrV6cuxrIptNnpDd7d9KlwjvTMWG2W2tKY=;
	h=Date:To:From:Subject:From;
	b=vYWwkZPGi5SXZCx7uRifohCo/e07HtUj1SJt1MvgduDeeh5ab6vClzyRFwlDxFC8c
	 Uzc43uwYDdWSqCVAnQ+t1q6PLVVkWsCkL0n0SiyXeCmJxEcqUAIEYEObZUzvjRpV2m
	 xiG587lmDNKdDVchS4xJfvhisa1f2ziHiwDYLjkg=
Date: Tue, 10 Jun 2025 18:57:46 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,igor.b@beldev.am,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zblock-avoid-failing-the-build.patch removed from -mm tree
Message-Id: <20250611015746.9B868C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zblock: avoid failing the build
has been removed from the -mm tree.  Its filename was
     mm-zblock-avoid-failing-the-build.patch

This patch was dropped because it was folded into mm-add-zblock-allocator.patch

------------------------------------------------------
From: Igor Belousov <igor.b@beldev.am>
Subject: mm/zblock: avoid failing the build
Date: Mon, 28 Apr 2025 08:57:27 +0200

Don't break the build for a PAGE_SIZE that is not fully supported,
just print out a warning in that case.

Link: https://lkml.kernel.org/r/20250428065727.57990-1-igor.b@beldev.am
Signed-off-by: Igor Belousov <igor.b@beldev.am>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/zblock.h~mm-zblock-avoid-failing-the-build
+++ a/mm/zblock.h
@@ -21,7 +21,8 @@
 /* max 256 slots per block, max table size 64 */
 #define SLOT_BITS 8
 #else
-#error Unsupported PAGE_SIZE
+#warn This PAGE_SIZE is not quite supported yet
+#define SLOT_BITS 8
 #endif
 
 #define MAX_SLOTS (1 << SLOT_BITS)
@@ -101,7 +102,7 @@ static const struct block_desc block_des
 	{ SLOT_SIZE(10, 3), 10, 3 },
 	{ SLOT_SIZE(9, 3), 9, 3 },
 	{ SLOT_SIZE(4, 2), 4, 2 },
-#elif PAGE_SIZE == 0x4000
+#else
 	{ SLOT_SIZE(255, 0), 255, 0 },
 	{ SLOT_SIZE(185, 0), 185, 0 },
 	{ SLOT_SIZE(145, 0), 145, 0 },
_

Patches currently in -mm which might be from igor.b@beldev.am are

mm-add-zblock-allocator.patch
mm-zblock-use-vmalloc-for-page-allocations.patch

