Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D243CF694
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2026 19:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785268173; cv=none; b=hNoGUTJfWN6rHRKR811GV3dGdsuj8cIfWJIFlCedcmKvRQHuPIZLvyFRprFSY2QLnXlz8T0V1Vw9ZPmUY6aSUqz+2zHDPqNfCpdIWROnDBYc/87uyTQJXa2GWD+K98Yt1psoBDxXNxJqzCRkhO9vYtKyRZI6GdpnT1lehMB6x+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785268173; c=relaxed/simple;
	bh=g5IR8OEj+X+sqkvuneMkd/FjNTzWOUTDXvOH0AJwNS4=;
	h=Date:To:From:Subject:Message-Id; b=BGHeHr1bzOr47+LD4FhSWR/pVpNQOsFRAL4qGvVGkY6cHC1sg24JPhtoUBV3jJ2t//xiGO+BXSFfDLiYpIUOH0bxoZCe3PfUEy8X+kuT6VCFPe0zLPlj9R2/EU2XP6DWGJwt+fUphKHE+Q0IfTt192yKEUtUaQh/xQkwcYCsVFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PhdWZwm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PhdWZwm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5061F000E9;
	Tue, 28 Jul 2026 19:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785268171;
	bh=s229ahK6JAfXVK+0XcQd3VmF9QmxNth2rOxIOWBpEMM=;
	h=Date:To:From:Subject;
	b=PhdWZwm7LpRazNR4zngKHEUkqPaFu1bPhbejO1Y/i2bT7nobm9I/445TZhXUCchEB
	 28PzqHw4Brh03o/QvPOFOlZH7Lkzqw4FzZ7A2JtdA4QO3cdo/m1dQMIFaX61DS6XAB
	 ERO7rr/4k0Izcb1bN0lxbsxsaKWb+6yUEAXQxBJc=
Date: Tue, 28 Jul 2026 12:49:30 -0700
To: mm-commits@vger.kernel.org,liuyongqiang13@huawei.com,hughd@google.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,yujiacheng3@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn.patch added to mm-new branch
Message-Id: <20260728194931.5B5061F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: downgrade final i_blocks check in shmem_evict_inode() to pr_warn()
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn.patch

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

Link: https://lore.kernel.org/20260728091014.3876715-1-yujiacheng3@huawei.com
Fixes: 0f3c42f522dc ("tmpfs: change final i_blocks BUG to WARNING")
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn
+++ a/mm/shmem.c
@@ -1440,7 +1440,11 @@ static void shmem_evict_inode(struct ino
 	simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
 
 	shmem_free_inode(inode->i_sb, freed);
-	WARN_ON(inode->i_blocks);
+	if (inode->i_blocks)
+		pr_warn("%s: ino=%llu i_blocks=%llu alloced=%lu swapped=%lu nrpages=%lu\n",
+			__func__, (unsigned long long)inode->i_ino,
+			(unsigned long long)inode->i_blocks,
+			info->alloced, info->swapped, inode->i_mapping->nrpages);
 	clear_inode(inode);
 #ifdef CONFIG_TMPFS_QUOTA
 	dquot_free_inode(inode);
_

Patches currently in -mm which might be from yujiacheng3@huawei.com are

mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn.patch

