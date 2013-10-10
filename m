From: akpm@linux-foundation.org
Subject: +
 mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch added to -mm tree
Date: Thu, 10 Oct 2013 15:48:11 -0700
Message-ID: <52572eab.jY52w9pBD4lQfdkk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3JJWsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 18:48:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, walken@google.com, sinaelgl@gmail.com, schwidefsky@de.ibm.com, cmetcalf@tilera.com, catalin.marinas@arm.com, heiko.carstens@de.ibm.com

Subject: + mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch added to -mm tree
To: heiko.carstens@de.ibm.com,catalin.marinas@arm.com,cmetcalf@tilera.com,schwidefsky@de.ibm.com,sinaelgl@gmail.com,walken@google.com,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 15:48:11 -0700


The patch titled
     Subject: mmap: arch_get_unmapped_area(): use proper mmap base for bottom up direction
has been added to the -mm tree.  Its filename is
     mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
s390-handle-pgtable_page_ctor-fail.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch
mmap-arch_get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch
s390-mmap-randomize-mmap-base-for-bottom-up-direction.patch
linux-next.patch

