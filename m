Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF4FCCA48D
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 22:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiGYWLE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237033AbiGYWLB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 18:11:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BF5BE28
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 15:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF059B80ECE
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 22:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FD8C341C6;
        Mon, 25 Jul 2022 22:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658787057;
        bh=22C6V5c3w2vV5AXJn6VMxpyk4e53mhQHgm2VFnS5WTM=;
        h=Date:To:From:Subject:From;
        b=G6FSPp8kgPfJNZLenGceAEMfjjNdy9kMmb+XN7Mhfs6UZuLUxVxULoK+TT1FtfJw/
         /GHaqVXAOX8C006QptCrB5LmtiqzQZUYga3UxTX0HRY7R/YfJBShl0h5SA0Ex83064
         O6pcES4kClwyNisXZU7i0Fp8E5qyQix9l6z7eTmw=
Date:   Mon, 25 Jul 2022 15:10:57 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com, david@redhat.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable.patch added to mm-unstable branch
Message-Id: <20220725221057.A7FD8C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: fix soft-dirty check in can_change_pte_writable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/mprotect: fix soft-dirty check in can_change_pte_writable()
Date: Mon, 25 Jul 2022 10:20:46 -0400

Patch series "mm/mprotect: Fix soft-dirty checks", v4.


This patch (of 3):

The check wanted to make sure when soft-dirty tracking is enabled we won't
grant write bit by accident, as a page fault is needed for dirty tracking.
The intention is correct but we didn't check it right because
VM_SOFTDIRTY set actually means soft-dirty tracking disabled.  Fix it.

There's another thing tricky about soft-dirty is that, we can't check the
vma flag !(vma_flags & VM_SOFTDIRTY) directly but only check it after we
checked CONFIG_MEM_SOFT_DIRTY because otherwise VM_SOFTDIRTY will be
defined as zero, and !(vma_flags & VM_SOFTDIRTY) will constantly return
true.  To avoid misuse, introduce a helper for checking whether vma has
soft-dirty tracking enabled.

We can easily verify this with any exclusive anonymous page, like program
below:

=======8<======
  #include <stdio.h>
  #include <unistd.h>
  #include <stdlib.h>
  #include <assert.h>
  #include <inttypes.h>
  #include <stdint.h>
  #include <sys/types.h>
  #include <sys/mman.h>
  #include <sys/types.h>
  #include <sys/stat.h>
  #include <unistd.h>
  #include <fcntl.h>
  #include <stdbool.h>

  #define BIT_ULL(nr)                   (1ULL << (nr))
  #define PM_SOFT_DIRTY                 BIT_ULL(55)

  unsigned int psize;
  char *page;

  uint64_t pagemap_read_vaddr(int fd, void *vaddr)
  {
      uint64_t value;
      int ret;

      ret = pread(fd, &value, sizeof(uint64_t),
                  ((uint64_t)vaddr >> 12) * sizeof(uint64_t));
      assert(ret == sizeof(uint64_t));

      return value;
  }

  void clear_refs_write(void)
  {
      int fd = open("/proc/self/clear_refs", O_RDWR);

      assert(fd >= 0);
      write(fd, "4", 2);
      close(fd);
  }

  #define  check_soft_dirty(str, expect)  do {                            \
          bool dirty = pagemap_read_vaddr(fd, page) & PM_SOFT_DIRTY;      \
          if (dirty != expect) {                                          \
              printf("ERROR: %s, soft-dirty=%d (expect: %d)
", str, dirty, expect); \
              exit(-1);                                                   \
          }                                                               \
  } while (0)

  int main(void)
  {
      int fd = open("/proc/self/pagemap", O_RDONLY);

      assert(fd >= 0);
      psize = getpagesize();
      page = mmap(NULL, psize, PROT_READ|PROT_WRITE,
                  MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
      assert(page != MAP_FAILED);

      *page = 1;
      check_soft_dirty("Just faulted in page", 1);
      clear_refs_write();
      check_soft_dirty("Clear_refs written", 0);
      mprotect(page, psize, PROT_READ);
      check_soft_dirty("Marked RO", 0);
      mprotect(page, psize, PROT_READ|PROT_WRITE);
      check_soft_dirty("Marked RW", 0);
      *page = 2;
      check_soft_dirty("Wrote page again", 1);

      munmap(page, psize);
      close(fd);
      printf("Test passed.
");

      return 0;
  }
=======8<======

Here we attach a Fixes to commit 64fe24a3e05e only for easy tracking, as
this patch won't apply to a tree before that point.  However the commit
wasn't the source of problem, but instead 64e455079e1b.  It's just that
after 64fe24a3e05e anonymous memory will also suffer from this problem
with mprotect().

Link: https://lkml.kernel.org/r/20220725142048.30450-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20220725142048.30450-2-peterx@redhat.com
Fixes: 64e455079e1b ("mm: softdirty: enable write notifications on VMAs after VM_SOFTDIRTY cleared")
Fixes: 64fe24a3e05e ("mm/mprotect: try avoiding write faults for exclusive anonymous pages when changing protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   18 ++++++++++++++++++
 mm/mmap.c     |    2 +-
 mm/mprotect.c |    2 +-
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable
+++ a/mm/internal.h
@@ -860,4 +860,22 @@ struct folio *try_grab_folio(struct page
 
 DECLARE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
+static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
+{
+	/*
+	 * NOTE: we must check this before VM_SOFTDIRTY on soft-dirty
+	 * enablements, because when without soft-dirty being compiled in,
+	 * VM_SOFTDIRTY is defined as 0x0, then !(vm_flags & VM_SOFTDIRTY)
+	 * will be constantly true.
+	 */
+	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+		return false;
+
+	/*
+	 * Soft-dirty is kind of special: its tracking is enabled when the
+	 * vma flags not set.
+	 */
+	return !(vma->vm_flags & VM_SOFTDIRTY);
+}
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/mmap.c~mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable
+++ a/mm/mmap.c
@@ -1518,7 +1518,7 @@ int vma_wants_writenotify(struct vm_area
 		return 0;
 
 	/* Do we need to track softdirty? */
-	if (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && !(vm_flags & VM_SOFTDIRTY))
+	if (vma_soft_dirty_enabled(vma))
 		return 1;
 
 	/* Specialty mapping? */
--- a/mm/mprotect.c~mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable
+++ a/mm/mprotect.c
@@ -49,7 +49,7 @@ static inline bool can_change_pte_writab
 		return false;
 
 	/* Do we need write faults for softdirty tracking? */
-	if ((vma->vm_flags & VM_SOFTDIRTY) && !pte_soft_dirty(pte))
+	if (vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte))
 		return false;
 
 	/* Do we need write faults for uffd-wp tracking? */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable.patch
selftests-soft-dirty-add-test-for-mprotect.patch
selftests-add-soft-dirty-into-run_vmtestssh.patch

