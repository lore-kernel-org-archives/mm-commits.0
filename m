Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09AC20EA3A;
	Fri, 25 Oct 2024 22:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729896128; cv=none; b=UTMaCxzAevNgIKvVljVF2UZv0R4+cZU/wmwLoLN90CedZSkDSrHWF30tFN1AWT4Pv3It/SV/29/JQpntKOkaYG3ZIHiQfU1iTxPYsfpkHBQuJF/fy1ZkMV2YqUGdOm24PPr2ZpCer3i/ZQvwZyJ0WEodUWiBsFIKQ5pVKtvqBkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729896128; c=relaxed/simple;
	bh=he+XMZ3C9godGob7mCSNonft4pREpREAjhQGvERrj+0=;
	h=Date:To:From:Subject:Message-Id; b=WgDceScNPwKcWSBf2JReiAJSXJDlD56DE9bwbiQ50wJ9m76ufM1s4QgUpGmXV617AZHn84EkU9qLZZF8Z0dWI+R9fmPnOQGoxzaC61u+QEf6uSm5NcQsfx30kUDilSzxtj6PocKpxwIywl3nkxc+dzEhfusT4tGWVuKX9OV0rBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cCfBGrG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cCfBGrG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59567C4CEC3;
	Fri, 25 Oct 2024 22:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729896127;
	bh=he+XMZ3C9godGob7mCSNonft4pREpREAjhQGvERrj+0=;
	h=Date:To:From:Subject:From;
	b=cCfBGrG6QVgoTaH44Vk5LlhxUAjXBj+ZmSNDUFZB8yBgNVkkVgOImIHvvBOf1flnF
	 sxabbxeXqmdk8ah1wpy+/vN++Vp+/KVwKys4EvHAGKNwRWdTca+h3xSWRBx4aCeCTw
	 ZHSeBCV/HhwnDQ2aoMOtY30AF+hrQyf4q2UAIIfo=
Date: Fri, 25 Oct 2024 15:42:06 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,wangweiyang2@huawei.com,vbabka@suse.cz,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,kirill.shutemov@linux.intel.com,david@fromorbit.com,anshuman.khandual@arm.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-avoid-memleak-in-alloc_shrinker_info.patch added to mm-hotfixes-unstable branch
Message-Id: <20241025224207.59567C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shrinker: avoid memleak in alloc_shrinker_info
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shrinker-avoid-memleak-in-alloc_shrinker_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-avoid-memleak-in-alloc_shrinker_info.patch

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
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dave Chinner <david@fromorbit.com>
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

mm-shrinker-avoid-memleak-in-alloc_shrinker_info.patch

