Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F17DF59;
	Sat, 13 Jul 2024 01:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720834179; cv=none; b=SO70VIjszYExzVcTAq3PfCTo2Mu+PQcWIjIIfagZL4gMGEuhSuZUB2BSNukkpCB/XCBE6mKpGcAXXVrCyE7aVycdLrf7bjYqRPB6mtcgvqO+rb9a9Nn8YJxMCFJMuyQl2hXH10cQq2INLyk69joyT6AhV7KEMGp0o+MTYwpdp8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720834179; c=relaxed/simple;
	bh=//ETqcHbGhRaGGv0MF97Oap/KPY3voP7FxRvhQPjS7k=;
	h=Date:To:From:Subject:Message-Id; b=XaRDWJMnN5vC/lpy8OOD8NnRqJp82d9WTN4wKBysSvFHXRYefk+grxSBapLsZNwpDvke7xlZyhIP+BIOMTJ8jo4+TDcjU2mF9Bkx6Z4V+KWPvBHZAq3yNYEEUg9+cb2pcZeBXYpPOouQSmpi3oOKNBWWzuWElzHi7BDrboipYQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N8tu0RX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N8tu0RX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1931C32782;
	Sat, 13 Jul 2024 01:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720834178;
	bh=//ETqcHbGhRaGGv0MF97Oap/KPY3voP7FxRvhQPjS7k=;
	h=Date:To:From:Subject:From;
	b=N8tu0RX9YnasGtQs52tI2QaCbg7wpXSqJc4B5vrEDlg90ezIwGo8FiGdVfnm3tcKa
	 Gl/uKejxyXLOXkon/ovvWrUX9ygxANY0zOuMd0CPF6uEA7Iog2B4Z+Cpp6Jfzmf+iP
	 H1tyZ9KmSFORAZN3vJ4rfmx3zm1zVigm23lUxezE=
Date: Fri, 12 Jul 2024 18:29:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,william.kucharski@oracle.com,stable@vger.kernel.org,ryan.roberts@arm.com,david@redhat.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-avoid-pmd-size-page-cache-if-needed.patch removed from -mm tree
Message-Id: <20240713012938.B1931C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: avoid PMD-size page cache if needed
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-avoid-pmd-size-page-cache-if-needed.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/huge_memory: avoid PMD-size page cache if needed
Date: Thu, 11 Jul 2024 20:48:40 +1000

Currently, xarray can't support arbitrary page cache size and the largest
and supported page cache size is defined as MAX_PAGECACHE_ORDER in commit
099d90642a71 ("mm/filemap: make MAX_PAGECACHE_ORDER acceptable to
xarray").  However, it's possible to have 512MB page cache in the huge
memory collapsing path on ARM64 system whose base page size is 64KB.  A
warning is raised when the huge page cache is split as shown in the
following example.

[root@dhcp-10-26-1-207 ~]# cat /proc/1/smaps | grep KernelPageSize
KernelPageSize:       64 kB
[root@dhcp-10-26-1-207 ~]# cat /tmp/test.c
   :
int main(int argc, char **argv)
{
	const char *filename = TEST_XFS_FILENAME;
	int fd = 0;
	void *buf = (void *)-1, *p;
	int pgsize = getpagesize();
	int ret = 0;

	if (pgsize != 0x10000) {
		fprintf(stdout, "System with 64KB base page size is required!\n");
		return -EPERM;
	}

	system("echo 0 > /sys/devices/virtual/bdi/253:0/read_ahead_kb");
	system("echo 1 > /proc/sys/vm/drop_caches");

	/* Open xfs or shmem file */
	fd = open(filename, O_RDONLY);
	assert(fd > 0);

	/* Create VMA */
	buf = mmap(NULL, TEST_MEM_SIZE, PROT_READ, MAP_SHARED, fd, 0);
	assert(buf != (void *)-1);
	fprintf(stdout, "mapped buffer at 0x%p\n", buf);

	/* Populate VMA */
	ret = madvise(buf, TEST_MEM_SIZE, MADV_NOHUGEPAGE);
	assert(ret == 0);
	ret = madvise(buf, TEST_MEM_SIZE, MADV_POPULATE_READ);
	assert(ret == 0);

	/* Collapse VMA */
	ret = madvise(buf, TEST_MEM_SIZE, MADV_HUGEPAGE);
	assert(ret == 0);
	ret = madvise(buf, TEST_MEM_SIZE, MADV_COLLAPSE);
	if (ret) {
		fprintf(stdout, "Error %d to madvise(MADV_COLLAPSE)\n", errno);
		goto out;
	}

	/* Split xarray. The file needs to reopened with write permission */
	munmap(buf, TEST_MEM_SIZE);
	buf = (void *)-1;
	close(fd);
	fd = open(filename, O_RDWR);
	assert(fd > 0);
	fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 		  TEST_MEM_SIZE - pgsize, pgsize);
out:
	if (buf != (void *)-1)
		munmap(buf, TEST_MEM_SIZE);
	if (fd > 0)
		close(fd);

	return ret;
}

