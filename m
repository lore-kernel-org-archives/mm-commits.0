Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6151415688E
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 20:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713991087; cv=none; b=qjVJ34lU6bhL8rNJvH+xPae1UcuPGAfbLlqoT9UC9Dw63IXIrJ1/xxU9Q1JFOZvMXTQDndu5vpn+Rg9i3bzvO27mp1wajKev9kYprk1IuKOFv00SkH5Vdt2VAnaTkf2g8WK85Sh5vrJSfsqLH0pg5GEh3YSzLwuhXrEOVUfkf40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713991087; c=relaxed/simple;
	bh=yCC4yq3mysyzCD7zh0deaL6vGPRPPtAKXzcJllRPr0w=;
	h=Date:To:From:Subject:Message-Id; b=UfMR41UsZy/jc4zmipEUaeQeyCwlJVCNf593Snmx3P4N2KZDWB3ged3BOVmZvJRZTuH75y5sPSrYwCZ+JB3HD2ADw/VL6N1QBn7/t1E9K/UFLjlJJoxvY4kqDW1mAA0Gp6cyob+OL/ddMGuebnVneiAjtXGIl/Tq+yulL8q3aP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ISD+Fbwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ISD+Fbwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7341C113CD;
	Wed, 24 Apr 2024 20:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713991086;
	bh=yCC4yq3mysyzCD7zh0deaL6vGPRPPtAKXzcJllRPr0w=;
	h=Date:To:From:Subject:From;
	b=ISD+FbwbQDGtI8uQPNK3vdG+/1XjBj8PjiBvgcuT8bApY3s9CQkmm03DuaIzeS6sL
	 Hf+NcDjymAgzOwmCWkChmdnkyvG6RD7K9TAE2GdHzMnxBT+H3fyC7oDj9lF2d0it4U
	 k3bNqpUEq/UkHYfUg1OOqVtpUsbyi1g56Rgs1H7A=
Date: Wed, 24 Apr 2024 13:38:06 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,tj@kernel.org,richard.weiyang@linux.alibaba.com,minchan@kernel.org,mhocko@suse.com,mgorman@techsingularity.net,jpoimboe@kernel.org,hannes@cmpxchg.org,david@redhat.com,dan.j.williams@intel.com,corbet@lwn.net,mcanal@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-update-shuffle-documentation-to-match-its-current-state.patch removed from -mm tree
Message-Id: <20240424203806.D7341C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: Update shuffle documentation to match its current state
has been removed from the -mm tree.  Its filename was
     mm-update-shuffle-documentation-to-match-its-current-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


