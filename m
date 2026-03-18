Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1073F0777
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 19:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773862532; cv=none; b=DLHvSDaubJs4MqH73WiyYoIfajCJkAxeQWsLML5HErkdtHs6HTva4wIjehW/TISwPhCMSaf0IhBJQXC22Zd7N9adL4Owb38ORD6qJwHSyuu2TIAr+r5ZUQsSVM6XwKjDD2elfxSVcwjo9/1zLUyzcuS+zXobmyGvPZHd0Sw76a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773862532; c=relaxed/simple;
	bh=o5KhN1bIQm9E7Gwk17bnU9LlbVxrM8ENwxMfnnEQtKg=;
	h=Date:To:From:Subject:Message-Id; b=ZY9FtKh59Q75p3hMUPV4iUZ6VBg7RlOBqRpf3iodBvdJu4Mv3MZEGWZijnKa2UPAECOQSa1XBalfKjb1yK9MMUR+1GuSJJxXUIi9CC44B9nILfSRF5FOH0vcjSrjMdMlJEXDV7HBX+QKZgOPkndqysHiS47qQout7h77jFABYWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H4DHZFqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H4DHZFqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C364CC19421;
	Wed, 18 Mar 2026 19:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773862531;
	bh=o5KhN1bIQm9E7Gwk17bnU9LlbVxrM8ENwxMfnnEQtKg=;
	h=Date:To:From:Subject:From;
	b=H4DHZFqPlOWPGujv+0aQ1kvWAOg4/FCbe6AQX4cgKXmqWZSNfmRbvjE0IqmsrdWCf
	 X6xz37pjMMj775OyIyC1WNL5hhtAvz826yTw1Zirm3rSh4AAjV27pYa0Z3wsn/UPQi
	 /L1d5FBCdN5t3mrjXXQH+CBHSg1vgQ3q21fSEI/w=
Date: Wed, 18 Mar 2026 12:35:31 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb.patch added to mm-new branch
Message-Id: <20260318193531.C364CC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix memory offline failure due to hwpoisoned file hugetlb
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb.patch

