Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB65A3E7159;
	Thu, 13 Aug 2026 22:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660976; cv=none; b=BTxf7tEYuyn3380HnUBcwwLyVVEjZ2qvZtQif/GJlV6OiUGarSIpo7K+6V9Hy/3U4VFyDnxEsj3sBXfP77T6AKeNSR+5islC90nnAwBvQUMH1cZE11PZ5D2ehExij+iwReTDyrVP0zibQHvWxALtVLnmwvtjE16AFDY55og4f6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660976; c=relaxed/simple;
	bh=WM9ACsG0xMcH6MtJ52BiLuNHevVKqQ3FjYvMzpuIca4=;
	h=Date:To:From:Subject:Message-Id; b=nTeqNBGST44HvIobMWOj0eUr1b/KzSDgdtn6+FY6Ml88paPRpsGoOzFvyX+YvpgVWL4ujeuyQkGE9VKIPWY5QJS97yJGJvdM7XsGTAOjAD4Dbai9uNYk3GQp0iBm7YfMsE3Bikkxd118Pun7ayM2RjmNhGzm1qJ3QPGJpYFmriU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tuMEtlbC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tuMEtlbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D331F000E9;
	Thu, 13 Aug 2026 22:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660974;
	bh=x/QfYFdxGWaAtSlCnTGmeUlCxpEHaK4gy41T3ZoAMpk=;
	h=Date:To:From:Subject;
	b=tuMEtlbCmeMWf9yQyqbgmvcIEDPpI/ygMHBGAwTiJV2KHm5+6osln+45rJG1IqnfV
	 cOZFqNmc0VnSlbzD2edi/fwjb5eS8hiX420/wzp8mBm2+exVLWBwRpvqPI/nlxneyW
	 2Envo8XfWcZ6C0vgIIaGYYIKnBAUgSc9JTbGQpeE=
Date: Thu, 13 Aug 2026 15:42:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,matthias.goergens@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-cached-cluster-count-after-suballocator-reclaim.patch removed from -mm tree
Message-Id: <20260813224254.61D331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix cached cluster count after suballocator reclaim
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-cached-cluster-count-after-suballocator-reclaim.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