[root@dhcp-10-26-1-207 ~]# gcc /tmp/test.c -o /tmp/test
[root@dhcp-10-26-1-207 ~]# /tmp/test
 ------------[ cut here ]------------
 WARNING: CPU: 25 PID: 7560 at lib/xarray.c:1025 xas_split_alloc+0xf8/0x128
 Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib    \
 nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct      \
 nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4      \
 ip_set rfkill nf_tables nfnetlink vfat fat virtio_balloon drm fuse   \
 xfs libcrc32c crct10dif_ce ghash_ce sha2_ce sha256_arm64 virtio_net  \
 sha1_ce net_failover virtio_blk virtio_console failover dimlib virtio_mmio
 CPU: 25 PID: 7560 Comm: test Kdump: loaded Not tainted 6.10.0-rc7-gavin+ #9
 Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20240524-1.el9 05/24/2024
 pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
 pc : xas_split_alloc+0xf8/0x128
 lr : split_huge_page_to_list_to_order+0x1c4/0x780
 sp : ffff8000ac32f660
 x29: ffff8000ac32f660 x28: ffff0000e0969eb0 x27: ffff8000ac32f6c0
 x26: 0000000000000c40 x25: ffff0000e0969eb0 x24: 000000000000000d
 x23: ffff8000ac32f6c0 x22: ffffffdfc0700000 x21: 0000000000000000
 x20: 0000000000000000 x19: ffffffdfc0700000 x18: 0000000000000000
 x17: 0000000000000000 x16: ffffd5f3708ffc70 x15: 0000000000000000
 x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
 x11: ffffffffffffffc0 x10: 0000000000000040 x9 : ffffd5f3708e692c
 x8 : 0000000000000003 x7 : 0000000000000000 x6 : ffff0000e0969eb8
 x5 : ffffd5f37289e378 x4 : 0000000000000000 x3 : 0000000000000c40
 x2 : 000000000000000d x1 : 000000000000000c x0 : 0000000000000000
 Call trace:
  xas_split_alloc+0xf8/0x128
  split_huge_page_to_list_to_order+0x1c4/0x780
  truncate_inode_partial_folio+0xdc/0x160
  truncate_inode_pages_range+0x1b4/0x4a8
  truncate_pagecache_range+0x84/0xa0
  xfs_flush_unmap_range+0x70/0x90 [xfs]
  xfs_file_fallocate+0xfc/0x4d8 [xfs]
  vfs_fallocate+0x124/0x2f0
  ksys_fallocate+0x4c/0xa0
  __arm64_sys_fallocate+0x24/0x38
  invoke_syscall.constprop.0+0x7c/0xd8
  do_el0_svc+0xb4/0xd0
  el0_svc+0x44/0x1d8
  el0t_64_sync_handler+0x134/0x150
  el0t_64_sync+0x17c/0x180

Fix it by avoiding PMD-sized page cache in the huge memory collapsing
path.  After this patch is applied, the test program fails with error
-EINVAL returned from __thp_vma_allowable_orders() and the madvise()
system call to collapse the page caches.

Link: https://lkml.kernel.org/r/20240711104840.200573-1-gshan@redhat.com
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: <stable@vger.kernel.org>	[5.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-avoid-pmd-size-page-cache-if-needed
+++ a/mm/huge_memory.c
@@ -136,7 +136,8 @@ unsigned long __thp_vma_allowable_orders
 
 		while (orders) {
 			addr = vma->vm_end - (PAGE_SIZE << order);
-			if (thp_vma_suitable_order(vma, addr, order))
+			if (!(vma->vm_file && order > MAX_PAGECACHE_ORDER) &&
+			    thp_vma_suitable_order(vma, addr, order))
 				break;
 			order = next_order(&orders, order);
 		}
_

Patches currently in -mm which might be from gshan@redhat.com are


