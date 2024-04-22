Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B575E154437
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 19:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713814892; cv=none; b=T/0Sr2rsNFIM1ZSY+n64vaEEhXHtgz2BUGpCjwlZrQ27Cbl2q9J53H1wWm+8jvVtv2RGBG4H1IYr2J1Uiuw6uWElj9T2Q8WMLUHmjh0UTwSP7NZjfwK1+xgQRXZAsrqV06WOM7BbocRCkg++i2z+4TRE2wJ+hND7O35qTgmIe20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713814892; c=relaxed/simple;
	bh=Ef2DCpthIAtQHIZwitz9KaagTqA+gtWlhZHgSX4qtJM=;
	h=Date:To:From:Subject:Message-Id; b=F1Ulr2/2hPFEBDoibmndxaAC81sGOG4MnMRGG9ydsU424rhlfLMoYOt+sMWeDL8MhIcX0yg82nehLCOS8vy74PC9J8ZDqdE45iUfAo4Itmcb208N6i4L0jQYF3dMbttNdTfX8hPHcHHAqZmAcWXdFWC3h3UAOe0YJsVnaI6PnZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wX6bSB4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wX6bSB4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5244C113CC;
	Mon, 22 Apr 2024 19:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713814890;
	bh=Ef2DCpthIAtQHIZwitz9KaagTqA+gtWlhZHgSX4qtJM=;
	h=Date:To:From:Subject:From;
	b=wX6bSB4Gs08MxdXHeAtP0Ciql6ejo9RnZKvxi+aWYuZelH+P7TOqNXiL2flFPLBC3
	 0Lep0X6C6hU13vFNiGlEgDkX1g7vXjlecf6EwQPVb2cgjvT0SgWp3tqkfvwEaVf7qW
	 mSTz0n0WqJjrjrx1CS6AhQAPrtRrq2BRMucprOtg=
Date: Mon, 22 Apr 2024 12:41:30 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,tj@kernel.org,richard.weiyang@linux.alibaba.com,minchan@kernel.org,mhocko@suse.com,mgorman@techsingularity.net,jpoimboe@kernel.org,hannes@cmpxchg.org,david@redhat.com,dan.j.williams@intel.com,corbet@lwn.net,mcanal@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-shuffle-documentation-to-match-its-current-state.patch added to mm-unstable branch
Message-Id: <20240422194130.D5244C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Update shuffle documentation to match its current state
has been added to the -mm mm-unstable branch.  Its filename is
     mm-update-shuffle-documentation-to-match-its-current-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-shuffle-documentation-to-match-its-current-state.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Maíra Canal <mcanal@igalia.com>
Subject: mm: Update shuffle documentation to match its current state
Date: Mon, 22 Apr 2024 11:18:40 -0300

Commit 839195352d82 ("mm/shuffle: remove dynamic reconfiguration") removed
the dynamic reconfiguration capabilities from the shuffle page allocator. 
This means that, now, we don't have any perspective of an "autodetection
of memory-side-cache" that triggers the enablement of the shuffle page
allocator.

Therefore, let the documentation reflect that the only way to enable
the shuffle page allocator is by setting `page_alloc.shuffle=1`.

Link: https://lkml.kernel.org/r/20240422142007.1062231-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   10 ++++------
 mm/Kconfig                                      |    7 +++----
 2 files changed, 7 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-update-shuffle-documentation-to-match-its-current-state
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4176,13 +4176,11 @@
 
 	page_alloc.shuffle=
 			[KNL] Boolean flag to control whether the page allocator
-			should randomize its free lists. The randomization may
-			be automatically enabled if the kernel detects it is
-			running on a platform with a direct-mapped memory-side
-			cache, and this parameter can be used to
-			override/disable that behavior. The state of the flag
-			can be read from sysfs at:
+			should randomize its free lists. This parameter can be
+			used to enable/disable page randomization. The state of
+			the flag can be read from sysfs at:
 			/sys/module/page_alloc/parameters/shuffle.
+			This parameter is only available if CONFIG_SHUFFLE_PAGE_ALLOCATOR=y.
 
 	page_owner=	[KNL,EARLY] Boot-time page_owner enabling option.
 			Storage of the information about who allocated
--- a/mm/Kconfig~mm-update-shuffle-documentation-to-match-its-current-state
+++ a/mm/Kconfig
@@ -333,10 +333,9 @@ config SHUFFLE_PAGE_ALLOCATOR
 
 	  While the randomization improves cache utilization it may
 	  negatively impact workloads on platforms without a cache. For
-	  this reason, by default, the randomization is enabled only
-	  after runtime detection of a direct-mapped memory-side-cache.
-	  Otherwise, the randomization may be force enabled with the
-	  'page_alloc.shuffle' kernel command line parameter.
+	  this reason, by default, the randomization is not enabled even
+	  if SHUFFLE_PAGE_ALLOCATOR=y. The randomization may be force enabled
+	  with the 'page_alloc.shuffle' kernel command line parameter.
 
 	  Say Y if unsure.
 
_

Patches currently in -mm which might be from mcanal@igalia.com are

mm-update-shuffle-documentation-to-match-its-current-state.patch

