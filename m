Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9E9C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 21:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiKUVeB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 16:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiKUVdv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 16:33:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C35EC4949
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 13:33:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 224316145D
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 21:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCC3C433C1;
        Mon, 21 Nov 2022 21:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669066428;
        bh=nMFAfA9KWceKD3gjItMMT+rKaBqS56T6EVTZZi3jYG4=;
        h=Date:To:From:Subject:From;
        b=jhmQzD+11ri3NfFtLQRCzNWtETHLCSjgABhWcaHPoTBHx4bFvIquIdrFf3EtX0JfN
         2XgVjDTMET14QyUFSXDGlEBKGfx1qI+dRLSXsRRNoP7UA4z4AlUu2T1ecwHBksE+De
         o0S7VF157KT/uYFQGNPq9m3qqWCOmdbkYl0YuaHo=
Date:   Mon, 21 Nov 2022 13:33:47 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+f0b97304ef90f0d0b1dc@syzkaller.appspotmail.com,
        peterx@redhat.com, mike.kravetz@oracle.com, jhubbard@nvidia.com,
        jgg@nvidia.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-disallow-foll_forcefoll_write-on-hugetlb-mappings.patch added to mm-unstable branch
Message-Id: <20221121213348.6FCC3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: disallow FOLL_FORCE|FOLL_WRITE on hugetlb mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-disallow-foll_forcefoll_write-on-hugetlb-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-disallow-foll_forcefoll_write-on-hugetlb-mappings.patch

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
Subject: mm/gup: disallow FOLL_FORCE|FOLL_WRITE on hugetlb mappings
Date: Mon, 31 Oct 2022 16:25:24 +0100

hugetlb does not support fake write-faults (write faults without write
permissions).  However, we are currently able to trigger a
FAULT_FLAG_WRITE fault on a VMA without VM_WRITE.

If we'd ever want to support FOLL_FORCE|FOLL_WRITE, we'd have to teach
hugetlb to:

(1) Leave the page mapped R/O after the fake write-fault, like
    maybe_mkwrite() does.
(2) Allow writing to an exclusive anon page that's mapped R/O when
    FOLL_FORCE is set, like can_follow_write_pte(). E.g.,
    __follow_hugetlb_must_fault() needs adjustment.

For now, it's not clear if that added complexity is really required. 
History tolds us that FOLL_FORCE is dangerous and that we better limit its
use to a bare minimum.

--------------------------------------------------------------------------
  #include <stdio.h>
  #include <stdlib.h>
  #include <fcntl.h>
  #include <unistd.h>
  #include <errno.h>
  #include <stdint.h>
  #include <sys/mman.h>
  #include <linux/mman.h>

  int main(int argc, char **argv)
  {
          char *map;
          int mem_fd;

          map = mmap(NULL, 2 * 1024 * 1024u, PROT_READ,
                     MAP_PRIVATE|MAP_ANON|MAP_HUGETLB|MAP_HUGE_2MB, -1, 0);
          if (map == MAP_FAILED) {
                  fprintf(stderr, "mmap() failed: %d\n", errno);
                  return 1;
          }

          mem_fd = open("/proc/self/mem", O_RDWR);
          if (mem_fd < 0) {
                  fprintf(stderr, "open(/proc/self/mem) failed: %d\n", errno);
                  return 1;
          }

          if (pwrite(mem_fd, "0", 1, (uintptr_t) map) == 1) {
                  fprintf(stderr, "write() succeeded, which is unexpected\n");
                  return 1;
          }

          printf("write() failed as expected: %d\n", errno);
          return 0;
  }
--------------------------------------------------------------------------

