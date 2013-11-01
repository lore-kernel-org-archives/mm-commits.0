From: akpm@linux-foundation.org
Subject: +
 mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch added to -mm tree
Date: Fri, 01 Nov 2013 13:02:07 -0700
Message-ID: <527408bf.5zBjLobdLhRvQ/aw%akpm__26133.1867696301$1383336137$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3KAUCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 16:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, owada.kiyoshi@jp.panasonic.com, n-horiguchi@ah.jp.nec.com, takeuchi.akr@jp.panasonic.com

Subject: + mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch added to -mm tree
To: takeuchi.akr@jp.panasonic.com,n-horiguchi@ah.jp.nec.com,owada.kiyoshi@jp.panasonic.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 13:02:07 -0700


The patch titled
     Subject: mm: ensure get_unmapped_area() returns higher address than mmap_min_addr
has been added to the -mm tree.  Its filename is
     mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch
mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr-fix.patch

