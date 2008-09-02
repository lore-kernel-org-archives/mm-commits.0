From: akpm@linux-foundation.org
Subject: + x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:08:57 -0700
Message-ID: <200809022208.m82M8vR4015257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950AbYIBWJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, hpa@zytor.com, jeremy@goop.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: adjust vmalloc_sync_all() for Xen (2nd try)
has been added to the -mm tree.  Its filename is
     x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: adjust vmalloc_sync_all() for Xen (2nd try)
From: Jan Beulich <jbeulich@novell.com>

Since the fourth PDPT entry cannot be shared under Xen, vmalloc_sync_all()
must iterate over pmd-s rather than pgd-s here.  Luckily, the code isn't
used for native PAE (SHARED_KERNEL_PMD is 1) and the change is benign to
non-PAE.

Also do a little more cleanup in that function.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN arch/x86/mm/fault.c~x86-adjust-vmalloc_sync_all-for-xen-2nd-try arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~x86-adjust-vmalloc_sync_all-for-xen-2nd-try
+++ a/arch/x86/mm/fault.c
@@ -935,15 +935,15 @@ LIST_HEAD(pgd_list);
 
 void vmalloc_sync_all(void)
 {
-#ifdef CONFIG_X86_32
-	unsigned long start = VMALLOC_START & PGDIR_MASK;
 	unsigned long address;
 
+#ifdef CONFIG_X86_32
 	if (SHARED_KERNEL_PMD)
 		return;
 
-	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
-	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
+	for (address = VMALLOC_START & PMD_MASK;
+	     address >= TASK_SIZE && address < FIXADDR_TOP;
+	     address += PMD_SIZE) {
 		unsigned long flags;
 		struct page *page;
 
@@ -956,10 +956,8 @@ void vmalloc_sync_all(void)
 		spin_unlock_irqrestore(&pgd_lock, flags);
 	}
 #else /* CONFIG_X86_64 */
-	unsigned long start = VMALLOC_START & PGDIR_MASK;
-	unsigned long address;
