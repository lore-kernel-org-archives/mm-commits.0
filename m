Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3033E145346
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 23:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754521880; cv=none; b=re+zXJJ5j82bPL4FHpDRbI0y1qUmDaMg/v22DzlzSlDoWdCmwZdITHlX5rt+LXxBodfsQxj0DB07A/FSkRv//TICf59QTAEa9irTP3jSsN3ovHdlNbiRSRhZOhmLPuwgBkCu9nCnIcpOb2QKDSfZKvtrar3UoxlbJRvNU7IqAEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754521880; c=relaxed/simple;
	bh=PM/djFtGtnEVElb8cWmicdo3IRepuB64cjUnlElEzD0=;
	h=Date:To:From:Subject:Message-Id; b=DX3CiKmpqcFf03fIiCqaINE0kmEZCe0Z7YLuXmSBWf2PJZ6Qyqe5FAPaqhk8Zr1IDuQZco5UN7Vw4lx1r97LKclnjQ1wjO+m4B/Wi8hhaLCuOLCgqMqPTqFtnJN7SiVFJzbohLLAx6dKA1SjqsIjLnUDJ/G342bVVWghqXfTNjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jdmUZ9YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jdmUZ9YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A47C4CEE7;
	Wed,  6 Aug 2025 23:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754521876;
	bh=PM/djFtGtnEVElb8cWmicdo3IRepuB64cjUnlElEzD0=;
	h=Date:To:From:Subject:From;
	b=jdmUZ9YAxEYAuJT5gmu0EWCOAv2cmI+wSy21Cq5fUOu5x12gb9ZT1RsYAbTl7kaNJ
	 ZI3Qub0s9OWufKrRZ33QA0Kp6SSbFFYzR8QQQAOAXa+JErCzJC9GoJNCYxDMQax9LC
	 7llD3FLjhkzuPByceMf+bGU67Rviv4n1RjDjR2O8=
Date: Wed, 06 Aug 2025 16:11:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,sj@kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-clarify-what-zone-reclaim-means-fix.patch added to mm-unstable branch
Message-Id: <20250806231116.93A47C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mempolicy-clarify-what-zone-reclaim-means-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicy-clarify-what-zone-reclaim-means-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-clarify-what-zone-reclaim-means-fix.patch

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
Subject: mempolicy-clarify-what-zone-reclaim-means-fix
Date: Wed, 6 Aug 2025 06:43:52 -0700

remove the reference to the vm.zone_reclaim_mode sysctl as an ABI

Link: https://lkml.kernel.org/r/20250806134404.2000234-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mempolicy.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/mempolicy.h~mempolicy-clarify-what-zone-reclaim-means-fix
+++ a/include/uapi/linux/mempolicy.h
@@ -72,8 +72,8 @@ enum {
  * Fallback allocations on the next candidates in the zonelist are considered
  * when reclaim fails to free up enough memory in the current node/zone.
  *
- * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
- * ABI.  New bits are OK, but existing bits should not be changed.
+ * These bit locations are exposed in the vm.zone_reclaim_mode sysctl.
+ * New bits are OK, but existing bits should not be changed.
  */
 #define RECLAIM_ZONE	(1<<0)	/* Enable zone reclaim */
 #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mempolicy-clarify-what-zone-reclaim-means.patch
mempolicy-clarify-what-zone-reclaim-means-fix.patch

