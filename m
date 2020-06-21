From: akpm@linux-foundation.org
Subject: + all-arch-remove-system-call-sys_sysctl-fix.patch added to
 -mm tree
Date: Sat, 20 Jun 2020 17:44:52 -0700
Message-ID: <20200621004452.xdTV_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728531AbgFUAox (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 20:44:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lkp@intel.com, heiko.carstens@de.ibm.com, nixiaoming@huawei.com


The patch titled
     Subject: s390: fix build error for sys_call_table_emu
has been added to the -mm tree.  Its filename is
     all-arch-remove-system-call-sys_sysctl-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/all-arch-remove-system-call-sys_sysctl-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/all-arch-remove-system-call-sys_sysctl-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: s390: fix build error for sys_call_table_emu

Build error on s390:
	arch/s390/kernel/entry.o: in function `sys_call_table_emu':
	>> (.rodata+0x1288): undefined reference to `__s390_'

In commit ("All arch: remove system call sys_sysctl")
 148  common	fdatasync		sys_fdatasync			sys_fdatasync
-149  common	_sysctl			sys_sysctl			compat_sys_sysctl
+149  common	_sysctl			sys_ni_syscall
 150  common	mlock			sys_mlock			sys_mlock

After the patch is integrated, there is a format error in the generated
arch/s390/include/generated/asm/syscall_table.h:
	SYSCALL(sys_fdatasync, sys_fdatasync)
	SYSCALL(sys_ni_syscall,) /* cause build error */
	SYSCALL(sys_mlock,sys_mlock)

According to the guidance of Heiko Carstens, use "-" to fill the empty
system call Similarly, modify
tools/perf/arch/s390/entry/syscalls/syscall.tbl.

Link: http://lkml.kernel.org/r/20200618141426.16884-1-nixiaoming@huawei.com
Fixes: ("All arch: remove system call sys_sysctl")
Fixes: https://lore.kernel.org/linuxppc-dev/20200616030734.87257-1-nixiaoming@huawei.com/
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/syscalls/syscall.tbl           |    2 +-
 tools/perf/arch/s390/entry/syscalls/syscall.tbl |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-sys_sysctl-fix
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -138,7 +138,7 @@
 146  common	writev			sys_writev			compat_sys_writev
 147  common	getsid			sys_getsid			sys_getsid
 148  common	fdatasync		sys_fdatasync			sys_fdatasync
-149  common	_sysctl			sys_ni_syscall
+149  common	_sysctl			-				-
 150  common	mlock			sys_mlock			sys_mlock
 151  common	munlock			sys_munlock			sys_munlock
 152  common	mlockall		sys_mlockall			sys_mlockall
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl~all-arch-remove-system-call-sys_sysctl-fix
+++ a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -138,7 +138,7 @@
 146  common	writev			sys_writev			compat_sys_writev
 147  common	getsid			sys_getsid			sys_getsid
 148  common	fdatasync		sys_fdatasync			sys_fdatasync
-149  common	_sysctl			sys_ni_syscall
+149  common	_sysctl			-				-
 150  common	mlock			sys_mlock			compat_sys_mlock
 151  common	munlock			sys_munlock			compat_sys_munlock
 152  common	mlockall		sys_mlockall			sys_mlockall
_

Patches currently in -mm which might be from nixiaoming@huawei.com are

all-arch-remove-system-call-sys_sysctl.patch
all-arch-remove-system-call-sys_sysctl-fix.patch
