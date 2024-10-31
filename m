Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2871332A1;
	Thu, 31 Oct 2024 03:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344523; cv=none; b=It1qtbi0BDnTsvbj1Y3PtsWxUdDDC3szrhwTLs7lMZF0fkGjHCz33s1FFVxcIILU/jDM1vQ9IeVN+TfVIRYGjCvbS7AlVvlbUbdVcBJLP6FCVhOcs8vO+CmS9++VZp8/s7KdMNBPbN8YpvYlEX4CVMEHtN2drtR/882hDyErLLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344523; c=relaxed/simple;
	bh=bDXnfHlUoEHQ+X9IHYMaM+S+Cz/wvHgGnFHShEqfn9s=;
	h=Date:To:From:Subject:Message-Id; b=XGeSxjq3dBmj4OsUGf9qmcsy5YwFH5p15DwrzRwdN4oSTCj+bIh/NHFHFLHKi8s9MsdTLSPAN5u3AmXd3KwFE5gn4Ne6JFInb57BcVV7HgnT5tbc3shlq4vZgL/Txso1Y4/PUVOpKBEe6ekiRyccTxaXHIVbn9FS+oUWlEuzM4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ImDBw2/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ImDBw2/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7287EC4CECE;
	Thu, 31 Oct 2024 03:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344522;
	bh=bDXnfHlUoEHQ+X9IHYMaM+S+Cz/wvHgGnFHShEqfn9s=;
	h=Date:To:From:Subject:From;
	b=ImDBw2/da2eAhLDz/A08K0GnSgRHu08xMHV2Ox1xdSHuG5XZM2rIV+5R4tgrZ/+RI
	 akrb6qdRRm1EFx+kv6v97egp6rhfxk2TheAa9QySrZTGA0Ppmw19y9VITYvgvCdvW5
	 /3y4RfXA6eIELjuEEZeSoQjOE1oiKUmqBgU3vRwU=
Date: Wed, 30 Oct 2024 20:15:21 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,wangweiyang2@huawei.com,vbabka@suse.cz,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,kirill.shutemov@linux.intel.com,dchinner@redhat.com,anshuman.khandual@arm.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shrinker-avoid-memleak-in-alloc_shrinker_info.patch removed from -mm tree
Message-Id: <20241031031522.7287EC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shrinker: avoid memleak in alloc_shrinker_info
has been removed from the -mm tree.  Its filename was
     mm-shrinker-avoid-memleak-in-alloc_shrinker_info.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ridong <chenridong@huawei.com>
Subject: mm: shrinker: avoid memleak in alloc_shrinker_info
Date: Fri, 25 Oct 2024 06:09:42 +0000

A memleak was found as below:

unreferenced object 0xffff8881010d2a80 (size 32):
  comm "mkdir", pid 1559, jiffies 4294932666
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  @...............
  backtrace (crc 2e7ef6fa):
    [<ffffffff81372754>] __kmalloc_node_noprof+0x394/0x470
    [<ffffffff813024ab>] alloc_shrinker_info+0x7b/0x1a0
    [<ffffffff813b526a>] mem_cgroup_css_online+0x11a/0x3b0
    [<ffffffff81198dd9>] online_css+0x29/0xa0
    [<ffffffff811a243d>] cgroup_apply_control_enable+0x20d/0x360
    [<ffffffff811a5728>] cgroup_mkdir+0x168/0x5f0
    [<ffffffff8148543e>] kernfs_iop_mkdir+0x5e/0x90
    [<ffffffff813dbb24>] vfs_mkdir+0x144/0x220
    [<ffffffff813e1c97>] do_mkdirat+0x87/0x130
    [<ffffffff813e1de9>] __x64_sys_mkdir+0x49/0x70
    [<ffffffff81f8c928>] do_syscall_64+0x68/0x140
    [<ffffffff8200012f>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

alloc_shrinker_info(), when shrinker_unit_alloc() returns an errer, the
info won't be freed.  Just fix it.

Link: https://lkml.kernel.org/r/20241025060942.1049263-1-chenridong@huaweicloud.com
Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/shrinker.c~mm-shrinker-avoid-memleak-in-alloc_shrinker_info
+++ a/mm/shrinker.c
@@ -76,19 +76,21 @@ void free_shrinker_info(struct mem_cgrou
 
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
-	struct shrinker_info *info;
 	int nid, ret = 0;
 	int array_size = 0;
 
 	mutex_lock(&shrinker_mutex);
 	array_size = shrinker_unit_size(shrinker_nr_max);
 	for_each_node(nid) {
-		info = kvzalloc_node(sizeof(*info) + array_size, GFP_KERNEL, nid);
+		struct shrinker_info *info = kvzalloc_node(sizeof(*info) + array_size,
+							   GFP_KERNEL, nid);
 		if (!info)
 			goto err;
 		info->map_nr_max = shrinker_nr_max;
-		if (shrinker_unit_alloc(info, NULL, nid))
+		if (shrinker_unit_alloc(info, NULL, nid)) {
+			kvfree(info);
 			goto err;
+		}
 		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
 	}
 	mutex_unlock(&shrinker_mutex);
_

Patches currently in -mm which might be from chenridong@huawei.com are


