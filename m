Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AFB322A2E;
	Wed,  5 Aug 2026 18:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785954181; cv=none; b=CsoF3UnfGUGOl0xXsDxwA4gDu8PTWni5Nd4tvDT66saQDUzPgNTFxEJGX10dXnE5NeZvOnsILrNB5Tk9AXb5FR5I7S+UI881mQZrhn72y+mg9YHheXpwS9hIXcIwN3KbsWm3gFk5fsrqrukF+80GA1q7oRN24GMrn4t7KJoEI2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785954181; c=relaxed/simple;
	bh=+iaCP+P7Z+W8srAjFB2Vmrm/WfZ3qJY6RBi49Wxp71I=;
	h=Date:To:From:Subject:Message-Id; b=oRRn/+y/ez9okvcb+XEvA6pU7y+2uG4xACypdsHhlRHGSklsL9vXJLPVAHiYszCA1IEmqd/hML/ZBFBbgLbBJSzfuMhSEqcH+WXa/+z5GtvxgxsFajS90PvU0tBgvDPZm88Mn447/jsA1wIWJzvp5jp+TuDY3MszBKyRwKFr3+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JVFkAOxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JVFkAOxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3E01F000E9;
	Wed,  5 Aug 2026 18:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785954179;
	bh=ibBaLjYRdVbV+tgFr4FoZYP6A/h59z/2GbeLAzP7vlM=;
	h=Date:To:From:Subject;
	b=JVFkAOxYoARGvdypP34GYWaGSCjisS2viNt8moen27ZEueE7kV3Ep+fGULVM3ea4W
	 +I76c9EiVXi4l+Sou1vSi4uUXf9bxIz66s1IMx5oVnV4bEZjsOVRyZ0I6mQY8UP1Fs
	 yFG+VEzhFElrl7NWMa284Il5uGZogJjSXS8hwk0Q=
Date: Wed, 05 Aug 2026 11:22:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,matthias.goergens@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-cached-cluster-count-after-suballocator-reclaim.patch added to mm-nonmm-unstable branch
Message-Id: <20260805182259.8E3E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix cached cluster count after suballocator reclaim
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-cached-cluster-count-after-suballocator-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-cached-cluster-count-after-suballocator-reclaim.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Matthias Goergens <matthias.goergens@gmail.com>
Subject: ocfs2: fix cached cluster count after suballocator reclaim
Date: Wed, 5 Aug 2026 19:39:20 +0800

When reclaiming a suballocator block group, first reduce the on-disk
cluster count by cl_cpg.  The current code then subtracts that new count
(fe->i_clusters) from the old cached count
(OCFS2_I(alloc_inode)->ip_clusters).

For an allocator with N block groups, that leaves the cache at

    N * cl_cpg - (N * cl_cpg - cl_cpg) = cl_cpg

i.e.  ip_clusters -= (fe->i_clusters - cl_cpg) leaves ip_clusters equal to
cl_cpg regardless of N.  This happens to be correct when reclaiming from
two block groups, but undercounts the clusters from three block groups
onwards.  The incorrect cache value is also used immediately to update
i_blocks.

Assign the updated on-disk count to the cache, matching the allocation and
inode refresh paths.

In a QEMU test using a clean 256 MiB OCFS2 image and a 10,000-file
create/delete workload, the first buggy reclaim left the on-disk
(fe->i_clusters) and cached (ip_clusters) counts at 2048 and 512 clusters
respectively; later reclaims underflowed the cache.  With this change, the
cache matched the on-disk count across all four reclaims: 2048, 1536,
1024, and 512 clusters.

Link: https://lore.kernel.org/20260805113920.385959-1-matthias.goergens@gmail.com
Fixes: 4a54331616b3 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/suballoc.c~ocfs2-fix-cached-cluster-count-after-suballocator-reclaim
+++ a/fs/ocfs2/suballoc.c
@@ -2759,7 +2759,7 @@ static int _ocfs2_reclaim_suballoc_to_ma
 	fe->i_clusters = cpu_to_le32(tmp_used - le16_to_cpu(cl->cl_cpg));
 
 	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
-	OCFS2_I(alloc_inode)->ip_clusters -= le32_to_cpu(fe->i_clusters);
+	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
 	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
 					     le32_to_cpu(fe->i_clusters)));
 	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
_

Patches currently in -mm which might be from matthias.goergens@gmail.com are

ocfs2-fix-cached-cluster-count-after-suballocator-reclaim.patch

