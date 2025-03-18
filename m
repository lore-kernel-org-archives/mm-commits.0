Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EE51DB951
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274601; cv=none; b=i55iupns5OLzVH/Ymi1RfiksBhrTDdlJD3MTqMDtHpelV//bAivUKpWTZYQCAzGx8Q7ISLpStLGXP/Jw/Z75CvLgVLhsvUrkIMkOwCyyzG8mmt2k+sJc792+teAjvsOM3uZ1XgK/EdXyadATVYDOX7aY6u6ImjZ0JfiL984OHNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274601; c=relaxed/simple;
	bh=lUdD3Kk7cMOLavOQPauiuviOdouylMrFWtFVMtRF42k=;
	h=Date:To:From:Subject:Message-Id; b=TQFLoL1429YW3t/d3KrK53aeYEHnfRClhp8H6Cc4gzHBm2eVBXHTFZIuotYxHLvfJvhfmLpznaboB6Gk2YJH5jDK8ZY3vS24W04QUWvn3ZkUkpcs9kZyTjqvfHBYtP7pnMwSNiDc2vyay2MXgWF1EzZBCcwnQcafUfVa0WuuXUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lLMR5ee+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lLMR5ee+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE0AC4CEDD;
	Tue, 18 Mar 2025 05:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274601;
	bh=lUdD3Kk7cMOLavOQPauiuviOdouylMrFWtFVMtRF42k=;
	h=Date:To:From:Subject:From;
	b=lLMR5ee+ySjkaRNQD/gTDNv7zW91ymQ0ieupshnwYTv6tgIYdJZjGC2/lMDXH4K1h
	 kuIH4brGvWwE/7LSqEt8gEXbn2thXLQ8LsrFSDKm1M42//T0EDMQHnCSdNJHMHQPPN
	 UvV1vb3E+c+63P6iKRpC/eAPzngo+bjsyTV8JJeQ=
Date: Mon, 17 Mar 2025 22:10:01 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch removed from -mm tree
Message-Id: <20250318051001.9CE0AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: remove obsolete comment for damon_sysfs_schemes_clear_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: remove obsolete comment for damon_sysfs_schemes_clear_regions()
Date: Thu, 6 Mar 2025 09:59:03 -0800

The comment on damon_sysfs_schemes_clear_regions() function is obsolete,
since it has updated to directly called from DAMON sysfs interface code. 
Remove the outdated comment.

Link: https://lkml.kernel.org/r/20250306175908.66300-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions
+++ a/mm/damon/sysfs-schemes.c
@@ -2341,7 +2341,6 @@ void damos_sysfs_populate_region_dir(str
 	}
 }
 
-/* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
 int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes)
 {
_

Patches currently in -mm which might be from sj@kernel.org are


