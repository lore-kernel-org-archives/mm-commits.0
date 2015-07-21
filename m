From: akpm@linux-foundation.org
Subject: + mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch added
 to -mm tree
Date: Tue, 21 Jul 2015 13:55:50 -0700
Message-ID: <55aeb1d6.BSQrpW1aBHk/Zia0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbbGUUzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 16:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, mhocko@suse.cz, mtk.manpages@gmail.com, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4
has been added to the -mm tree.  Its filename is
     mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch

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
Subject: mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4

Add missing MAP_LOCKONFAULT to tile

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/uapi/asm/mman.h |    1 +
 kernel/events/core.c              |    2 ++
 mm/mmap.c                         |    4 +++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/tile/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4 arch/tile/include/uapi/asm/mman.h
--- a/arch/tile/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4
+++ a/arch/tile/include/uapi/asm/mman.h
@@ -29,6 +29,7 @@
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
 #define MAP_HUGETLB	0x4000		/* create a huge page mapping */
+#define MAP_LOCKONFAULT	0x100000	/* Lock pages after they are faulted in, do not prefault */
 
 
 /*
diff -puN kernel/events/core.c~mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4 kernel/events/core.c
--- a/kernel/events/core.c~mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4
+++ a/kernel/events/core.c
@@ -5816,6 +5816,8 @@ static void perf_event_mmap_event(struct
 			flags |= MAP_EXECUTABLE;
 		if (vma->vm_flags & VM_LOCKED)
 			flags |= MAP_LOCKED;
+		if (vma->vm_flags & VM_LOCKONFAULT)
+			flags |= MAP_LOCKONFAULT;
 		if (vma->vm_flags & VM_HUGETLB)
 			flags |= MAP_HUGETLB;
 
diff -puN mm/mmap.c~mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4 mm/mmap.c
--- a/mm/mmap.c~mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4
+++ a/mm/mmap.c
@@ -2691,12 +2691,14 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 		flags |= MAP_LOCKED;
 		drop_lock_flag = VM_LOCKED;
 	} else if (vma->vm_flags & VM_LOCKONFAULT) {
+		flags |= MAP_LOCKONFAULT;
 		drop_lock_flag = VM_LOCKONFAULT;
 	}
 
+
 	if (drop_lock_flag)
 		/* drop PG_Mlocked flag for over-mapped range */
-		munlock_vma_pages_range(vma, start, start + size, VM_LOCKED);
+		munlock_vma_pages_range(vma, start, start + size, drop_lock_flag);
 
 	file = get_file(vma->vm_file);
 	ret = do_mmap_pgoff(vma->vm_file, start, size,
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
mm-gup-add-mm_lock_present.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v4.patch

