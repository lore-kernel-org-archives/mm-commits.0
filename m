Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5235C312832
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 22:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782946598; cv=none; b=sl2FTnBMRnsdvrUmw1Lk+grUikpEmdPxDyytgPfpnPeAAYy/XevmOCr+r+b8ef2zkXFV0i8AuRpKwdpgq7agUwbf/GT6O9ILLnD/b3QonXCtHyoK3s2jjTQEIJ+TsWZhAnqqIDnrMZPpC8S28ZYB5k/fcKm2XmfymQ3jn+h43HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782946598; c=relaxed/simple;
	bh=HqbwWydfSg1o4eOsGT3l6SnDnhOkqnqeKlcx6A532l0=;
	h=Date:To:From:Subject:Message-Id; b=IrR9CG6bWY3ptoIUNRBLUeN9kYEHETp+Iu6RMT4BS8S4Wy5C5QZM+EXHc80bf8KoqVbgVxcvaVpj8/emPymxb7H6d0Lrxe8uG3vAZ5K6TE5T6kosMQhPjA8ZN1rsqrn5XfftLqCxuUDy1+EqrFLiBKzbx5q0rW76GHAYZ1LcNng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TxMBSPnX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TxMBSPnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C553F1F000E9;
	Wed,  1 Jul 2026 22:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782946596;
	bh=w6s8/cZQcYAZvyhdh/wTj6ghu2CGVSWqvU6bICc9A8c=;
	h=Date:To:From:Subject;
	b=TxMBSPnXhwZlZQJ1FnaqiCPw2Z4GqC0/BjxjV1AR4NfLLyD2Dhz5KIouHQCcTYu/W
	 8qzR1lrQSRvweahcFW9tfzkm6ps9lkyZp/QoQNYwFQFthO5d0jYpQuyLfMC7oYzUbV
	 6JPnMhwW7iLJPpzFvysDi1cakSkHbhNfXvphQq90=
Date: Wed, 01 Jul 2026 15:56:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,gourry@gourry.net,david@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gfp_types-fix-__gfp_account-gfp_kernel_account-documentation.patch added to mm-new branch
Message-Id: <20260701225636.C553F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: gfp_types: fix __GFP_ACCOUNT, GFP_KERNEL_ACCOUNT documentation
has been added to the -mm mm-new branch.  Its filename is
     mm-gfp_types-fix-__gfp_account-gfp_kernel_account-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gfp_types-fix-__gfp_account-gfp_kernel_account-documentation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
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
mm-gfp_types-fix-__gfp_account-gfp_kernel_account-documentation.patch

