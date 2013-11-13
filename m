From: akpm@linux-foundation.org
Subject: [merged]
 mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:22 -0800
Message-ID: <5283e37a.mXMB6oyWKzKcnvpM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3KMUjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, owada.kiyoshi@jp.panasonic.com, n-horiguchi@ah.jp.nec.com, takeuchi.akr@jp.panasonic.com

Subject: [merged] mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch removed from -mm tree
To: takeuchi.akr@jp.panasonic.com,n-horiguchi@ah.jp.nec.com,owada.kiyoshi@jp.panasonic.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:22 -0800


The patch titled
     Subject: mm: ensure get_unmapped_area() returns higher address than mmap_min_addr
has been removed from the -mm tree.  Its filename was
     mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Subject: mm: ensure get_unmapped_area() returns higher address than mmap_min_addr

This patch fixes the problem that get_unmapped_area() can return illegal
address and result in failing mmap(2) etc.

In case that the address higher than PAGE_SIZE is set to
/proc/sys/vm/mmap_min_addr, the address lower than mmap_min_addr can be
returned by get_unmapped_area(), even if you do not pass any virtual
address hint (i.e.  the second argument).

This is because the current get_unmapped_area() code does not take into
account mmap_min_addr.

This leads to two actual problems as follows:

1. mmap(2) can fail with EPERM on the process without CAP_SYS_RAWIO,
   although any illegal parameter is not passed.

2. The bottom-up search path after the top-down search might not work in
   arch_get_unmapped_area_topdown().

Note: The first and third chunk of my patch, which changes "len" check,
are for more precise check using mmap_min_addr, and not for solving the
above problem.

[How to reproduce]

	--- test.c -------------------------------------------------
	#include <stdio.h>
	#include <unistd.h>
	#include <sys/mman.h>
	#include <sys/errno.h>

	int main(int argc, char *argv[])
	{
		void *ret = NULL, *last_map;
		size_t pagesize = sysconf(_SC_PAGESIZE);

		do {
			last_map = ret;
			ret = mmap(0, pagesize, PROT_NONE,
				MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
	//		printf("ret=%p\n", ret);
		} while (ret != MAP_FAILED);

		if (errno != ENOMEM) {
			printf("ERR: unexpected errno: %d (last map=%p)\n",
			errno, last_map);
		}

		return 0;
	}
	---------------------------------------------------------------

	$ gcc -m32 -o test test.c
	$ sudo sysctl -w vm.mmap_min_addr=65536
	vm.mmap_min_addr = 65536
	$ ./test  (run as non-priviledge user)
	ERR: unexpected errno: 1 (last map=0x10000)

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/mmap.c~mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr mm/mmap.c
--- a/mm/mmap.c~mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr
+++ a/mm/mmap.c
@@ -1856,7 +1856,7 @@ arch_get_unmapped_area(struct file *filp
 	struct vm_area_struct *vma;
 	struct vm_unmapped_area_info info;
 
-	if (len > TASK_SIZE)
+	if (len > TASK_SIZE - mmap_min_addr)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED)
@@ -1865,7 +1865,7 @@ arch_get_unmapped_area(struct file *filp
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
 		    (!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
@@ -1895,7 +1895,7 @@ arch_get_unmapped_area_topdown(struct fi
 	struct vm_unmapped_area_info info;
 
 	/* requested length too big for entire address space */
-	if (len > TASK_SIZE)
+	if (len > TASK_SIZE - mmap_min_addr)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED)
@@ -1905,14 +1905,14 @@ arch_get_unmapped_area_topdown(struct fi
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
 				(!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = PAGE_SIZE;
+	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
 	info.high_limit = mm->mmap_base;
 	info.align_mask = 0;
 	addr = vm_unmapped_area(&info);
_

Patches currently in -mm which might be from takeuchi.akr@jp.panasonic.com are

origin.patch

