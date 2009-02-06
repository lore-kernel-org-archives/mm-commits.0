From: akpm@linux-foundation.org
Subject: [merged] alpha-fixup-bug-macro.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:25 -0800
Message-ID: <200902061938.n16JcPLJ012322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142AbZBFTik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fixup BUG macro
has been removed from the -mm tree.  Its filename was
     alpha-fixup-bug-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: fixup BUG macro
From: Alexey Dobriyan <adobriyan@gmail.com>

Do usual do {} while (0) dance, otherwise

fs/gfs2/util.c:99: error: expected expression before 'else'
drivers/scsi/lpfc/lpfc_sli.c:363: error: expected expression before 'else'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/bug.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/bug.h~alpha-fixup-bug-macro arch/alpha/include/asm/bug.h
--- a/arch/alpha/include/asm/bug.h~alpha-fixup-bug-macro
+++ a/arch/alpha/include/asm/bug.h
@@ -8,12 +8,12 @@
 
 /* ??? Would be nice to use .gprel32 here, but we can't be sure that the
    function loaded the GP, so this could fail in modules.  */
-#define BUG()	{							\
+#define BUG()	do {							\
 	__asm__ __volatile__(						\
 		"call_pal %0  # bugchk\n\t"				\
 		".long %1\n\t.8byte %2"					\
 		: : "i"(PAL_bugchk), "i"(__LINE__), "i"(__FILE__));	\
-	for ( ; ; ); }
+	for ( ; ; ); } while (0)
 
 #define HAVE_ARCH_BUG
 #endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread.patch
seq_file-properly-cope-with-pread-fix.patch
linux-next.patch
eeepc-should-depend-on-input.patch
tags-fix-config-symbols-generation.patch
sm501-fix-section-mismatches.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
sysctl-min-max-range-check-is-broken.patch
xtensa-fix-compilation-somewhat.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

