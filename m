Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD59B28371;
	Thu, 26 Sep 2024 21:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384656; cv=none; b=eorCUbQ+zn6VdQdhFmZUWBX+fJ64pZXW7g2mtKsml5X5hDnED2n3tenM31DbZ1u8qKV0TOm9sZ/irrSoRlWQqLu2YjN1bWCxl+CTHWjzZJfp6mo1wDXTP35VKixQMkNAChzrzUBk9SVbGOeDb3MkmMZm3YhW9+2iKhKpdv84wio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384656; c=relaxed/simple;
	bh=9l14hVtfyPDo/cFRIlx+WUro9XkoG04IBN0/5Jkq408=;
	h=Date:To:From:Subject:Message-Id; b=lR5Z+Pqbcg/Pgg/MNLPgbFfR0xKT7FZpLhvMQ4gC/JtZVsCgj5ubhAKIaaLyoUNhaBzzQWh+1LCqJInba69XjvETr/UGgXa2+RCGzU6r+ehBl5jNXi9/iRJ0BmebDaq8TXb+AtJ80cO2v3ySwOnj0wtYvRBv1aWGeuEwi56uyVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q4p8MC0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q4p8MC0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A828EC4CEC5;
	Thu, 26 Sep 2024 21:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384655;
	bh=9l14hVtfyPDo/cFRIlx+WUro9XkoG04IBN0/5Jkq408=;
	h=Date:To:From:Subject:From;
	b=q4p8MC0dYrc/CaIjHPR5vWiebOz0sjCCJZF+v8isnePNDkt5p3Fgj2uOdmkb90Q5R
	 FgqAwA7bfv3NBvXl4inCqJy1BoHjI97sWDkmvpsu4Y+kXnpfYwaTnVym1Yeg/R6BgM
	 XbEtP1ojtKM/inGB+n6FX735bnVtsjfE1JnCb0m8=
Date: Thu, 26 Sep 2024 14:04:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,syzkaller@googlegroups.com,stable@vger.kernel.org,david@redhat.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-annotate-data-race-in-migrate_folio_unmap.patch removed from -mm tree
Message-Id: <20240926210415.A828EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: annotate data-race in migrate_folio_unmap()
has been removed from the -mm tree.  Its filename was
     mm-migrate-annotate-data-race-in-migrate_folio_unmap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
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

mm-percpu-fix-typo-to-pcpu_alloc_noprof-description.patch
mm-shmem-fix-data-race-in-shmem_getattr.patch

