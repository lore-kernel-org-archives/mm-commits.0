Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A8328313D
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 04:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774930751; cv=none; b=UQujRtHrdxrOWmJlsWl7WtqbXwLCj84ubSUbmf2HWt+pvLAON7pg2gu+39md+Yinr73U7yu6bny8rTnhsWH+xJL2BolGCBtUghW+H+Y/AgWLkmxymfNYn9Wf9TVgKilJbDurbmt2qcURoPbeO+OzrzHQZl1uDiOXnQTJrmZM1Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774930751; c=relaxed/simple;
	bh=ai5gcWiIMCjIWjho/GTxE1vlpRhM3Jafu9zX7ZQeVGc=;
	h=Date:To:From:Subject:Message-Id; b=DOyFA9f0ULK368toyNqeEuPakBrIy5OpDuiZBkJWkba36GT0HcEU43w8lgq3YViCe8b2c8Y1KokmFYDgrfPbJRx9FqjgmyduiUkfU00OwI+4vcMuydh8unyzvSln9mo+ilNjgE3PemMPat2Qc+v5Pq8O+uiKkO1lmIK/dF5PO8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jmHWtCmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jmHWtCmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83675C19423;
	Tue, 31 Mar 2026 04:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774930750;
	bh=ai5gcWiIMCjIWjho/GTxE1vlpRhM3Jafu9zX7ZQeVGc=;
	h=Date:To:From:Subject:From;
	b=jmHWtCmgOe+fDaHnkgXOpGNNNQrOWQ33sthzMI8CYg3LgUifamQwYeK5MpxmJsuU/
	 GzHmwpautpx4ajVETqk5x6dLujjmxciZdLS4/n0XufcXP/RQiqI1PSlkuCB0/VJx1f
	 Bq4mBO+NLnLgug3saPagkwk2d8dV0QG24qmwcYzU=
Date: Mon, 30 Mar 2026 21:19:10 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb.patch removed from -mm tree
Message-Id: <20260331041910.83675C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix memory offline failure due to hwpoisoned file hugetlb
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/hugetlb: fix memory offline failure due to hwpoisoned file hugetlb
Date: Wed, 18 Mar 2026 10:07:11 +0800

When a file hugetlb folio triggers UCE, me_huge_page() will keep the
hugetlb folio in pagcahe with refcount increased and PG_hwpoison set. 
Even after the hugetlb file is deleted, the hugetlb folio is still leaked.

If we want to offline the memory block that the hwpoisoned hugetlb folio
belongs to, it fails in dissolve_free_hugetlb_folios() due to the
hwpoisoned hugetlb folio isn't free.

I can reproduce this issue with the following steps in qemu:
 1) echo offline >/sys/devices/system/memory/auto_online_blocks
 2) in qemu monitor:
       object_add memory-backend-ram,id=mem10,size=1G
       device_add pc-dimm,id=dimm1,memdev=mem10,node=2
 3) echo online_movable > /sys/devices/system/node/node2/memory136/state
 4) echo 5 > /sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages
 5) run ./hugetlb_file. This process will receive SIGBUS.
 6) remove the hugetlbfs file.
 7) echo offline > /sys/devices/system/node/node2/memory136/state

hugetlb_file.c:
  fd = open("/dev/hugepages/my_hugepage_file", O_CREAT | O_RDWR, 0755);
  fallocate(fd, 0, 0, HUGEPAGE_SIZE * 2);
  addr = mmap(NULL, HUGEPAGE_SIZE * 2, PROT_READ | PROT_WRITE,
		MAP_SHARED | MAP_HUGETLB, fd, 0);
  memset(addr, 0xaa, HUGEPAGE_SIZE * 2);
  madvise(addr, HUGEPAGE_SIZE, MADV_HWPOISON);

To fix it, when deleting hugetlb folio from pagecache, mark the hugetlb
folio temporary, and put the refcount increased by memory-failure.  After
the hugetlb folio is deleted from pagecache, the refcount is decreased to
zero and the hugetlb folio is dissolved.

Link: https://lkml.kernel.org/r/20260318020711.3596947-1-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb
+++ a/fs/hugetlbfs/inode.c
@@ -597,6 +597,11 @@ static void remove_inode_hugepages(struc
 						  index, truncate_op);
 			freed++;
 
+			if (unlikely(folio_test_hwpoison(folio))) {
+				folio_set_hugetlb_temporary(folio);
+				folio_put(folio);
+			}
+
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
 		folio_batch_release(&fbatch);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


