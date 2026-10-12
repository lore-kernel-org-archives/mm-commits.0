Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB6413A258
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 01:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791769823; cv=none; b=k2WOO6n9mbL/vHzVhZhnzwTstqy26hc7FqHS1I1JtYg7075AsMucq0spYUzq6LTUH3ZrkeBHzBsWeuBaDYmkk1vb/IkRMiTeLwsF5AlprSEXW9G3EPijfDLRX0CwvLGwtlLTQwodA6MWh4m5tGElKGporZerkL2HmWhFTxrxapU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791769823; c=relaxed/simple;
	bh=jKCR4KjICporq+A9zPifdU7bnGnjnkNNYZbVema9E1A=;
	h=Date:To:From:Subject:Message-Id; b=pjYSnaR9eRnElMkiVa+0bJDwzREg+HwlJSvdWCNTWyjvB1wHbyYU7RCZk+l33Ur2cPZACOyVPTryNJN9byhYl6KjP0YIAATG/On0KlnpbtLuw1is+zrFRxmZXT/BAgeZxssSupth4lQaYyy+y2k8xhOamd+fDuBFX0bQtqDQN7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qOTipBlT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qOTipBlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77F71F0089B;
	Mon, 12 Oct 2026 01:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791769822;
	bh=IitohwLBCpkb7RrhKQI9TDBbD146E0t7F9TqIYiyKcA=;
	h=Date:To:From:Subject;
	b=qOTipBlTKPX1nyGOAnYCDKgp5cA7NGqXbsQxk7KZKjXoH3cMcrlHpTjRS6K3zN4Fg
	 zYgPjUXmSX5j8i3d4ksG5EihBPorlRk3ne+tyyiNUx4yhhugWhthD7pss8znvOOG0f
	 l02/O9pVOXeexyJTBYgIDnKn+nUgB7Bf69giVBOU=
Date: Sun, 11 Oct 2026 18:50:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch removed from -mm tree
Message-Id: <20261012015021.E77F71F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix
has been removed from the -mm tree.  Its filename was
     mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch

This patch was dropped because it was folded into mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix
Date: Thu Sep 17 04:39:24 PM PDT 2026

fix comment, per Zi Yan.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ksm.c~mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix
+++ a/mm/ksm.c
@@ -1617,7 +1617,7 @@ static int try_to_merge_with_ksm_page(st
 
 	/*
 	 * We can consider the VMA only while still holding the mmap lock,
-	 * so lock, so reference the anon rmap and calculate the linear
+	 * so reference the anon rmap and calculate the linear
 	 * page index early, before stable_tree_append(). If anything goes
 	 * wrong that prevents the rmap_item from being added to the
 	 * stable_tree, break_cow() will clean it up.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-selftests-add-shmem-into-memory-failure-test-fix.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

