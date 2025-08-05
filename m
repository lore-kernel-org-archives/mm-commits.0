Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BA1239591
	for <mm-commits@vger.kernel.org>; Tue,  5 Aug 2025 21:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754428633; cv=none; b=r9pkLRArqJ+gWqt8sKmCBWzWY6SG4yWhZVINk6YHzz2z28O3/yhKHHhFBgdA8yRc+jNezD5efgXVTLS+Ez6zktSSeVQmSle1OZNBivo2M57g/kp6/2skrJIguz3V9Q91DyM/MQENVUgSF3dr9KJLyu0yfriizyXNp2WFDbpUD50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754428633; c=relaxed/simple;
	bh=RUsiDw97ALR3dPlckdN6vmR9SxmyruekHzV+bVMluNE=;
	h=Date:To:From:Subject:Message-Id; b=ErPwORQ7afds1R7ah++jhFIx9+WCa1Nn+f4eUfuT1oM3BhIFkntn/nIsEooEh5yonH5SEuATLsVsH6mPWXi+TqwHTm9uZjwHeqnvPszelx60kdyPAHRZZuQx5jjKnur5gto3Yhou8g5uRM6y/2rszhCg5mQlVaK5pmge+cCa4JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FxsXGYhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FxsXGYhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506E5C4CEF0;
	Tue,  5 Aug 2025 21:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754428632;
	bh=RUsiDw97ALR3dPlckdN6vmR9SxmyruekHzV+bVMluNE=;
	h=Date:To:From:Subject:From;
	b=FxsXGYhVRDx4uoTBsyCLYQOQX7WeHhoujMpMr4Julr8fCz6/lDyPIxCtOWt7LfQRv
	 VfDBd727TSNSrZyPtqLD/OPimkZ7vJ2XDlkL1e9IxO2Cu18HCzuaBGkFLX2J1/NoA4
	 IbEZURPza5dGU7c6hyx5Y4DpyKZ9NALyEYjJCOEw=
Date: Tue, 05 Aug 2025 14:17:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,sj@kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-clarify-what-zone-reclaim-means.patch added to mm-unstable branch
Message-Id: <20250805211712.506E5C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mempolicy: clarify what zone reclaim means
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicy-clarify-what-zone-reclaim-means.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-clarify-what-zone-reclaim-means.patch

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mempolicy: clarify what zone reclaim means
Date: Tue, 5 Aug 2025 13:50:47 -0700

The zone_reclaim_mode API controls the reclaim behavior when a node runs
out of memory.  Contrary to its user-facing name, it is internally
referred to as "node_reclaim_mode".

This can be confusing.  But because we cannot change the name of the API
since it has been in place since at least 2.6, let's try to be more
explicit about what the behavior of this API is.

Change the description to clarify what zone reclaim entails, and be
explicit about the RECLAIM_ZONE bit, whose purpose has led to some
confusion in the past already [1] [2].

While at it, also soften the warning about changing these bits.

[1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
[2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/

Link: https://lkml.kernel.org/r/20250805205048.1518453-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mempolicy.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/mempolicy.h~mempolicy-clarify-what-zone-reclaim-means
+++ a/include/uapi/linux/mempolicy.h
@@ -66,10 +66,16 @@ enum {
 #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
 
 /*
+ * Enabling zone reclaim means the page allocator will attempt to fulfill
+ * the allocation request on the current node by triggering reclaim and
+ * trying to shrink the current node.
+ * Fallback allocations on the next candidates in the zonelist are considered
+ * when reclaim fails to free up enough memory in the current node/zone.
+ *
  * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
- * ABI.  New bits are OK, but existing bits can never change.
+ * ABI.  New bits are OK, but existing bits should not be changed.
  */
-#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
+#define RECLAIM_ZONE	(1<<0)	/* Enable zone reclaim */
 #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
 #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
 
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mempolicy-clarify-what-zone-reclaim-means.patch

