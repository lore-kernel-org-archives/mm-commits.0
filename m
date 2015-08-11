From: akpm@linux-foundation.org
Subject: + mm-mlock-refactor-mlock-munlock-and-munlockall-code-v7.patch
 added to -mm tree
Date: Tue, 11 Aug 2015 15:05:57 -0700
Message-ID: <55ca71c5.pfeITn9P1YmSjBF5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbbHKWGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 18:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, kirill.shutemov@linux.intel.com, kirill@shutemov.name, mhocko@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-refactor-mlock-munlock-and-munlockall-code-v7
has been added to the -mm tree.  Its filename is
     mm-mlock-refactor-mlock-munlock-and-munlockall-code-v7.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-refactor-mlock-munlock-and-munlockall-code-v7.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-refactor-mlock-munlock-and-munlockall-code-v7.patch

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
Subject: mm-mlock-refactor-mlock-munlock-and-munlockall-code-v7

Extending the mlock system call is very difficult because it currently
does not take a flags argument.  A later patch in this set will extend
mlock to support a middle ground between pages that are locked and
faulted in immediately and unlocked pages.  To pave the way for the new
system call, the code needs some reorganization so that all the actual
entry point handles is checking input and translating to VMA flags.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mlock.c~mm-mlock-refactor-mlock-munlock-and-munlockall-code-v7 mm/mlock.c
--- a/mm/mlock.c~mm-mlock-refactor-mlock-munlock-and-munlockall-code-v7
+++ a/mm/mlock.c
@@ -578,6 +578,7 @@ static int apply_vma_lock_flags(unsigned
 
 	for (nstart = start ; ; ) {
 		vm_flags_t newflags = vma->vm_flags & ~VM_LOCKED;
+
 		newflags |= flags;
 
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code-v7.patch
mm-mlock-add-new-mlock-system-call.patch
mm-mlock-add-new-mlock-system-call-v7.patch
mm-introduce-vm_lockonfault.patch
mm-introduce-vm_lockonfault-v7.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v7.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch

