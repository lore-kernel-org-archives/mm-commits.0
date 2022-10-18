Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0523FC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiJRAqb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiJRAqa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:46:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F101192B6
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:46:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F1C2B81B43
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6FCC433D7;
        Tue, 18 Oct 2022 00:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666053985;
        bh=JEGO+XekyamXt9ySYI/0olmfZw8ZGmk3Sk1T8i+ADFw=;
        h=Date:To:From:Subject:From;
        b=fMvUSRxIyCZFm3z6wBoXhtA0YPWHMiqopBJxIcD3nZfWzHdW8IFwbs/Oo+6dinxg8
         0DKksxXdHL7E+/VlEwr8m3ZjdxGHLeJa2IEauqllQOHhTFowsyVC/4GrpTm9wsxW9f
         k/fGazeymmMLtNjrzSDk7pYg/45J7bYkq88qW17E=
Date:   Mon, 17 Oct 2022 17:46:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch added to mm-unstable branch
Message-Id: <20221018004625.2F6FCC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: fix KSM COW breaking with userfaultfd-wp via FAULT_FLAG_UNSHARE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/ksm: fix KSM COW breaking with userfaultfd-wp via FAULT_FLAG_UNSHARE
Date: Fri, 30 Sep 2022 16:19:28 +0200

Let's stop breaking COW via a fake write fault and let's use
FAULT_FLAG_UNSHARE instead.  This avoids any wrong side effects of the
fake write fault, such as mapping the PTE writable and marking the pte
dirty/softdirty.

Also, this fixes KSM interaction with userfaultfd-wp: when we have a KSM
page that's write-protected by userfaultfd, break_ksm()->handle_mm_fault()
will fail with VM_FAULT_SIGBUS and will simpy return in break_ksm() with
0.  The warning in dmesg indicates this wrong handling:

[  230.096368] FAULT_FLAG_ALLOW_RETRY missing 881
[  230.100822] CPU: 1 PID: 1643 Comm: ksm-uffd-wp [...]
[  230.110124] Hardware name: [...]
[  230.117775] Call Trace:
[  230.120227]  <TASK>
[  230.122334]  dump_stack_lvl+0x44/0x5c
[  230.126010]  handle_userfault.cold+0x14/0x19
[  230.130281]  ? tlb_finish_mmu+0x65/0x170
[  230.134207]  ? uffd_wp_range+0x65/0xa0
[  230.137959]  ? _raw_spin_unlock+0x15/0x30
[  230.141972]  ? do_wp_page+0x50/0x590
[  230.145551]  __handle_mm_fault+0x9f5/0xf50
[  230.149652]  ? mmput+0x1f/0x40
[  230.152712]  handle_mm_fault+0xb9/0x2a0
[  230.156550]  break_ksm+0x141/0x180
[  230.159964]  unmerge_ksm_pages+0x60/0x90
[  230.163890]  ksm_madvise+0x3c/0xb0
[  230.167295]  do_madvise.part.0+0x10c/0xeb0
[  230.171396]  ? do_syscall_64+0x67/0x80
[  230.175157]  __x64_sys_madvise+0x5a/0x70
[  230.179082]  do_syscall_64+0x58/0x80
[  230.182661]  ? do_syscall_64+0x67/0x80
[  230.186413]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

