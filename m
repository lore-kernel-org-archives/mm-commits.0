Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393C5C43334
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jul 2022 03:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiGUDJj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Jul 2022 23:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiGUDJg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2022 23:09:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413147755D
        for <mm-commits@vger.kernel.org>; Wed, 20 Jul 2022 20:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC19BB821F0
        for <mm-commits@vger.kernel.org>; Thu, 21 Jul 2022 03:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E06BC3411E;
        Thu, 21 Jul 2022 03:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658372972;
        bh=/uw/ERRpmbrNFt6PL+iU6ZcOPMN8pnw1y7gM9Wzvi/4=;
        h=Date:To:From:Subject:From;
        b=mwPICY+cuP5hSFSefp/ML8JGBYqI51sy+ItTpE3HO/stHAXNMIn0QESdEtwsvNpS3
         yHRCH9xXR1/TnkO2TbzdzHtwSdIhubNaAjfoBZu6wsylDx5d/GBBQSukvkpTO60VeC
         lI4uqPHV0t41z/DNJLwbgblYMqRYpCeJhuMIHZhI=
Date:   Wed, 20 Jul 2022 20:09:31 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable.patch added to mm-unstable branch
Message-Id: <20220721030932.6E06BC3411E@smtp.kernel.org>
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
Date: Wed, 20 Jul 2022 18:03:24 -0400

The check wanted to make sure when soft-dirty tracking is enabled we won't
grant write bit by accident, as a page fault is needed for dirty tracking.
The intention is correct but we didn't check it right because
VM_SOFTDIRTY set actually means soft-dirty tracking disabled.  Fix it.

It wasn't a bug for a long time because we used to only optimize the write
bit settings in change_pte_range() for page caches, and since we've got a
higher level check in vma_wants_writenotify(), we will never set the bit
MM_CP_TRY_CHANGE_WRITABLE for soft-dirty enabled page caches, hence even
if we checked with the wrong value of VM_SOFTDIRTY in change_pte_range()
it'll just be an no-op.  Functionally it was still correct, even if cpu
cycles wasted.

However after the recent work of anonymous page optimization on exclusive
pages we'll start to make it wrong because anonymous page does not require
the check in vma_wants_writenotify() hence it'll suffer from the wrong
check here in can_change_pte_writable().

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
              printf("ERROR: %s, soft-dirty=%d (expect: %d)\n", str, dirty, expect); \
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
      printf("Test passed.\n");

      return 0;
  }
=======8<======

So even if commit 64fe24a3e05e kept the old behavior and didn't attempt to
change the behavior here, the bug will only be able to be triggered after
commit 64fe24a3e05e because only anonymous page will suffer from it.

Link: https://lkml.kernel.org/r/20220720220324.88538-1-peterx@redhat.com
Fixes: 64fe24a3e05e ("mm/mprotect: try avoiding write faults for exclusive anonymous pages when changing protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable
+++ a/mm/mprotect.c
@@ -48,8 +48,11 @@ static inline bool can_change_pte_writab
 	if (pte_protnone(pte) || !pte_dirty(pte))
 		return false;
 
-	/* Do we need write faults for softdirty tracking? */
-	if ((vma->vm_flags & VM_SOFTDIRTY) && !pte_soft_dirty(pte))
+	/*
+	 * Do we need write faults for softdirty tracking?  Note,
+	 * soft-dirty is enabled when !VM_SOFTDIRTY.
+	 */
+	if (!(vma->vm_flags & VM_SOFTDIRTY) && !pte_soft_dirty(pte))
 		return false;
 
 	/* Do we need write faults for uffd-wp tracking? */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable.patch

