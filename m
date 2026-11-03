Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672146;
	b=TDd0SdL6Sgk2OXsaYitEszSK1W/cuYOfmpw/L9VUjmuwKqYnzFPZ4ch5Dk5ZV7w3f3wL
	 ud/DA8DmuZ3dsO4lSrzctJ0jOgiuBiSUavKwMb3AzOviiUNrgd/lKm0cOIgqCOMcr93Qn
	 ik1+1gvJveshe64JWW3oYZquVCeS2pEF9l6HfXPZGqHNbrtv1jifR11xB2IeG2EtZ2XlW
	 13+H30+PghCigfilOIAkvCUqQTnDPrv1lSMVMhTbBIUPONxnK2fXd7fPgXJrf0MxoeCdF
	 wbv+AHNTdY/7wX/qFi6rackpU4e+ebtTfFTcL4EDChYV5WW10py/32MV0J249bMDtnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672146;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=AhiHYgzV9FytEyi5cnCdcJDs04Q5yBfo9h7wiXr5MbM=;
	b=fq9/1GuAYLbVRra2ilij+dw6xgeM3289jw3/dyAJW5ljstfOK4F1dzu1gJwr12e+3SDA
	 dYTBRH+cW/thV3QQjelYdT8JGrn/3YrxXu0NTW9cpyuEhLqJe3kEp50Jx3j76SzV0seWg
	 GlzCWN83m94ewFp4VLiup1DjNstpui0MJR7cMIQYuqW+PAqDLYfaBJcd+waSEv4Hl0W9H
	 GO8TbCR7yeL/KdWZbzhholXBGZKdXswSdqXia6ffK+foSwIwHBiLsMitcP9GB8qYwXHiv
	 iRJewUsjR9iW9UHwETWQWiqH0avvBhVBkPLr5Q+LnVqQByMfcDgT3ivdOJcY5YqIbrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=R+rsMsnz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C05606A324;
	Tue,  3 Nov 2026 02:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=R+rsMsnz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F02F1F00919;
	Tue,  3 Nov 2026 02:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672145;
	bh=AhiHYgzV9FytEyi5cnCdcJDs04Q5yBfo9h7wiXr5MbM=;
	h=Date:To:From:Subject;
	b=R+rsMsnzQ/S54HoMgTaF+CSyGTe3/ru2cyJhxPOeZ6lk41gFvPcdwtiC/C1tMHAxg
	 SO72wsVDs3g0kvtxsaQdRzqUYSTHBgRExGmqfTKt4FQ0AvBEszFy/iYSOuIhGuayI+
	 l2EN5jGA3wXHuEHDV/mSr2BOxkDt/RGVNtpvH55k=
Date: Mon, 02 Nov 2026 18:15:45 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	vincenzo.frascino@arm.com,stable@vger.kernel.org,odys.yuan@gmail.com,
	matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,
	david@kernel.org,catalin.marinas@arm.com,byungchul@sk.com,apopple@nvidia.com,
	andreyknvl@gmail.com,dennylin0707@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-untag-addresses-when-querying-page-nodes.patch removed from -mm tree
Message-Id: <20261103021545.6F02F1F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/migrate: untag addresses when querying page nodes
has been removed from the -mm tree.  Its filename was
     mm-migrate-untag-addresses-when-querying-page-nodes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: mm/migrate: untag addresses when querying page nodes
Date: Mon, 26 Oct 2026 19:53:29 +0000

When move_pages() is used with nodes == NULL, do_pages_stat_array() passes
each page address directly to vma_lookup().  A valid tagged address
therefore fails the VMA lookup and gets -EFAULT in its status entry,
instead of the node reported for the corresponding untagged address.

The tagged address ABI permits these pointers, and the migration path
already removes their tags.  Apply the target mm's untagging rules to the
query path as well, while holding its mmap read lock.

Link: https://lore.kernel.org/20261026195330.46757-1-dennylin0707@gmail.com
Fixes: 057d3389108e ("mm: untag user pointers passed to memory syscalls")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260721183257.706661F000E9@smtp.kernel.org
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <odys.yuan@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-untag-addresses-when-querying-page-nodes
+++ a/mm/migrate.c
@@ -2461,7 +2461,7 @@ static void do_pages_stat_array(struct m
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr_remote(mm, *pages);
 		struct vm_area_struct *vma;
 		struct folio_walk fw;
 		struct folio *folio;
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch
delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch
shmem-clamp-negative-used-block-samples-in-statfs.patch

