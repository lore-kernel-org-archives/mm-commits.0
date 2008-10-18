From: akpm@linux-foundation.org
Subject: - make-kprobesc-kretprobe_table_lock-static.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:37 -0700
Message-ID: <200810182320.m9INKbxB029802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943AbYJRXUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ananth@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     make kprobes.c:kretprobe_table_lock() static
has been removed from the -mm tree.  Its filename was
     make-kprobesc-kretprobe_table_lock-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make kprobes.c:kretprobe_table_lock() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global kretprobe_table_lock() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kprobes.c~make-kprobesc-kretprobe_table_lock-static kernel/kprobes.c
--- a/kernel/kprobes.c~make-kprobesc-kretprobe_table_lock-static
+++ a/kernel/kprobes.c
@@ -404,7 +404,7 @@ void kretprobe_hash_lock(struct task_str
 	spin_lock_irqsave(hlist_lock, *flags);
 }
 
-void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
+static void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_lock_irqsave(hlist_lock, *flags);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch

