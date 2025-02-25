Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AAA3D561
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 05:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740461428; cv=none; b=JOyKroWjbRr3B1jTyQ/59EkSzDXmg48D2GcYTBs8TRUtH7zm7jzcaCgFeHanozXJA1bBboUARbmlMXEtd7KBcxroh8ZPpfLLRmCQ/awTjEKZmjpbN85EFxnQl3bUkm8pZJbnlxuLvzXfGTf7bPFL6xuFSkIXETFa7Ca86C66DUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740461428; c=relaxed/simple;
	bh=I1qX6/mzB/75dqTlGvvDav7tQ0nazP8+OunzvWHpSlo=;
	h=Date:To:From:Subject:Message-Id; b=taXYdcsG52APNKo/SQoncq0C5o8W4S0cJBfviuNQ7q1Q04BYFc/CYcj+VGyxKBZ4g7pUq/E4r4O98qevboPfWYXI7erPbdb3GvF28z2VYIEDxhrfRRP5lXbc6GcpbpKxVyp7vZxXCXA8wBWcc8re+k5jMC/lLEavLHQT1JqEWc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rAG7M3S8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rAG7M3S8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA8DC4CEDD;
	Tue, 25 Feb 2025 05:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740461427;
	bh=I1qX6/mzB/75dqTlGvvDav7tQ0nazP8+OunzvWHpSlo=;
	h=Date:To:From:Subject:From;
	b=rAG7M3S8MF9nMrbhKPAQUOca+B8BP04wc0AvKqse4GeDI1EmmORQnwYJTIb+QDZM7
	 8I21sC4hXhfTj7eqmwJ2od0Ed+YTNO/9ntjzOo8OeID+df73ddcs1bTHXXoULV+dva
	 J18Rj9s/h+gqeNQ3ihqBhPdntovZimPRJbcXIbKo=
Date: Mon, 24 Feb 2025 21:30:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@kernel.org,mgorman@techsingularity.net,zhanghao1@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-uninitialized-variable.patch added to mm-hotfixes-unstable branch
Message-Id: <20250225053027.4FA8DC4CEDD@smtp.kernel.org>
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
Date: Tue, 25 Feb 2025 10:20:34 +0800

The variable "compact_result" is not initialized in function
__alloc_pages_direct_compact if order is zero.

If order is zero, initialize "compact_result" to COMPACT_SKIPPED.

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

Link: https://lkml.kernel.org/r/tencent_18B06C010BE1255350A6093BDE0CCC681E05@qq.com
Reported-by: syzbot+0cfd5e38e96a5596f2b6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0cfd5e38e96a5596f2b6
Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-uninitialized-variable
+++ a/mm/page_alloc.c
@@ -3675,8 +3675,10 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	unsigned long pflags;
 	unsigned int noreclaim_flag;
 
-	if (!order)
+	if (!order) {
+		*compact_result = COMPACT_SKIPPED;
 		return NULL;
+	}
 
 	psi_memstall_enter(&pflags);
 	delayacct_compact_start();
_

Patches currently in -mm which might be from zhanghao1@kylinos.cn are

mm-page_alloc-fix-uninitialized-variable.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function.patch

