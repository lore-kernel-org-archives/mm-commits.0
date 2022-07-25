Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AFAC43334
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 22:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbiGYWIN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbiGYWIM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 18:08:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683D52496A
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 15:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 011E761326
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 22:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559FBC341C6;
        Mon, 25 Jul 2022 22:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658786889;
        bh=Z8/vuRhoBDa9lAZ33uC6v9jZVycqRRlE5I4nnL7HzfQ=;
        h=Date:To:From:Subject:From;
        b=PhlvWU6V2DfHwfjHOJlu7Pf3MIbj9KvxfxJBM0gP9yksMQtzp4CCqfeODuLnxToJo
         D9X8SBZv9gbnZH+oL4mJL1NgEKRshALJpdPEVo0HGRp6uZhk8EbFUU3/ZZ15DdayHP
         444QSY4oDsUCpZhENhPzuRH+exfVbbPCsAcFUT+w=
Date:   Mon, 25 Jul 2022 15:08:08 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable.patch removed from -mm tree
Message-Id: <20220725220809.559FBC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mprotect: fix soft-dirty check in can_change_pte_writable()
has been removed from the -mm tree.  Its filename was
     mm-mprotect-fix-soft-dirty-check-in-can_change_pte_writable.patch

This patch was dropped because an updated version will be merged

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


