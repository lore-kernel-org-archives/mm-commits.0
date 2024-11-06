Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D851C17E010
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854726; cv=none; b=AqDkItR+RNkgoJRwjHi8Yffa9Ouz+RLw89Fh/wgn77skfkLMKUU33kRccJyksRx4Gdxvceqg7OBDL75Ii/wu5TL1funtQI4P95dKDylGU4RBFzbP79ya51t47icJv9TAvEbF7AjDkgNCXUZlbG52e7N3T5Z4LXHdeqTk9SWrc1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854726; c=relaxed/simple;
	bh=A9Y3g+xQ0cpIsQwF7s78137SGJ8zNEfVXWuJgRo3ukI=;
	h=Date:To:From:Subject:Message-Id; b=uo6Ml4pE0Vj7fdDCpIMiBT1jCr0O8uXJxutccRARwA0i4E8lXHshq/tQI7b91Xyaa1m/NQKjsV/s0jvIaAjzNFe453sZSIih+FXs6/oU8/iGiTtmNiCd46yaXnHjHstorgGvN86wRo9/yrQS38GhYSQbQSFAtI9nizq6BFrqv+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CizKX53l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CizKX53l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCF1C4CECF;
	Wed,  6 Nov 2024 00:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854726;
	bh=A9Y3g+xQ0cpIsQwF7s78137SGJ8zNEfVXWuJgRo3ukI=;
	h=Date:To:From:Subject:From;
	b=CizKX53l8amWTACw+bTEx4ASeiMf5BFCYXbiIGtGbXHdqNBCWYAZ4Y2mYOkIvdTMC
	 Y0VAi7mWzBfiFkqu5qd5EfjBjBl/f/2oWekboxAPnD2dRK4ptdbRfOSWwo2jpIg2sj
	 n9CX6zBbD6KR6HEUOT/TyVQfJNdXI2Kv8ckuRkk0=
Date: Tue, 05 Nov 2024 16:58:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch removed from -mm tree
Message-Id: <20241106005846.5CCF1C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc: assert_pte_locked() use pte_offset_map_ro_nolock()
has been removed from the -mm tree.  Its filename was
     powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: powerpc: assert_pte_locked() use pte_offset_map_ro_nolock()
Date: Thu, 26 Sep 2024 14:46:15 +0800

In assert_pte_locked(), we just get the ptl and assert if it was already
held, so convert it to using pte_offset_map_ro_nolock().

Link: https://lkml.kernel.org/r/42559e042eb6fc3129a40f710d671712030646b4.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/pgtable.c~powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock
+++ a/arch/powerpc/mm/pgtable.c
@@ -398,7 +398,7 @@ void assert_pte_locked(struct mm_struct
 	 */
 	if (pmd_none(*pmd))
 		return;
-	pte = pte_offset_map_nolock(mm, pmd, addr, &ptl);
+	pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
 	BUG_ON(!pte);
 	assert_spin_locked(ptl);
 	pte_unmap(pte);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


