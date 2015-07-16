From: akpm@linux-foundation.org
Subject: +
 mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
 added to -mm tree
Date: Thu, 16 Jul 2015 14:56:08 -0700
Message-ID: <55a82878.awv7Z5Wn31yqCFo0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbbGPV4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jul 2015 17:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, emunson@akamai.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2
has been added to the -mm tree.  Its filename is
     mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2

can we just remove the s390 bits which cause the breakage?
I will wire up the syscalls as soon as the patch set gets merged.

Cc: Eric B Munson <emunson@akamai.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/syscalls.S |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/s390/kernel/syscalls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2 arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2
+++ a/arch/s390/kernel/syscalls.S
@@ -363,6 +363,3 @@ SYSCALL(sys_bpf,compat_sys_bpf)
 SYSCALL(sys_s390_pci_mmio_write,compat_sys_s390_pci_mmio_write)
 SYSCALL(sys_s390_pci_mmio_read,compat_sys_s390_pci_mmio_read)
 SYSCALL(sys_execveat,compat_sys_execveat)
-SYSCALL(sys_mlock2,compat_sys_mlock2)			/* 355 */
-SYSCALL(sys_munlock2,compat_sys_munlock2)
-SYSCALL(sys_munlockall2,compat_sys_munlockall2)
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
revert-s390-mm-change-hpage_shift-type-to-int.patch
revert-s390-mm-make-hugepages_supported-a-boot-time-decision.patch
mm-hugetlb-allow-hugepages_supported-to-be-architecture-specific.patch
s390-hugetlb-add-hugepages_supported-define.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
linux-next.patch

