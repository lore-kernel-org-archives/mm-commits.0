Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C56DDDC
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 01:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740275097; cv=none; b=jqGlmY/TARCVKeYTY94/JU+P0/0KfX9zZVPa6sc+gRG0TCtd03OrzWKNyjfvmvx/ZWOMUkz4yl9GZGKsDy+aISt0F4Ugp5HBYAJDNULCMijqXSK47/hz3YqT/sjMZO3bK8OiiP52NvTDzwklqemwwn+lNiMPF471qEYmeSPMPPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740275097; c=relaxed/simple;
	bh=+rBlQ+oWX0soWLSCLvPYohm1ztizh3QIjYYrysTiARc=;
	h=Date:To:From:Subject:Message-Id; b=l0dnK6MisE59q75RBm2MknTpCv2wxOMlTbx6xp0yrsCWUaBHUulLeYSkjIQySMt+hVo0Ftlo9/zf/1vO+RowQffgs5WMr+72qkB/TExsWZSTx3zEhTroMVOEd7KF96y8uNzmd0T5fedNlxgJ17r6l/TZ+6bubVyyrq+99FZrfXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CMMeSZ6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CMMeSZ6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCE4C4CED1;
	Sun, 23 Feb 2025 01:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740275097;
	bh=+rBlQ+oWX0soWLSCLvPYohm1ztizh3QIjYYrysTiARc=;
	h=Date:To:From:Subject:From;
	b=CMMeSZ6XcWgIJro1fW6xUykA2WNLV6ZET3GAAWDqp+REisuJZOke0zvx+omHGaete
	 WDaU/78x5evUE9PInklX7E21QvnyXp4PK2mMAzuENFY5bUs6NM8u5sOL6pvXOvUYgu
	 Wfk4Kjpg1VwHjDquYpRA3VjRWyklODddTapsdHpU=
Date: Sat, 22 Feb 2025 17:44:56 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-avoid-bug_on-in-relocate_cluster.patch added to mm-hotfixes-unstable branch
Message-Id: <20250223014457.4FCE4C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: avoid BUG_ON in relocate_cluster()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-avoid-bug_on-in-relocate_cluster.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-avoid-bug_on-in-relocate_cluster.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: avoid BUG_ON in relocate_cluster()
Date: Sun, 23 Feb 2025 00:08:47 +0800

If allocation is racy with swapoff, we may call free_cluster for cluster
already in free list and trigger BUG_ON() as following:

Allocation                        Swapoff
cluster_alloc_swap_entry
 ...
 /* may get a free cluster with offset */
 offset = xxx;
 if (offset)
  ci = lock_cluster(si, offset);

                                  ...
                                   del_from_avail_list(p, true);
                                    si->flags &= ~SWP_WRITEOK;

  alloc_swap_scan_cluster(si, ci, ...)
   ...
   /* failed to alloc entry from free entry */
   if (!cluster_alloc_range(...))
    break;
   ...
   /* add back a free cluster */
   relocate_cluster(si, ci);
    if (!ci->count)
     free_cluster(si, ci);
      VM_BUG_ON(ci->flags == CLUSTER_FLAG_FREE);

To prevent the BUG_ON(), call free_cluster() for free cluster to move the
cluster to tail of list.

Check cluster is not free before calling free_cluster() in
relocate_cluster() to avoid BUG_ON().

Link: https://lkml.kernel.org/r/20250222160850.505274-4-shikemeng@huaweicloud.com
Fixes: 3b644773eefda ("mm, swap: reduce contention on device lock")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-avoid-bug_on-in-relocate_cluster
+++ a/mm/swapfile.c
@@ -653,7 +653,8 @@ static void relocate_cluster(struct swap
 		return;
 
 	if (!ci->count) {
-		free_cluster(si, ci);
+		if (ci->flags != CLUSTER_FLAG_FREE)
+			free_cluster(si, ci);
 	} else if (ci->count != SWAPFILE_CLUSTER) {
 		if (ci->flags != CLUSTER_FLAG_FRAG)
 			move_cluster(si, ci, &si->frag_clusters[ci->order],
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-avoid-losting-cluster-in-swap_reclaim_full_clusters.patch
mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch
mm-swap-avoid-bug_on-in-relocate_cluster.patch
mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch
mm-swap-correct-comment-in-swap_usage_sub.patch
mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

