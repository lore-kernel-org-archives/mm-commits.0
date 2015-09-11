From: akpm@linux-foundation.org
Subject: +
 mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9.patch added to
 -mm tree
Date: Fri, 11 Sep 2015 15:12:09 -0700
Message-ID: <55f351b9.jVNRSVIOaqrxAI9P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbbIKWMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, linux@roeck-us.net, mhocko@suse.com, mtk.manpages@gmail.com, ralf@linux-mips.org, sfr@canb.auug.org.au, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9
has been added to the -mm tree.  Its filename is
     mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9

Signed-off-by: Eric B Munson <emunson@akamai.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/mlock.c~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9 mm/mlock.c
--- a/mm/mlock.c~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9
+++ a/mm/mlock.c
@@ -578,8 +578,7 @@ static int apply_vma_lock_flags(unsigned
 		prev = vma;
 
 	for (nstart = start ; ; ) {
-		vm_flags_t newflags =
-			vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
+		vm_flags_t newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
 
 		newflags |= flags;
 
@@ -688,7 +687,7 @@ static int apply_mlockall_flags(int flag
 	struct vm_area_struct * vma, * prev = NULL;
 	vm_flags_t to_add = 0;
 
-	current->mm->def_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
+	current->mm->def_flags &= VM_LOCKED_CLEAR_MASK;
 	if (flags & MCL_FUTURE) {
 		current->mm->def_flags |= VM_LOCKED;
 
@@ -708,7 +707,7 @@ static int apply_mlockall_flags(int flag
 	for (vma = current->mm->mmap; vma ; vma = prev->vm_next) {
 		vm_flags_t newflags;
 
-		newflags = vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
+		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
 		newflags |= to_add;
 
 		/* Ignore errors */
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-introduce-vm_lockonfault-v9.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v9.patch
mips-add-entry-for-new-mlock2-syscall.patch

