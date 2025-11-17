Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F3B2264AA
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343203; cv=none; b=MM2lYwi/vBzAPANiaHwwP3/Hkrih815oceNFZBeSATUBLgp/4B4h8b2lTHfNK9hB3sCPsFVuppBCdg8yniJvUMBlRH/7y7adxKTDAk/d7Zic5FI6Jh+G+G70wgK8dtGQZT6Q9xD/x66WRl9xkceLIFPfAPyHFMWA2rE3+rIfiG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343203; c=relaxed/simple;
	bh=7Fuzkp202Qk5p2N2KLB0B0/uSRDfEekGJOZFGRIcKA4=;
	h=Date:To:From:Subject:Message-Id; b=EDPhNJwDqIXX0ciLrYWYMdDCfWSNCyoCrEMlT9vcg7gSgct/1eMRE6n4uQYjirIqcF8RrO+uCiCr3rfjTur1TLNtZryeRtQRf3T6e/6XMczJjdgqekM8jl+ZOG4NDNxKflni4UoTV3b/krOFHqZ2R5fXhc8BC4kHOEQ7U2c5W2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M9Rs7Vvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M9Rs7Vvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A361AC2BC86;
	Mon, 17 Nov 2025 01:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343203;
	bh=7Fuzkp202Qk5p2N2KLB0B0/uSRDfEekGJOZFGRIcKA4=;
	h=Date:To:From:Subject:From;
	b=M9Rs7VvcuqTEZwx2OtjbjR+gZgy1XZtFZe8QhT8/B2wzkshOm3W2+qqP5DBiHYhiI
	 +DV8DPAD1DsdR4Dzgdj+aWYxmUAGQ22RsWfnO7//6E9aWd6zZA1VVoQ0xq7kdXqrsz
	 5EmYF6igP7RoDGzPY04SPTJ7+n4uy0KmBBhbHsbE=
Date: Sun, 16 Nov 2025 17:33:23 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,khalid@kernel.org,david.hunter.linux@gmail.com,mehdi.benhadjkhelifa@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-use-kmalloc_array-instead-of-kmalloc.patch removed from -mm tree
Message-Id: <20251117013323.A361AC2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: use kmalloc_array() instead of kmalloc()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-kmalloc_array-instead-of-kmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Subject: mm/vmalloc: use kmalloc_array() instead of kmalloc()
Date: Sat, 18 Oct 2025 21:11:48 +0100

The number of NUMA nodes (nr_node_ids) is bounded, so overflow is not a
practical concern here.  However, using kmalloc_array() better reflects
the intent to allocate an array of unsigned ints, and improves consistency
with other NUMA-related allocations.

No functional change intended.

Link: https://lkml.kernel.org/r/20251018201207.27441-1-mehdi.benhadjkhelifa@gmail.com
Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Khalid Aziz <khalid@kernel.org>
Cc: David Hunter <david.hunter.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-kmalloc_array-instead-of-kmalloc
+++ a/mm/vmalloc.c
@@ -5140,7 +5140,7 @@ static int vmalloc_info_show(struct seq_
 	unsigned int *counters;
 
 	if (IS_ENABLED(CONFIG_NUMA))
-		counters = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
+		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
 
 	for_each_vmap_node(vn) {
 		spin_lock(&vn->busy.lock);
_

Patches currently in -mm which might be from mehdi.benhadjkhelifa@gmail.com are

selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area.patch
selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area-v2.patch

