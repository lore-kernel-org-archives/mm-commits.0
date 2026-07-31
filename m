Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C3533936C
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465758; cv=none; b=dOYUZRG03TtteT94mf9R0vO0k+7DJlYR7Dv/X2iKzWK7vDFl/Pw98J3jEmWU7D+RD2oKb09DXLzo1uECcUQZqgFz/OCDQwHGByWlEG65skX863De/VRrsagVD3LIxEoWLrftB9Zp25kCkFm9pUMgyAwvPTAjzzznIIM2uPkanv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465758; c=relaxed/simple;
	bh=zVL1It00UygmxAMh1iQyFgE+fF5FwONDwaM2nJHzjPc=;
	h=Date:To:From:Subject:Message-Id; b=IRNXiQog+xu07rbIgHX0D7QQzEOTP7vK4FzELMAWc6vNrMf9AtZzHgNpYPePri+Wkirv7oAVInIGzsVmNAW9uvNRTT8EwtlL+A7LQ7QCGZJ+XOkto2F5qQmx4jzp1ePYLsV3UVl4EKHrUJPqpNlHTn6fcwsJS3cbb2nEjwn3qro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sDDLmolz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sDDLmolz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71F81F000E9;
	Fri, 31 Jul 2026 02:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465756;
	bh=Ne+VpB3h9xR0Yxh576VWj3b//bPEm/LLC0GKneBZ29w=;
	h=Date:To:From:Subject;
	b=sDDLmolzdbwHRPjdOv4fH0FBG3c96y1+Zsanc35HtuO2vMPAtP5g0hO36x4Q+ZQPF
	 0OtNpAniKggQCJF4dLtVzca47XHrhE4YJlzENKYBTGYBd1kPMDuXC5LI+N0sgLsH/G
	 aCEhlR0AaBn0NA5UpX3BXGh3Xu36LmVJS28iqqbk=
Date: Thu, 30 Jul 2026 19:42:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,gourry@gourry.net,david@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gfp_types-fix-__gfp_account-gfp_kernel_account-documentation.patch removed from -mm tree
Message-Id: <20260731024236.A71F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: gfp_types: fix __GFP_ACCOUNT, GFP_KERNEL_ACCOUNT documentation
has been removed from the -mm tree.  Its filename was
     mm-gfp_types-fix-__gfp_account-gfp_kernel_account-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: gfp_types: fix __GFP_ACCOUNT, GFP_KERNEL_ACCOUNT documentation
Date: Wed, 1 Jul 2026 14:21:02 -0400

Gregory points out that these descriptions are cursed and confusing,
considering what these flags actually do.  This is mostly due to historic
implementation choices and cgroup1 baggage.  Improve the description of
their actual effects.

Link: https://lore.kernel.org/20260701182102.1586784-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/gfp_types.h~mm-gfp_types-fix-__gfp_account-gfp_kernel_account-documentation
+++ a/include/linux/gfp_types.h
@@ -136,7 +136,8 @@ enum {
  * %__GFP_THISNODE forces the allocation to be satisfied from the requested
  * node with no fallbacks or placement policy enforcements.
  *
- * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
+ * %__GFP_ACCOUNT causes the allocation to be accounted to the active
+ * cgroup context.
  *
  * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
  * mark_obj_codetag_empty() should be called upon freeing for objects allocated
@@ -320,7 +321,7 @@ enum {
  * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
  *
  * %GFP_KERNEL_ACCOUNT is the same as GFP_KERNEL, except the allocation is
- * accounted to kmemcg.
+ * accounted to the active cgroup context.
  *
  * %GFP_NOWAIT is for kernel allocations that should not stall for direct
  * reclaim, start physical IO or use any filesystem callback.  It is very
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch
mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction.patch
mm-compaction-support-non-movable-compaction-for-pageblock-requests.patch
mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch

