From: akpm@linux-foundation.org
Subject: [alternative-merged] mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch removed from -mm tree
Date: Wed, 06 Feb 2013 12:53:01 -0800
Message-ID: <20130206205302.54C375A42CB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:49837 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105Ab3BFUxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 15:53:03 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so197213vcd.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 12:53:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make mlockall preserve flags other than VM_LOCKED in def_flags
has been removed from the -mm tree.  Its filename was
     mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: make mlockall preserve flags other than VM_LOCKED in def_flags

We have many vma manipulation functions that are fast in the typical case,
but can optionally be instructed to populate an unbounded number of ptes
within the region they work on:

- mmap with MAP_POPULATE or MAP_LOCKED flags;
- remap_file_pages() with MAP_NONBLOCK not set or when working on a
  VM_LOCKED vma;
- mmap_region() and all its wrappers when mlock(MCL_FUTURE) is in effect;
- brk() when mlock(MCL_FUTURE) is in effect.

Current code handles these pte operations locally, while the sourrounding
code has to hold the mmap_sem write side since it's manipulating vmas. 
This means we're doing an unbounded amount of pte population work with
mmap_sem held, and this causes problems as Andy Lutomirski reported (we've
hit this at Google as well, though it's not entirely clear why people keep
trying to use mlock(MCL_FUTURE) in the first place).

I propose introducing a new mm_populate() function to do this pte
population work after the mmap_sem has been released.  mm_populate() does
need to acquire the mmap_sem read side, but critically, it doesn't need to
hold it continuously for the entire duration of the operation - it can
drop it whenever things take too long (such as when hitting disk for a
file read) and re-acquire it later on.

The following patches are included

- Patches 1-2 fix some issues I noticed while working on the existing code.
  If needed, they could potentially go in before the rest of the patches.

- Patch 3 introduces the new mm_populate() function and changes
  mmap_region() call sites to use it after they drop mmap_sem. This is
  inspired from Andy Lutomirski's proposal and is built as an extension
  of the work I had previously done for mlock() and mlockall() around
  v2.6.38-rc1. I had tried doing something similar at the time but had
  given up as there were so many do_mmap() call sites; the recent cleanups
  by Linus and Viro are a tremendous help here.

- Patches 4-6 convert some of the less-obvious places doing unbounded
  pte populates to the new mm_populate() mechanism.

- Patches 7-8 are code cleanups that are made possible by the
  mm_populate() work. In particular, they remove more code than the
  entire patch series added, which should be a good thing :)

- Patch 9 is optional to this entire series. It only helps to deal more
  nicely with racy userspace programs that might modify their mappings
  while we're trying to populate them. It adds a new VM_POPULATE flag
  on the mappings we do want to populate, so that if userspace replaces
  them with mappings it doesn't want populated, mm_populate() won't
  populate those replacement mappings.



This patch:

On most architectures, def_flags is either 0 or VM_LOCKED depending on
whether mlockall(MCL_FUTURE) was called.  However, this is not an absolute
rule as kvm support on s390 may set the VM_NOHUGEPAGE flag in def_flags. 
We don't want mlockall to clear that.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/mlock.c~mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags mm/mlock.c
--- a/mm/mlock.c~mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags
+++ a/mm/mlock.c
@@ -517,10 +517,11 @@ SYSCALL_DEFINE2(munlock, unsigned long, 
 static int do_mlockall(int flags)
 {
 	struct vm_area_struct * vma, * prev = NULL;
-	unsigned int def_flags = 0;
+	unsigned int def_flags;
 
+	def_flags = current->mm->def_flags & ~VM_LOCKED;
 	if (flags & MCL_FUTURE)
-		def_flags = VM_LOCKED;
+		def_flags |= VM_LOCKED;
 	current->mm->def_flags = def_flags;
 	if (flags == MCL_FUTURE)
 		goto out;
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix.patch
mm-accelerate-mm_populate-treatment-of-thp-pages.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-remove-free_area_cache.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mm-use-vm_unmapped_area-on-alpha-architecture.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