--------------------------------------------------------------------------

 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
 #include <linux/userfaultfd.h>

 #define MMAP_SIZE (2 * 1024 * 1024u)

 static char *map;
 int uffd;

 static int setup_uffd(void)
 {
 	struct uffdio_api uffdio_api;
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect uffd_writeprotect;
 	struct uffdio_range uffd_range;

 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
 	if (uffd < 0) {
 		fprintf(stderr, "syscall() failed: %d\n", errno);
 		return -errno;
 	}

 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = UFFD_FEATURE_PAGEFAULT_FLAG_WP;
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) < 0) {
 		fprintf(stderr, "UFFDIO_API failed: %d\n", errno);
 		return -errno;
 	}

 	if (!(uffdio_api.features & UFFD_FEATURE_PAGEFAULT_FLAG_WP)) {
 		fprintf(stderr, "UFFD_FEATURE_WRITEPROTECT missing\n");
 		return -ENOSYS;
 	}

 	/* Register UFFD-WP */
 	uffdio_register.range.start = (unsigned long) map;
 	uffdio_register.range.len = MMAP_SIZE;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) < 0) {
 		fprintf(stderr, "UFFDIO_REGISTER failed: %d\n", errno);
 		return -errno;
 	}

 	/* Writeprotect the range. */
 	uffd_writeprotect.range.start = (unsigned long) map;
 	uffd_writeprotect.range.len = MMAP_SIZE;
 	uffd_writeprotect.mode = UFFDIO_WRITEPROTECT_MODE_WP;
 	if (ioctl(uffd, UFFDIO_WRITEPROTECT, &uffd_writeprotect)) {
 		fprintf(stderr, "UFFDIO_WRITEPROTECT failed: %d\n", errno);
 		return -errno;
 	}

 	return 0;
 }

 int main(int argc, char **argv)
 {
 	int ksm_fd, ret;

 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0) {
 		fprintf(stderr, "KSM not available\n");
 		return -errno;
 	}

 	map = mmap(NULL, MMAP_SIZE, PROT_READ|PROT_WRITE,
 		   MAP_PRIVATE|MAP_ANON, -1, 0);
 	if (map == MAP_FAILED) {
 		fprintf(stderr, "mmap() failed\n");
 		return -errno;
 	}
 	ret = madvise(map, MMAP_SIZE, MADV_NOHUGEPAGE);
 	if (ret) {
 		fprintf(stderr, "MADV_NOHUGEPAGE failed\n");
 		return -errno;
 	}

 	/* Fill with same value and trigger merging. */
 	memset(map, 0xff, MMAP_SIZE);
 	ret = madvise(map, MMAP_SIZE, MADV_MERGEABLE);
 	if (ret) {
 		fprintf(stderr, "MADV_MERGEABLE failed\n");
 		return -errno;
 	}

 	/*
 	 * Run KSM to trigger merging and wait a bit until merging should be
 	 * done.
 	 */
 	if (write(ksm_fd, "1", 1) != 1) {
 		fprintf(stderr, "Running KSM failed\n");
 	}
 	sleep(10);

 	/* Write-protect the range with UFFD. */
 	if (setup_uffd())
 		return 1;

 	/* Trigger unsharing. */
 	ret = madvise(map, MMAP_SIZE, MADV_UNMERGEABLE);
 	if (ret) {
 		fprintf(stderr, "MADV_UNMERGEABLE failed\n");
 		return -errno;
 	}

 	return 0;
 }

--------------------------------------------------------------------------

Consequently, we will no longer trigger a fake write fault and break COW
without any such side-effects.

This is primarily a fix for KSM+userfaultfd-wp, however, the fake write
fault was always questionable.  As this fix is not easy to backport and
it's not very critical, let's not cc stable.

Link: https://lkml.kernel.org/r/20220930141931.174362-5-david@redhat.com
Fixes: 529b930b87d9 ("userfaultfd: wp: hook userfault handler to write protection fault")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare
+++ a/mm/ksm.c
@@ -420,17 +420,15 @@ static inline bool ksm_test_exit(struct
 }
 
 /*
- * We use break_ksm to break COW on a ksm page: it's a stripped down
+ * We use break_ksm to break COW on a ksm page by triggering unsharing,
+ * such that the ksm page will get replaced by an exclusive anonymous page.
  *
- *	if (get_user_pages(addr, 1, FOLL_WRITE, &page, NULL) == 1)
- *		put_page(page);
- *
- * but taking great care only to touch a ksm page, in a VM_MERGEABLE vma,
+ * We take great care only to touch a ksm page, in a VM_MERGEABLE vma,
  * in case the application has unmapped and remapped mm,addr meanwhile.
  * Could a ksm page appear anywhere else?  Actually yes, in a VM_PFNMAP
  * mmap of /dev/mem, where we would not want to touch it.
  *
- * FAULT_FLAG/FOLL_REMOTE are because we do this outside the context
+ * FAULT_FLAG_REMOTE/FOLL_REMOTE are because we do this outside the context
  * of the process that owns 'vma'.  We also do not want to enforce
  * protection keys here anyway.
  */
@@ -454,7 +452,7 @@ static int break_ksm(struct vm_area_stru
 		if (!ksm_page)
 			return 0;
 		ret = handle_mm_fault(vma, addr,
-				      FAULT_FLAG_WRITE | FAULT_FLAG_REMOTE,
+				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
 				      NULL);
 	} while (!(ret & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | VM_FAULT_OOM)));
 	/*
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

