From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-introduce-external-memory-hinting-api-fix-2.patch removed from -mm tree
Date: Wed, 10 Jun 2020 18:22:38 -0700
Message-ID: <20200611012238.IQSmhBlM-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgFKBWj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, minchan@kernel.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm: fix build error for mips of process_madvise
has been removed from the -mm tree.  Its filename was
     mm-introduce-external-memory-hinting-api-fix-2.patch

This patch was dropped because it was folded into mm-introduce-external-memory-hinting-api.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix build error for mips of process_madvise

kbuild test rebot reported build break of process_madvise for mips[1].
This patch should fix it.

[1] https://lore.kernel.org/linux-mm/202005080716.cUcbCQ3i%25lkp@intel.com/
Link: http://lkml.kernel.org/r/20200508052517.GA197378@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: kbuild test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/syscalls/syscall_o32.tbl |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~mm-introduce-external-memory-hinting-api-fix-2
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -426,3 +426,4 @@
 437	o32	openat2				sys_openat2
 438	o32	pidfd_getfd			sys_pidfd_getfd
 439	o32	faccessat2			sys_faccessat2
+440	o32	process_madvise			sys_process_madvise		compat_sys_process_madvise
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api.patch
mm-check-fatal-signal-pending-of-target-process.patch
pid-move-pidfd_get_pid-function-to-pidc.patch
mm-support-both-pid-and-pidfd-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch
mm-use-only-pidfd-for-process_madvise-syscall.patch
mm-use-only-pidfd-for-process_madvise-syscall-fix.patch
