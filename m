Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832453;
	b=L1Gzo4dA1t5beP4ChCtMBey9uv0U/kc6vwVfML2I3+vp0qPNKY8AvLhUA9r7q8TYVE/D
	 XbEnPkaqnhDOhul0pJTHgz8qBXwg+/vQh8C0gboF4c3q3/Hr+TiAMkfP2QY1ewZg5poeY
	 um/5OkYMiiTZgXaGD66arNVvc5hXr2urbgSOcCHFISecjfASDBWLDxbvPtbwtAUDfBhfw
	 08DeKTI/zxwIeUpvmiPUpY8LSiAKeA6Qgqb2yE7njrjusPgeoklisWBMmHdseDCdzQrAw
	 lmPeqLR7roe6XsqnQfaGSnZXZV2V+5LxLc471b9ET+d3ehCB6yPGuk5aEajlh/alLpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832453;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Mmq8Q6Vx2kV2yvUvGAhn1Nv2IdNnP3N9AHBt4ke0SZI=;
	b=oIe+FuLaEO3BgPi0N30+YQGV+b8idCIvqLizAT5xz8bkWVtOlj8DmuTBXtyNgMl1b38U
	 ez//g0H2eayGPLFRJQ+MoPiASP4nLtIficNQ21eJly4fCKw0yGPp8rzOS1OTFYImpshml
	 qKwe3Q0MF21NX2z+B4oFXobgFs+aFAq1/JBw5q8jyiuP5fxeA5psdf8dAfc2/Jst2yZBh
	 ap2wSUKoaMjBpPnIquSPxZuPXLR6tkAwhApHdgZXwj3Tt08TdGj17bQ9Wkga6x8d02Q4Y
	 fgvguzKLCTL3NqCVLpFhv99dohW50nMuQe3j/XTfB1DvseNXku52IiKybrrvMO75ozA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PcFSv9RD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40201606A322
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PcFSv9RD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EE51F01829;
	Sat, 24 Oct 2026 09:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832453;
	bh=Mmq8Q6Vx2kV2yvUvGAhn1Nv2IdNnP3N9AHBt4ke0SZI=;
	h=Date:To:From:Subject;
	b=PcFSv9RD0FpZGeSOBqwEL1qUt4YZL/nyrxcOi8fJb/m1zhDm2LuDJbNlcOkzW2peh
	 M9UFedeB82djaR9RPpLrXANqnQn3r2illr3V9TJmOM9qXO8y6d3GPXLI1L4ffUH+cG
	 9AU2s6/E3kcnT4wshOjJ0OLlAWk7xirUb2ylOvTM=
Date: Sat, 24 Oct 2026 02:00:52 -0700
To: mm-commits@vger.kernel.org,vasant.hegde@amd.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,dave@stgolabs.net,bharata@amd.com,dheerajkumar.srivastava@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-kvmalloc_objs-for-hugetlb_fault_mutex_table.patch removed from -mm tree
Message-Id: <20261024090053.08EE51F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: use kvmalloc_objs for hugetlb_fault_mutex_table
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-kvmalloc_objs-for-hugetlb_fault_mutex_table.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Subject: mm/hugetlb: use kvmalloc_objs for hugetlb_fault_mutex_table
Date: Tue, 6 Oct 2026 21:31:28 +0530

On systems/VMs with a large number of CPUs (e.g.  4096), hugetlb_init()
computes num_fault_mutexes = roundup_pow_of_two(8 * num_possible_cpus()) =
32768.  The subsequent kmalloc for the mutex table can exceed
MAX_PAGE_ORDER when struct mutex is enlarged by debug options like
CONFIG_DEBUG_MUTEXES and CONFIG_DEBUG_LOCK_ALLOC, resulting in:

  WARNING: at __alloc_frozen_pages_noprof (order > MAX_PAGE_ORDER)
  kernel BUG at mm/hugetlb.c (BUG_ON(!hugetlb_fault_mutex_table))
  Kernel panic - not syncing: Fatal exception

Switch to kvmalloc_objs() so the allocation falls back to vmalloc when the
contiguous physical allocation is too large.  The table is only accessed
by index, so virtual contiguity is sufficient.

Link: https://lore.kernel.org/20261006160128.31447-1-dheerajkumar.srivastava@amd.com
Fixes: 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")
Signed-off-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Bharata B Rao <bharata@amd.com>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-kvmalloc_objs-for-hugetlb_fault_mutex_table
+++ a/mm/hugetlb.c
@@ -4231,7 +4231,7 @@ static int __init hugetlb_init(void)
 	num_fault_mutexes = 1;
 #endif
 	hugetlb_fault_mutex_table =
-		kmalloc_objs(struct mutex, num_fault_mutexes);
+		kvmalloc_objs(struct mutex, num_fault_mutexes);
 	BUG_ON(!hugetlb_fault_mutex_table);
 
 	for (i = 0; i < num_fault_mutexes; i++)
_

Patches currently in -mm which might be from dheerajkumar.srivastava@amd.com are