Fortunately, we have a sanity check in hugetlb_wp() in place ever since
commit 1d8d14641fd9 ("mm/hugetlb: support write-faults in shared
mappings"), that bails out instead of silently mapping a page writable in
a !PROT_WRITE VMA.

Consequently, above reproducer triggers a warning, similar to the one
reported by szsbot:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3612 at mm/hugetlb.c:5313 hugetlb_wp+0x20a/0x1af0 mm/hugetlb.c:5313
Modules linked in:
CPU: 1 PID: 3612 Comm: syz-executor250 Not tainted 6.1.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
RIP: 0010:hugetlb_wp+0x20a/0x1af0 mm/hugetlb.c:5313
Code: ea 03 80 3c 02 00 0f 85 31 14 00 00 49 8b 5f 20 31 ff 48 89 dd 83 e5 02 48 89 ee e8 70 ab b7 ff 48 85 ed 75 5b e8 76 ae b7 ff <0f> 0b 41 bd 40 00 00 00 e8 69 ae b7 ff 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc90003caf620 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000008640070 RCX: 0000000000000000
RDX: ffff88807b963a80 RSI: ffffffff81c4ed2a RDI: 0000000000000007
RBP: 0000000000000000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000008c07e R12: ffff888023805800
R13: 0000000000000000 R14: ffffffff91217f38 R15: ffff88801d4b0360
FS:  0000555555bba300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff7a47a1b8 CR3: 000000002378d000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 hugetlb_no_page mm/hugetlb.c:5755 [inline]
 hugetlb_fault+0x19cc/0x2060 mm/hugetlb.c:5874
 follow_hugetlb_page+0x3f3/0x1850 mm/hugetlb.c:6301
 __get_user_pages+0x2cb/0xf10 mm/gup.c:1202
 __get_user_pages_locked mm/gup.c:1434 [inline]
 __get_user_pages_remote+0x18f/0x830 mm/gup.c:2187
 get_user_pages_remote+0x84/0xc0 mm/gup.c:2260
 __access_remote_vm+0x287/0x6b0 mm/memory.c:5517
 ptrace_access_vm+0x181/0x1d0 kernel/ptrace.c:61
 generic_ptrace_pokedata kernel/ptrace.c:1323 [inline]
 ptrace_request+0xb46/0x10c0 kernel/ptrace.c:1046
 arch_ptrace+0x36/0x510 arch/x86/kernel/ptrace.c:828
 __do_sys_ptrace kernel/ptrace.c:1296 [inline]
 __se_sys_ptrace kernel/ptrace.c:1269 [inline]
 __x64_sys_ptrace+0x178/0x2a0 kernel/ptrace.c:1269
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
[...]

So let's silence that warning by teaching GUP code that FOLL_FORCE -- so
far -- does not apply to hugetlb.

Note that FOLL_FORCE for read-access seems to be working as expected.  The
assumption is that this has been broken forever, only ever since above
commit, we actually detect the wrong handling and WARN_ON_ONCE().

I assume this has been broken at least since 2014, when mm/gup.c came to
life.  I failed to come up with a suitable Fixes tag quickly.

Note that this patch will probably break RDMA on kernels 6.0 and earlier. 
The patch series "mm/ksm: break_ksm() cleanups and fixes" (queued for 6.2)
will avoid this breakage.

Link: https://lkml.kernel.org/r/20221031152524.173644-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: <syzbot+f0b97304ef90f0d0b1dc@syzkaller.appspotmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/gup.c~mm-gup-disallow-foll_forcefoll_write-on-hugetlb-mappings
+++ a/mm/gup.c
@@ -944,6 +944,9 @@ static int check_vma_flags(struct vm_are
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
+			/* hugetlb does not support FOLL_FORCE|FOLL_WRITE. */
+			if (is_vm_hugetlb_page(vma))
+				return -EFAULT;
 			/*
 			 * We used to let the write,force case do COW in a
 			 * VM_MAYWRITE VM_SHARED !VM_WRITE vma, so ptrace could
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch
selftests-vm-anon_cow-prepare-for-non-anonymous-cow-tests.patch
selftests-vm-cow-basic-cow-tests-for-non-anonymous-pages.patch
selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch
mm-add-early-fault_flag_unshare-consistency-checks.patch
mm-add-early-fault_flag_write-consistency-checks.patch
mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch
mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch
mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch
mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings.patch
rdma-umem-remove-foll_force-usage.patch
rdma-usnic-remove-foll_force-usage.patch
rdma-siw-remove-foll_force-usage.patch
media-videobuf-dma-sg-remove-foll_force-usage.patch
drm-etnaviv-remove-foll_force-usage.patch
media-pci-ivtv-remove-foll_force-usage.patch
mm-frame-vector-remove-foll_force-usage.patch
drm-exynos-remove-foll_force-usage.patch
rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch
habanalabs-remove-foll_force-usage.patch
mm-gup-disallow-foll_forcefoll_write-on-hugetlb-mappings.patch

