From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-external-memory-hinting-api-fix-2.patch
 added to -mm tree
Date: Fri, 08 May 2020 13:50:18 -0700
Message-ID: <20200508205018.nAA5qYORO%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbgEHUuT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 16:50:19 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, minchan@kernel.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm: fix build error for mips of process_madvise
has been added to the -mm tree.  Its filename is
     mm-introduce-external-memory-hinting-api-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-external-memory-hinting-api-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-external-memory-hinting-api-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -425,3 +425,4 @@
 435	o32	clone3				__sys_clone3
 437	o32	openat2				sys_openat2
 438	o32	pidfd_getfd			sys_pidfd_getfd
+439	o32	process_madvise			sys_process_madvise		compat_sys_process_madvise
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api.patch
mm-introduce-external-memory-hinting-api-fix.patch
mm-introduce-external-memory-hinting-api-fix-2.patch
mm-check-fatal-signal-pending-of-target-process.patch
pid-move-pidfd_get_pid-function-to-pidc.patch
mm-support-both-pid-and-pidfd-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch
