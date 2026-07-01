Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF8228504D
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 05:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782883452; cv=none; b=qnbCmDElFu+4egPVXI1SYtaqmJHV46zriW7vaHexi3KITMlldmdckBGlOGw44btOeELiIIId+qCd9S1q4XPBkn+T+SYW9r0GJWHZGeaZnvhfxfVHKw0frcz7LcMAnZx+gMbaVcMtHP1u9Kw9AwZoKRleUTkw2O/K9FSZPbm/n/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782883452; c=relaxed/simple;
	bh=XX6bYupslr946BCUMUG8eIDlcEEQPOFPanzWgjKCiJc=;
	h=Date:To:From:Subject:Message-Id; b=gIN9VB1jnXNd5bbu2QGjy/QjtBT1KB3OHDcMOl/FWb/OCqvjzYK+k/dTfWfISKkXVNUFMjrW3vNfFMJMUkwzUX3kZtds0mu999irk+rG11QKOWxU4uGLxD4ol7G5E34d+C1IJo1WNflFfs7N1cHOBM+Qf8Whroo5gf/CUyTojJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PTodkF0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PTodkF0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98E31F000E9;
	Wed,  1 Jul 2026 05:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782883450;
	bh=gg+VxDE8tFqGB8PO9VHtkwVy0hwhJO9jYWrcVFXq4z4=;
	h=Date:To:From:Subject;
	b=PTodkF0xa6cMb7kORCGV4KK0nlzz3y/WMGfQFLBXkiqPAtmKvtBe8mJnWPBKM57an
	 n7tFM75dDLt3/84pFHXxeoY7xL0MnfvDZ94V3JvYvKbeMc8fwv59dFOIjTT1rhlCJV
	 Hmh+Hnl33DNPWcn2bJ26+SJhK0+R7NMUcxKcJxP0=
Date: Tue, 30 Jun 2026 22:24:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-avoid-kcsan-false-positive-in-memdesc_nid.patch removed from -mm tree
Message-Id: <20260701052410.A98E31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: avoid KCSAN false positive in memdesc_nid()
has been removed from the -mm tree.  Its filename was
     mm-avoid-kcsan-false-positive-in-memdesc_nid.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: avoid KCSAN false positive in memdesc_nid()
Date: Tue, 23 Jun 2026 16:44:32 +0800

KCSAN reports a data race between page_to_nid()/folio_nid() reading
page->flags and folio_trylock()/folio_lock() concurrently doing
test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:

  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp

The node id occupies a fixed bit-range of page->flags that is set once at
page init and never modified afterwards, so it can never overlap with the
low PG_locked/PG_waiters bits touched by the folio lock path.

Use ASSERT_EXCLUSIVE_BITS() in memdesc_nid() to scope the exemption to
just the node-id bits, consistent with how memdesc_zonenum() already
handles the same class of race for the zone-id bits.

Link: https://lore.kernel.org/20260623084432.701120-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-avoid-kcsan-false-positive-in-memdesc_nid
+++ a/include/linux/mm.h
@@ -2290,6 +2290,7 @@ int memdesc_nid(memdesc_flags_t mdf);
 #else
 static inline int memdesc_nid(memdesc_flags_t mdf)
 {
+	ASSERT_EXCLUSIVE_BITS(mdf.f, NODES_MASK << NODES_PGSHIFT);
 	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are


