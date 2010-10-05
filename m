From: akpm@linux-foundation.org
Subject: + x86-access_error-api-cleanup.patch added to -mm tree
Date: Tue, 05 Oct 2010 13:15:28 -0700
Message-ID: <201010052015.o95KFS9l017434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718Ab0JEUWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 16:22:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, hpa@zytor.com, mingo@elte.hu, nickpiggin@yahoo.com.au, riel@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, yinghan@google.com


The patch titled
     x86: access_error API cleanup
has been added to the -mm tree.  Its filename is
     x86-access_error-api-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: access_error API cleanup
From: Michel Lespinasse <walken@google.com>

access_error() already takes error_code as an argument, so there is
no need for an additional write flag.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/fault.c~x86-access_error-api-cleanup arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~x86-access_error-api-cleanup
+++ a/arch/x86/mm/fault.c
@@ -899,9 +899,9 @@ spurious_fault(unsigned long error_code,
 int show_unhandled_signals = 1;
 
 static inline int
-access_error(unsigned long error_code, int write, struct vm_area_struct *vma)
+access_error(unsigned long error_code, struct vm_area_struct *vma)
 {
-	if (write) {
+	if (error_code & PF_WRITE) {
 		/* write, present and write, not present: */
 		if (unlikely(!(vma->vm_flags & VM_WRITE)))
 			return 1;
@@ -1094,7 +1094,7 @@ retry:
 	 * we can handle it..
 	 */
 good_area:
-	if (unlikely(access_error(error_code, write, vma))) {
+	if (unlikely(access_error(error_code, vma))) {
 		bad_area_access_error(regs, error_code, address);
 		return;
 	}
_

Patches currently in -mm which might be from walken@google.com are

mm-filemap_fault-unique-path-for-locking-page.patch
mm-retry-page-fault-when-blocking-on-disk-transfer.patch
x86-access_error-api-cleanup.patch

