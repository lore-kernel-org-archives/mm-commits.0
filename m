Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D0710F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744840; cv=none; b=ZHQDUD3aAsqP6p8qKmw/dx4wsASd37Jaxl7N5lpyNar5SzlSJAzP8aqGdtOvT2DE+YftpCdhlowB/SO3a/XdTnzFnRC51Vk8F7pu/IkTKB3wqHwlK7xei8I+a++DxpJq29lcuWa2iL/rrUk+csClRqPV3AUGofWT4SI8JOSlaC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744840; c=relaxed/simple;
	bh=mGC/oowav+53LIOgDuX174c0Fpx+WBgyV0X66/7xa50=;
	h=Date:To:From:Subject:Message-Id; b=XYG/yVCCsuJXz+phHt3M4kE2byDBvo+V+eb4kdAELruYrUL/cIpQ/NEeEClnpNSArVJtSCMPECY5chSJBQEDScs5HGG1yiji1J/S6rdvMOCrRh8GdwItkwwHYW17hp1Mdj6XVjjCLkPoCBMo/u8tTooXVPhhQDsv7wwP6FLTGmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iAU3fcaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iAU3fcaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B301C4CEF7;
	Sun, 29 Mar 2026 00:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744840;
	bh=mGC/oowav+53LIOgDuX174c0Fpx+WBgyV0X66/7xa50=;
	h=Date:To:From:Subject:From;
	b=iAU3fcaYv4FAF6cFq0bOjF25x4aXurAAeftRtueeI0h7WkD1rNKXp2CO1G9jSd8PN
	 4Eo/yLEDlZO09Wun5bYIT+yrQW/1LIyz1dYx1U0s3MmB39UKFHRMbo7sv72ZfDOneO
	 OHws8uWikoob1U2Jj1xrcvjtP/foStqd/gBVOXWM=
Date: Sat, 28 Mar 2026 17:40:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch removed from -mm tree
Message-Id: <20260329004040.2B301C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damn/lru_sort: fix intervals autotune parameter name
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damn/lru_sort: fix intervals autotune parameter name
Date: Sat, 7 Mar 2026 11:53:53 -0800

The section name should be the same as the parameter name.  Fix it.

Link: https://lkml.kernel.org/r/20260307195356.203753-6-sj@kernel.org
Fixes: ed581147a417 ("Docs/admin-guide/mm/damon/lru_sort: document intervals autotuning")
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: wang lian <lianux.mm@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -91,8 +91,8 @@ increases and decreases the effective le
 
 Disabled by default.
 
-Auto-tune monitoring intervals
-------------------------------
+autotune_monitoring_intervals
+-----------------------------
 
 If this parameter is set as ``Y``, DAMON_LRU_SORT automatically tunes DAMON's
 sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

