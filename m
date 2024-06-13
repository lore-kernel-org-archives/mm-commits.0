Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958871877;
	Thu, 13 Jun 2024 20:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718312220; cv=none; b=gaAKAVi1hFMvrU1KpnQRHFR/WOA8OFWd7fFWzm16F8FDSK+KIWHxBEkurKhW11mo0uVGrb9fIQ4iAqLz72CKEcxR+X8AUloKJSZ/D320vQ+SFUGXAP68mrDiAU6qiLPHYIwitRYTBUiHfgm9ghGQpV+gqhLJLfgW70eEeHKXY6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718312220; c=relaxed/simple;
	bh=mtE5nQzdJugraM3/vePmlGsPcdyIhFoPFOfh9I/bmsw=;
	h=Date:To:From:Subject:Message-Id; b=Kj4/Rji3thCk0Q0NhhBqym5D9n23p+J+5gzwcWWFU4DkWgu0M6I9aizQUCmBCDXbqGrBY0ABYNcQ44WvOY2RtjIUOOTnx75iraciv01yu0pRk/gfmUxAeKEnbqqtp7PhMTvGw8WKg9Xf5iIHWE6ohfFncfVeTaLipyRgmPpqzxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mfVTi9z0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mfVTi9z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17437C2BBFC;
	Thu, 13 Jun 2024 20:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718312220;
	bh=mtE5nQzdJugraM3/vePmlGsPcdyIhFoPFOfh9I/bmsw=;
	h=Date:To:From:Subject:From;
	b=mfVTi9z05urqcEDSfqPlKXzzpxTcWcNX6x1+fGkyq7g+RSJcvEXLBnJfwjS0TcL5Z
	 TGUzXxUd9OJRQ+BxRY+20sOqL8Ih+QeUxBsA0Ov7FSSCW8YAZWzeiT8WBKwLfxVrFF
	 rAtHbGZZlrK7lpNCvjvVU9hXRBJMqMpuBuYKS5iQ=
Date: Thu, 13 Jun 2024 13:56:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20240613205700.17437C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix getting incorrect lruvec when replacing a shmem folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix getting incorrect lruvec when replacing a shmem folio
Date: Thu, 13 Jun 2024 16:21:19 +0800

When testing shmem swapin, I encountered the warning below on my machine. 
The reason is that replacing an old shmem folio with a new one causes
mem_cgroup_migrate() to clear the old folio's memcg data.  As a result,
the old folio cannot get the correct memcg's lruvec needed to remove
itself from the LRU list when it is being freed.  This could lead to
possible serious problems, such as LRU list crashes due to holding the
wrong LRU lock, and incorrect LRU statistics.

To fix this issue, we can fallback to use the mem_cgroup_replace_folio()
to replace the old shmem folio.

[ 5241.100311] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5d9960
[ 5241.100317] head: order:4 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[ 5241.100319] flags: 0x17fffe0000040068(uptodate|lru|head|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
[ 5241.100323] raw: 17fffe0000040068 fffffdffd6687948 fffffdffd69ae008 0000000000000000
[ 5241.100325] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[ 5241.100326] head: 17fffe0000040068 fffffdffd6687948 fffffdffd69ae008 0000000000000000
[ 5241.100327] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[ 5241.100328] head: 17fffe0000000204 fffffdffd6665801 ffffffffffffffff 0000000000000000
[ 5241.100329] head: 0000000a00000010 0000000000000000 00000000ffffffff 0000000000000000
[ 5241.100330] page dumped because: VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled())
[ 5241.100338] ------------[ cut here ]------------
[ 5241.100339] WARNING: CPU: 19 PID: 78402 at include/linux/memcontrol.h:775 folio_lruvec_lock_irqsave+0x140/0x150
[...]
[ 5241.100374] pc : folio_lruvec_lock_irqsave+0x140/0x150
[ 5241.100375] lr : folio_lruvec_lock_irqsave+0x138/0x150
[ 5241.100376] sp : ffff80008b38b930
[...]
[ 5241.100398] Call trace:
[ 5241.100399]  folio_lruvec_lock_irqsave+0x140/0x150
[ 5241.100401]  __page_cache_release+0x90/0x300
[ 5241.100404]  __folio_put+0x50/0x108
[ 5241.100406]  shmem_replace_folio+0x1b4/0x240
[ 5241.100409]  shmem_swapin_folio+0x314/0x528
[ 5241.100411]  shmem_get_folio_gfp+0x3b4/0x930
[ 5241.100412]  shmem_fault+0x74/0x160
[ 5241.100414]  __do_fault+0x40/0x218
[ 5241.100417]  do_shared_fault+0x34/0x1b0
[ 5241.100419]  do_fault+0x40/0x168
[ 5241.100420]  handle_pte_fault+0x80/0x228
[ 5241.100422]  __handle_mm_fault+0x1c4/0x440
[ 5241.100424]  handle_mm_fault+0x60/0x1f0
[ 5241.100426]  do_page_fault+0x120/0x488
[ 5241.100429]  do_translation_fault+0x4c/0x68
[ 5241.100431]  do_mem_abort+0x48/0xa0
[ 5241.100434]  el0_da+0x38/0xc0
[ 5241.100436]  el0t_64_sync_handler+0x68/0xc0
[ 5241.100437]  el0t_64_sync+0x14c/0x150
[ 5241.100439] ---[ end trace 0000000000000000 ]---

Link: https://lkml.kernel.org/r/3c11000dd6c1df83015a8321a859e9775ebbc23e.1718266112.git.baolin.wang@linux.alibaba.com
Fixes: 85ce2c517ade ("memcontrol: only transfer the memcg data for migration")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio
+++ a/mm/shmem.c
@@ -1786,7 +1786,7 @@ static int shmem_replace_folio(struct fo
 	xa_lock_irq(&swap_mapping->i_pages);
 	error = shmem_replace_entry(swap_mapping, swap_index, old, new);
 	if (!error) {
-		mem_cgroup_migrate(old, new);
+		mem_cgroup_replace_folio(old, new);
 		__lruvec_stat_mod_folio(new, NR_FILE_PAGES, 1);
 		__lruvec_stat_mod_folio(new, NR_SHMEM, 1);
 		__lruvec_stat_mod_folio(old, NR_FILE_PAGES, -1);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

