Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29503B71B1
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068168; cv=none; b=OTADzDn/Os5cBhFJhjKE/2yVBq+EPl9SHL60/FMttI01inNvsbaueDiylHK3PrlitJBQP6eJEvvkK0GHXY9EXV3EJ9cg4CSnPnEglC6XjZEriDletzW+zH+47AjG9QW9jf/s23q3HNS96uLZbxPyNcsoYPVI3AFEe2kbWqJpeNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068168; c=relaxed/simple;
	bh=Kuu7piphHYmggoqAADkObYQoBLJE7RlUVGnzWFAe+I8=;
	h=Date:To:From:Subject:Message-Id; b=SNxFnTXivFpz9xQvKsbFEEjpsGRv0muoTGeMaZdFmuyeM1Ca52ujY08vpKPSOhfKIpJmTNuQiFDpwNta4uG5YU/IV5ncU6UaqLLNF452vVrxaURACrLTqbXKQ7wtSUxvCb258PrSMHeUSxO2pNbZQOYxB1v0ZkuV5plNAp5fgCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=waR2yzzj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="waR2yzzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794FF1F000E9;
	Fri,  7 Aug 2026 02:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068166;
	bh=H1D6hZr0xKCkjC24TyDf+Xt4Kwh17ABBLh8wRPVV+Lc=;
	h=Date:To:From:Subject;
	b=waR2yzzjGdgTOPlYZrYKkJdo7PPX6pod76Fzt7rrVk1yCJv3dE0kCHCqe0MhT/5aw
	 OB7Y3yAU5C/UHhpuVETRRJMCUVo89u/jgrvl6YTbW5BB9OKNd6hbssUiyOy0G99tDt
	 +aUTMCvirlsfS2/q8B24b2SUqD0+TomU4O29q4fI=
Date: Thu, 06 Aug 2026 19:02:46 -0700
To: mm-commits@vger.kernel.org,liuyongqiang13@huawei.com,hughd@google.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,yujiacheng3@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn.patch removed from -mm tree
Message-Id: <20260807020246.794FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: downgrade final i_blocks check in shmem_evict_inode() to pr_warn()
has been removed from the -mm tree.  Its filename was
     mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiacheng Yu <yujiacheng3@huawei.com>
Subject: mm/shmem: downgrade final i_blocks check in shmem_evict_inode() to pr_warn()
Date: Tue, 28 Jul 2026 09:10:14 +0000

shmem_evict_inode() ends with WARN_ON(inode->i_blocks) as a final
consistency check of shmem's block accounting.  When it fires, the
inode-local counters die with the inode; what may linger is a small
residue in accounting kept outside the inode, such as per-mount or
per-user charges.  No data is lost, and no corruption follows.

On kernels running with panic_on_warn=1, this accounting inconsistency
escalates to a full machine panic, which is disproportionate to the
impact.

Downgrade the WARN_ON() to a pr_warn() that reports the inode together
with its accounting counters (i_blocks, alloced, swapped, nrpages),
keeping the inconsistency visible in the logs.

The accounting bugs this check has caught over the years -- the swapout
race described in commit 0f3c42f522dc ("tmpfs: change final i_blocks BUG
to WARNING") and the error recovery race fixed in commit 267a4c76bbdb
("tmpfs: fix shmem_evict_inode() warnings on i_blocks") -- are real and
should still be fixed; this change only removes the disproportionate
escalation.

One way to hit this race: soft_offline_in_use_page()'s fast path drops a
clean, unmapped shmem folio via mapping_evict_folio(), where the
xas_store() and the nrpages decrement are not atomic against a concurrent
shmem_evict_inode(); the final shmem_recalc_inode() can then read the
pre-decrement nrpages, compute freed = 0, and leave one page charged. 
Same class as the races in 0f3c42f522dc and 267a4c76bbdb, this time in the
under-count direction; reproduced on 7.2-rc4 with
madvise(MADV_SOFT_OFFLINE) racing MAP_FIXED replacement of a
shared-anonymous VMA.

[yujiacheng3@huawei.com: drop redundant casts in shmem_evict_inode() pr_warn]
  Link: https://lore.kernel.org/20260729121201.776566-1-yujiacheng3@huawei.com
Link: https://lore.kernel.org/20260728091014.3876715-1-yujiacheng3@huawei.com
Fixes: 0f3c42f522dc ("tmpfs: change final i_blocks BUG to WARNING")
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn
+++ a/mm/shmem.c
@@ -1440,7 +1440,10 @@ static void shmem_evict_inode(struct ino
 	simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
 
 	shmem_free_inode(inode->i_sb, freed);
-	WARN_ON(inode->i_blocks);
+	if (inode->i_blocks)
+		pr_warn("%s: ino=%llu i_blocks=%llu alloced=%lu swapped=%lu nrpages=%lu\n",
+			__func__, inode->i_ino, inode->i_blocks,
+			info->alloced, info->swapped, inode->i_mapping->nrpages);
 	clear_inode(inode);
 #ifdef CONFIG_TMPFS_QUOTA
 	dquot_free_inode(inode);
_

Patches currently in -mm which might be from yujiacheng3@huawei.com are


