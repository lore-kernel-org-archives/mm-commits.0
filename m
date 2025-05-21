Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477F322D79F
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846651; cv=none; b=QevVyFwWigLtLfhG/AAL3EvuasH8VpdK+Nh7rHX24J/aLJFNFSEz8OM7T5NrHp8Y5tdZmvnLXDreBaw1eNg3y6mhKr9DziLdbb9B2fdkGpmFxfeLn4b72wEisDb+8fbW3DURnbkfKsSNIRkneSy9quP5y3yC0NlDlZbiS51B5vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846651; c=relaxed/simple;
	bh=8GQD+mbyjvMJF/5Rcc0Hivs1oQZ6SY/ixwR90PaEnKc=;
	h=Date:To:From:Subject:Message-Id; b=X8Kuum/3GlGcZuRHGhrzW9dK80xHrG/R20/eKspZZzirRu/Dj4lulL9n4z5bCSN58jOfYLJwcPF1b1QXFos6/YqOXDbK5MvjzjizMM2HvmkKeG8x3YNh4bmEuFQnjBn4Wb/reofppZHWfTKzVDddyZ2ZRi41TXg10SG/9kRkfGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hID4Tx0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hID4Tx0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B15C4CEE4;
	Wed, 21 May 2025 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846651;
	bh=8GQD+mbyjvMJF/5Rcc0Hivs1oQZ6SY/ixwR90PaEnKc=;
	h=Date:To:From:Subject:From;
	b=hID4Tx0nCcE1/cPYnQCMyLwk1RMQuMVCrJ+ezJgrZY6DMfDn+yNPND8T+yq9VNwuS
	 q1CgyL6hZvinQMV2g6HxneoeJRJbSsl0++tGEI28LvnGKI2NbgcHaSch/lzDUK5aLO
	 wEhkQyET+hRgRL6+0mpiebgp0GTdQ0svUyPjCdTU=
Date: Wed, 21 May 2025 09:57:30 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch removed from -mm tree
Message-Id: <20250521165731.18B15C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: fix wrong comment on damons_sysfs_quota_goal_metric_strs
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: fix wrong comment on damons_sysfs_quota_goal_metric_strs
Date: Mon, 12 May 2025 17:27:11 -0700

A comment on damos_sysfs_quota_goal_metric_strs is simply wrong, due to a
copy-and-paste error.  Fix it.

Link: https://lkml.kernel.org/r/20250513002715.40126-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs
+++ a/mm/damon/sysfs-schemes.c
@@ -940,7 +940,7 @@ struct damos_sysfs_quota_goal {
 	int nid;
 };
 
-/* This should match with enum damos_action */
+/* This should match with enum damos_quota_goal_metric */
 static const char * const damos_sysfs_quota_goal_metric_strs[] = {
 	"user_input",
 	"some_mem_psi_us",
_

Patches currently in -mm which might be from sj@kernel.org are


