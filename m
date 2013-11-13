From: akpm@linux-foundation.org
Subject: [merged]
 s390-mmap-randomize-mmap-base-for-bottom-up-direction.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:38:56 -0800
Message-ID: <5283e360.UYumnhXdCnGyU8jz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3KMUi5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, walken@google.com, sinaelgl@gmail.com, schwidefsky@de.ibm.com, cmetcalf@tilera.com, catalin.marinas@arm.com, heiko.carstens@de.ibm.com

Subject: [merged] s390-mmap-randomize-mmap-base-for-bottom-up-direction.patch removed from -mm tree
To: heiko.carstens@de.ibm.com,catalin.marinas@arm.com,cmetcalf@tilera.com,schwidefsky@de.ibm.com,sinaelgl@gmail.com,walken@google.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:56 -0800


The patch titled
     Subject: s390/mmap: randomize mmap base for bottom up direction
has been removed from the -mm tree.  Its filename was
     s390-mmap-randomize-mmap-base-for-bottom-up-direction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: s390/mmap: randomize mmap base for bottom up direction

Implement mmap base randomization for the bottom up direction, so ASLR
works for both mmap layouts on s390.  See also df54d6fa54 ("x86
get_unmapped_area(): use proper mmap base for bottom-up direction").

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Radu Caragea <sinaelgl@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/mmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/s390/mm/mmap.c~s390-mmap-randomize-mmap-base-for-bottom-up-direction arch/s390/mm/mmap.c
--- a/arch/s390/mm/mmap.c~s390-mmap-randomize-mmap-base-for-bottom-up-direction
+++ a/arch/s390/mm/mmap.c
@@ -64,6 +64,11 @@ static unsigned long mmap_rnd(void)
 	return (get_random_int() & 0x7ffUL) << PAGE_SHIFT;
 }
 
+static unsigned long mmap_base_legacy(void)
+{
+	return TASK_UNMAPPED_BASE + mmap_rnd();
+}
+
 static inline unsigned long mmap_base(void)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
@@ -89,7 +94,7 @@ void arch_pick_mmap_layout(struct mm_str
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
 	if (mmap_is_legacy()) {
-		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->mmap_base = mmap_base_legacy();
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
 		mm->mmap_base = mmap_base();
@@ -164,7 +169,7 @@ void arch_pick_mmap_layout(struct mm_str
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
 	if (mmap_is_legacy()) {
-		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->mmap_base = mmap_base_legacy();
 		mm->get_unmapped_area = s390_get_unmapped_area;
 	} else {
 		mm->mmap_base = mmap_base();
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
s390-handle-pgtable_page_ctor-fail.patch

