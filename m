Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EE0276D13
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 23:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740699947; cv=none; b=uzRI7Ic7nn0qfvzbcqD3HbP6BxkvCOJaMXhmLbyhRen/JPTj9dtf9AkcoXS3/fwePUmpYrRkKPaBcOZ568YF2G6EFGUGLFIB1iwUytJTPCmI3tf2rSTN1BbbbSimmfDTkQtrHFekJh8dJzbVLPU+POouq/sVB7ZhG3+vxxnpc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740699947; c=relaxed/simple;
	bh=h0RvisQ5N7e7O/Smiolrbb8d+qZhc5ht5vHj37Gq63A=;
	h=Date:To:From:Subject:Message-Id; b=BOtufW3kMoCpXOsBD2QkdEeU2TYdmSkRbObdSs+sZMLzUYt9RxZmNJWa1pbaVaZ8dEwClO8LqwwY1G31FerBsYeZ38wybgQtwysRt1ZzvsWUOGFlFQ4efah2szqukwdXN61uX0GPeIfiOPbqSfcT6UHkntL9Kz+yw7mGR2Yo00o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BfGcxpjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BfGcxpjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA070C4CEDD;
	Thu, 27 Feb 2025 23:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740699946;
	bh=h0RvisQ5N7e7O/Smiolrbb8d+qZhc5ht5vHj37Gq63A=;
	h=Date:To:From:Subject:From;
	b=BfGcxpjFFAVy9bbLHQfOg6VjgxbAjCNlDPo4LF5OzHRs1ENdeXN7nwK1aw5+7bQwI
	 MPgNOPTCDAXusNdgDA+Y7RjndHauK8di2GgaEueCc5BhmQnId/8bEnFw0gdECfptn3
	 VEL0TTghr81MXGh4JwAiFuyAtbuxunsmthprvzis=
Date: Thu, 27 Feb 2025 15:45:45 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@kernel.org,mgorman@techsingularity.net,zhanghao1@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-uninitialized-variable.patch added to mm-hotfixes-unstable branch
Message-Id: <20250227234546.DA070C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix uninitialized variable
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-fix-uninitialized-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-uninitialized-variable.patch

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
From: Hao Zhang <zhanghao1@kylinos.cn>
Subject: mm/page_alloc: fix uninitialized variable
Date: Thu, 27 Feb 2025 11:41:29 +0800

The variable "compact_result" is not initialized in function
__alloc_pages_slowpath().  It causes should_compact_retry() to use an
uninitialized value.

Initialize variable "compact_result" with the value COMPACT_SKIPPED.

BUG: KMSAN: uninit-value in __alloc_pages_slowpath+0xee8/0x16c0 mm/page_alloc.c:4416
 __alloc_pages_slowpath+0xee8/0x16c0 mm/page_alloc.c:4416
 __alloc_frozen_pages_noprof+0xa4c/0xe00 mm/page_alloc.c:4752
 alloc_pages_mpol+0x4cd/0x890 mm/mempolicy.c:2270
 alloc_frozen_pages_noprof mm/mempolicy.c:2341 [inline]
 alloc_pages_noprof mm/mempolicy.c:2361 [inline]
 folio_alloc_noprof+0x1dc/0x350 mm/mempolicy.c:2371
 filemap_alloc_folio_noprof+0xa6/0x440 mm/filemap.c:1019
 __filemap_get_folio+0xb9a/0x1840 mm/filemap.c:1970
 grow_dev_folio fs/buffer.c:1039 [inline]
 grow_buffers fs/buffer.c:1105 [inline]
 __getblk_slow fs/buffer.c:1131 [inline]
 bdev_getblk+0x2c9/0xab0 fs/buffer.c:1431
 getblk_unmovable include/linux/buffer_head.h:369 [inline]
 ext4_getblk+0x3b7/0xe50 fs/ext4/inode.c:864
 ext4_bread_batch+0x9f/0x7d0 fs/ext4/inode.c:933
 __ext4_find_entry+0x1ebb/0x36c0 fs/ext4/namei.c:1627
 ext4_lookup_entry fs/ext4/namei.c:1729 [inline]
 ext4_lookup+0x189/0xb40 fs/ext4/namei.c:1797
 __lookup_slow+0x538/0x710 fs/namei.c:1793
 lookup_slow+0x6a/0xd0 fs/namei.c:1810
 walk_component fs/namei.c:2114 [inline]
 link_path_walk+0xf29/0x1420 fs/namei.c:2479
 path_openat+0x30f/0x6250 fs/namei.c:3985
 do_filp_open+0x268/0x600 fs/namei.c:4016
 do_sys_openat2+0x1bf/0x2f0 fs/open.c:1428
 do_sys_open fs/open.c:1443 [inline]
 __do_sys_openat fs/open.c:1459 [inline]
 __se_sys_openat fs/open.c:1454 [inline]
 __x64_sys_openat+0x2a1/0x310 fs/open.c:1454
 x64_sys_call+0x36f5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:258
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable compact_result created at:
 __alloc_pages_slowpath+0x66/0x16c0 mm/page_alloc.c:4218
 __alloc_frozen_pages_noprof+0xa4c/0xe00 mm/page_alloc.c:4752

Link: https://lkml.kernel.org/r/tencent_ED1032321D6510B145CDBA8CBA0093178E09@qq.com
Reported-by: syzbot+0cfd5e38e96a5596f2b6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0cfd5e38e96a5596f2b6
Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-page_alloc-fix-uninitialized-variable
+++ a/mm/page_alloc.c
@@ -4243,6 +4243,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
+	compact_result = COMPACT_SKIPPED;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist_iter_cookie = zonelist_iter_begin();
_

Patches currently in -mm which might be from zhanghao1@kylinos.cn are

mm-page_alloc-fix-uninitialized-variable.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function.patch

