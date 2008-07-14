From: akpm@linux-foundation.org
Subject: - use-warn-in-kernel-panicc.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:34:33 -0700
Message-ID: <200807141934.m6EJYXrg023830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260AbYGNTeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Use WARN() in kernel/panic.c
has been removed from the -mm tree.  Its filename was
     use-warn-in-kernel-panicc.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN() in kernel/panic.c
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message becomes
part of the warning section for better reporting/collection.  This allowed the
if() to be folded entirely into the WARN()

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/panic.c~use-warn-in-kernel-panicc kernel/panic.c
--- a/kernel/panic.c~use-warn-in-kernel-panicc
+++ a/kernel/panic.c
@@ -392,10 +392,8 @@ static int __stack_chk_test(void)
 	printk(KERN_INFO "Testing -fstack-protector-all feature\n");
 	__stack_check_testing = (unsigned long)&__stack_chk_test_func;
 	__stack_chk_test_func();
-	if (__stack_check_testing) {
-		printk(KERN_ERR "-fstack-protector-all test failed\n");
-		WARN_ON(1);
-	}
+	WARN(__stack_check_testing,
+			KERN_ERR "-fstack-protector-all test failed\n");
 	return 0;
 }
 /*
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
example-use-of-warn.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-kernel-panicc.patch
use-warn-in-mm-vmallocc.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
use-warn-in-block.patch
use-warn-in-drivers-base.patch
use-warn-in-lib.patch
use-warn-in-fs.patch
usr-warn-in-fs-sysfs.patch
use-warn-in-fs-proc.patch

