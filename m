Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A7B27FD71
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122665; cv=none; b=M8iIqSKCHjw5TOItK6d2Wd242Pz9BerNthuKlfNUo/mmMSr9ALdNqBzcg6eFCK2pwpmsLORHsMAN/JT4R3TqHxvrWjsr0JwVJhiJ0gScOPtvBXtfn1y4EKmxpL6CwpPVgTnQXom2M4X2ZtEZpQ1I3V2B1mmz4Oi7ZjkltBb40w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122665; c=relaxed/simple;
	bh=QkPJvnsUxMTBbJCBzTxnd7uu3KIvJVGLp22lyOioHtQ=;
	h=Date:To:From:Subject:Message-Id; b=O3mVCL+Eu3vF+U56Tags/InVRJPIYgShq4CoOQl8qsYNuNif25QyZcKrfvJ1U3ik2ah/2d5gPbcjvhcqkSHW/qsb+5Q6P3OyQMteXnH1sIY8onoVGmfkMfYPaiKQiJj8W2YbOHj9Zj9vQnfnSAyLOjXF8cir5+wSexypgk2/fXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g92gE5TW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g92gE5TW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867F1C4CEE3;
	Thu, 10 Jul 2025 04:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122664;
	bh=QkPJvnsUxMTBbJCBzTxnd7uu3KIvJVGLp22lyOioHtQ=;
	h=Date:To:From:Subject:From;
	b=g92gE5TWXr+qcawm8krJQOdLLw+JyPLLFnTsDx7rYBCxgGtwRvH+Doo3lJ3hb1pIK
	 ynhAr17rdgzTWNwxtwLySpi8kY9LVu98Xv66xc9nJMe8Rp3RXnxJD+UUCi7RJM1w6Y
	 lyqcYC6pZkMUnPU1Zie3t2Nz8sgNcOHTCUbqwVuc=
Date: Wed, 09 Jul 2025 21:44:23 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch removed from -mm tree
Message-Id: <20250710044424.867F1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-damon-sysfs-schemes-decouple-from-damos_action-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch

This patch was dropped because it was folded into mm-damon-sysfs-schemes-decouple-from-damos_action.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-sysfs-schemes-decouple-from-damos_action-fix
Date: Fri Jun 27 12:56:28 PM PDT 2025

make damos_sysfs_action_names static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506271655.b8yfEZIT-lkp@intel.com/
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-decouple-from-damos_action-fix
+++ a/mm/damon/sysfs-schemes.c
@@ -1619,7 +1619,7 @@ struct damos_sysfs_action_name {
 	char *name;
 };
 
-struct damos_sysfs_action_name damos_sysfs_action_names[] = {
+static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
 	{
 		.action = DAMOS_WILLNEED,
 		.name = "willneed",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

