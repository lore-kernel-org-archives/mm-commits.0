Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD8714533E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291719; cv=none; b=osBluGNVtvgwL61t0s7X+PfT5HI2gTBb6Pghzofu5O3gMEpIz7QMFz0d5S2NvCW1B8cyWmjmB6/o9NAKwy3PGhlPlc55h1Ee1Tj5EC2IW6F+Gy2u1onNlJ+gpQFq244FCEUWCQF+Ejo19Sm4OPgcNcSc08AXYPY0iq82m9kMVBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291719; c=relaxed/simple;
	bh=b9oqFh4Ju+p/ggLwpVBAAcOcrSy4yrBnZ4pu4jq8ODw=;
	h=Date:To:From:Subject:Message-Id; b=QG18OOm3YAoVYqy3f55K3Gw3c1DfHCWMgAX9GmErOuSDVkTbj4k0kjGKjXx9j0KRB0bTMPKhNKUxywe3JHYVEBrPYX66MpjAlgkTeKX3aMhZQXhbAE8uVwiZ6+dLf5MnBYT6RUVVGY7BFxs7KMY05n15vUG/JbECFTInnocZ27E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eefGuOuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eefGuOuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B825EC32782;
	Tue, 25 Jun 2024 05:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291718;
	bh=b9oqFh4Ju+p/ggLwpVBAAcOcrSy4yrBnZ4pu4jq8ODw=;
	h=Date:To:From:Subject:From;
	b=eefGuOuhMEkf8a/f8qHezCHTsiZz7sIEg1Tkk64fjoX208z0WJsdAKiqQNMyG6Lt2
	 xQwxr0V+bDfoWtSGtlNLBCgMY0UNXVhBzr6XV8a96E54MWYeVF9aPj7/dCOtNjxucL
	 caDsPnYA15zPrhSbjfcsk7x4FiSz72U/4wkOmMvE=
Date: Mon, 24 Jun 2024 22:01:58 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch removed from -mm tree
Message-Id: <20240625050158.B825EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: correct comment in me_swapcache_dirty
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: correct comment in me_swapcache_dirty
Date: Wed, 12 Jun 2024 15:18:35 +0800

Dirty swap cache page could live both in page table (not page cache) and
swap cache when freshly swapped in.  Correct comment.

Link: https://lkml.kernel.org/r/20240612071835.157004-14-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-correct-comment-in-me_swapcache_dirty
+++ a/mm/memory-failure.c
@@ -1126,7 +1126,7 @@ static int me_pagecache_dirty(struct pag
  * Clean and dirty swap cache.
  *
  * Dirty swap cache page is tricky to handle. The page could live both in page
- * cache and swap cache(ie. page is freshly swapped in). So it could be
+ * table and swap cache(ie. page is freshly swapped in). So it could be
  * referenced concurrently by 2 types of PTEs:
  * normal PTEs and swap PTEs. We try to handle them consistently by calling
  * try_to_unmap(!TTU_HWPOISON) to convert the normal PTEs to swap PTEs,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


