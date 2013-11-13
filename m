From: akpm@linux-foundation.org
Subject: [merged]
 mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:54 -0800
Message-ID: <5283e35e.6BpFDIRIXBI1/4dc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3KMUiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, walken@google.com, sinaelgl@gmail.com, schwidefsky@de.ibm.com, cmetcalf@tilera.com, catalin.marinas@arm.com, heiko.carstens@de.ibm.com

Subject: [merged] mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch removed from -mm tree
To: heiko.carstens@de.ibm.com,catalin.marinas@arm.com,cmetcalf@tilera.com,schwidefsky@de.ibm.com,sinaelgl@gmail.com,walken@google.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:54 -0800


The patch titled
     Subject: mmap: arch_get_unmapped_area(): use proper mmap base for bottom up direction
has been removed from the -mm tree.  Its filename was
     mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: mmap: arch_get_unmapped_area(): use proper mmap base for bottom up direction

This is more or less the generic variant of 41aacc1eea ("x86
get_unmapped_area: Access mmap_legacy_base through mm_struct member").

So effectively architectures which use an own arch_pick_mmap_layout()
implementation but call the generic arch_get_unmapped_area() now can also
randomize their mmap_base.

All architectures which have an own arch_pick_mmap_layout() and call the
generic arch_get_unmapped_area() (arm64, s390, tile) currently set
mmap_base to TASK_UNMAPPED_BASE.  This is also true for the generic
arch_pick_mmap_layout() function.  So this change is a no-op currently.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Radu Caragea <sinaelgl@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction mm/mmap.c
--- a/mm/mmap.c~mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction
+++ a/mm/mmap.c
@@ -1872,7 +1872,7 @@ arch_get_unmapped_area(struct file *filp
 
 	info.flags = 0;
 	info.length = len;
-	info.low_limit = TASK_UNMAPPED_BASE;
+	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
 	info.align_mask = 0;
 	return vm_unmapped_area(&info);
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
s390-handle-pgtable_page_ctor-fail.patch

