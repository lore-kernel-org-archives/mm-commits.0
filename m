Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C101B335C7;
	Tue, 24 Sep 2024 20:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727209158; cv=none; b=eLuvtSwlPUML5Lnfa1VWdcxQVf/H2Rvwr4TUPvHr/OH+W4l9cFypbtgJ22VfcP47xcJnDGrP5U2TsFKQmfBcDdD5jELdUtb28j7EWJiGLpLX7hH8JpnAYlN80wdf1jqa6ZxvQKw4VLz8nplH6fO3lE0zPLGufDyRBqfeIxDPOEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727209158; c=relaxed/simple;
	bh=1joLIRtZQRC+M9dBzb6rczr74nB0c7Eor6G3C1jYOK0=;
	h=Date:To:From:Subject:Message-Id; b=Mcv45Od0fH0RlJVl7Y9lFK3ojl/Aqy9ZYKdw/rSoPbdRAY0oMf7u7B/lrtrVuBVVqbY5BEjr0YEiK62E7AiMmS/js7yJXs/8kQePYb3Hp4crenFF+T19DvoQ53nhbNq0fr7bCjpxRiVP3sr9tlWtga77ckN1lp5JBSJJvKTZayk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nzcYq89x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nzcYq89x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5524BC4CEC4;
	Tue, 24 Sep 2024 20:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727209157;
	bh=1joLIRtZQRC+M9dBzb6rczr74nB0c7Eor6G3C1jYOK0=;
	h=Date:To:From:Subject:From;
	b=nzcYq89xmnL1jiHMiled3QbDmdE6Pylw/ivtQb8CfunsWjo+ulJvWt7zH4moaY/io
	 agiJT9/bYvT/zBqD17FjO15YBKUFZKV5FsrlAjlThBX2SPFx88UEP4Y0c+Q1mAwRLd
	 BCvVo55R5vLOBI/SWNIAVfFCTnn4XTicxHyIOT9Q=
Date: Tue, 24 Sep 2024 13:19:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,syzkaller@googlegroups.com,stable@vger.kernel.org,david@redhat.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-annotate-data-race-in-migrate_folio_unmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20240924201917.5524BC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: annotate data-race in migrate_folio_unmap()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-annotate-data-race-in-migrate_folio_unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-annotate-data-race-in-migrate_folio_unmap.patch

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
From: Jeongjun Park <aha310510@gmail.com>
Subject: mm: migrate: annotate data-race in migrate_folio_unmap()
Date: Tue, 24 Sep 2024 22:00:53 +0900

I found a report from syzbot [1]

This report shows that the value can be changed, but in reality, the
value of __folio_set_movable() cannot be changed because it holds the
folio refcount.

Therefore, it is appropriate to add an annotate to make KCSAN
ignore that data-race.

[1]

==================================================================
BUG: KCSAN: data-race in __filemap_remove_folio / migrate_pages_batch

write to 0xffffea0004b81dd8 of 8 bytes by task 6348 on cpu 0:
 page_cache_delete mm/filemap.c:153 [inline]
 __filemap_remove_folio+0x1ac/0x2c0 mm/filemap.c:233
 filemap_remove_folio+0x6b/0x1f0 mm/filemap.c:265
 truncate_inode_folio+0x42/0x50 mm/truncate.c:178
 shmem_undo_range+0x25b/0xa70 mm/shmem.c:1028
 shmem_truncate_range mm/shmem.c:1144 [inline]
 shmem_evict_inode+0x14d/0x530 mm/shmem.c:1272
 evict+0x2f0/0x580 fs/inode.c:731
 iput_final fs/inode.c:1883 [inline]
 iput+0x42a/0x5b0 fs/inode.c:1909
 dentry_unlink_inode+0x24f/0x260 fs/dcache.c:412
 __dentry_kill+0x18b/0x4c0 fs/dcache.c:615
 dput+0x5c/0xd0 fs/dcache.c:857
 __fput+0x3fb/0x6d0 fs/file_table.c:439
 ____fput+0x1c/0x30 fs/file_table.c:459
 task_work_run+0x13a/0x1a0 kernel/task_work.c:228
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xbe/0x130 kernel/entry/common.c:218
 do_syscall_64+0xd6/0x1c0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffffea0004b81dd8 of 8 bytes by task 6342 on cpu 1:
 __folio_test_movable include/linux/page-flags.h:699 [inline]
 migrate_folio_unmap mm/migrate.c:1199 [inline]
 migrate_pages_batch+0x24c/0x1940 mm/migrate.c:1797
 migrate_pages_sync mm/migrate.c:1963 [inline]
 migrate_pages+0xff1/0x1820 mm/migrate.c:2072
 do_mbind mm/mempolicy.c:1390 [inline]
 kernel_mbind mm/mempolicy.c:1533 [inline]
 __do_sys_mbind mm/mempolicy.c:1607 [inline]
 __se_sys_mbind+0xf76/0x1160 mm/mempolicy.c:1603
 __x64_sys_mbind+0x78/0x90 mm/mempolicy.c:1603
 x64_sys_call+0x2b4d/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:238
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0xffff888127601078 -> 0x0000000000000000

Link: https://lkml.kernel.org/r/20240924130053.107490-1-aha310510@gmail.com
Fixes: 7e2a5e5ab217 ("mm: migrate: use __folio_test_movable()")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-annotate-data-race-in-migrate_folio_unmap
+++ a/mm/migrate.c
@@ -1196,7 +1196,7 @@ static int migrate_folio_unmap(new_folio
 	int rc = -EAGAIN;
 	int old_page_state = 0;
 	struct anon_vma *anon_vma = NULL;
-	bool is_lru = !__folio_test_movable(src);
+	bool is_lru = data_race(!__folio_test_movable(src));
 	bool locked = false;
 	bool dst_locked = false;
 
_

Patches currently in -mm which might be from aha310510@gmail.com are

mm-migrate-annotate-data-race-in-migrate_folio_unmap.patch
mm-percpu-fix-typo-to-pcpu_alloc_noprof-description.patch

