Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310CB1C245C
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391120; cv=none; b=Ih7cwlPij0jV6ENfnhE2IKAY1FZMr80mkV3C4LskAfVnugsXKdYio0Sf7GyfNfTmh1WaeGrT1pfn+wQe1VPKwwHfZJYlChnoH0dx2ls2zEpT3l+aatsj7hD642x17Nm0gAP636ZZAVFhIGohvxGVKYH+J73ZjPNaehjSeKCNlLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391120; c=relaxed/simple;
	bh=rHqUywfPWKwLcczTOXtUQ+BM8an5UepxYe5gTMHzJJI=;
	h=Date:To:From:Subject:Message-Id; b=LJX66H4WDEqiWHiO+jG9TXwPsV9Cpet/pObHndwEqMX8SLcSAj2jfU7UIHd0FW2iqN6B/zjbTi0OzxV1yzs+ojNWYhymIduVv/0dyQaKYnfqeF3aRpE8r+pzDcWEFDaUGxRujJX8g3hZgrFOeFLoZiiO31M2tUsOiXqJQXE/iKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GudYYx1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GudYYx1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A337FC4CEE3;
	Fri, 20 Jun 2025 03:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391118;
	bh=rHqUywfPWKwLcczTOXtUQ+BM8an5UepxYe5gTMHzJJI=;
	h=Date:To:From:Subject:From;
	b=GudYYx1vbxuvLp3pRlwSOMq1X2F7rI0DKpZK97locFWvH6d+yIv7MOPfUZuG4eOkE
	 mP84pEFWD5/hs3YhQBLYXwXUlXbFly0wl1a6FzRZ5IB1U5vVPn3TE3k2zWjnIvlRcc
	 unQXPWHQ1OgLnQpn6mcUVHZ8/ROm83RwKuyccN1Q=
Date: Thu, 19 Jun 2025 20:45:17 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3.patch removed from -mm tree
Message-Id: <20250620034518.A337FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3
has been removed from the -mm tree.  Its filename was
     mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3.patch

This patch was dropped because it was folded into mm-shmem-swap-fix-softlockup-with-mthp-swapin.patch

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3
Date: Wed, 11 Jun 2025 02:16:45 +0800

add comment

Link: https://lkml.kernel.org/r/20250610181645.45922-1-ryncsn@gmail.com
Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchronous swap device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c~mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3
+++ a/mm/shmem.c
@@ -2273,6 +2273,8 @@ static int shmem_swapin_folio(struct ino
 		 * If uffd is active for the vma, we need per-page fault
 		 * fidelity to maintain the uffd semantics, then fallback
 		 * to swapin order-0 folio, as well as for zswap case.
+		 * Any existing sub folio in the swap cache also blocks
+		 * mTHP swapin.
 		 */
 		if (order > 0 && ((vma && unlikely(userfaultfd_armed(vma))) ||
 				  !zswap_never_enabled() ||
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-softlockup-with-mthp-swapin.patch
mm-userfaultfd-fix-race-of-userfaultfd_move-and-swap-cache.patch
mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-improve-mthp-swapin-process.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

