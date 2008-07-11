From: akpm@linux-foundation.org
Subject: + use-warn-in-arch-x86-mm-pageattrc.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:45:26 -0700
Message-ID: <200807111851.m6BIp7xi031304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756065AbYGKSvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:51:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, mingo@elte.hu


The patch titled
     use WARN() in arch/x86/mm/pageattr.c
has been added to the -mm tree.  Its filename is
     use-warn-in-arch-x86-mm-pageattrc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use WARN() in arch/x86/mm/pageattr.c
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message becomes
part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pageattr-test.c |    3 +--
 arch/x86/mm/pageattr.c      |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/pageattr-test.c~use-warn-in-arch-x86-mm-pageattrc arch/x86/mm/pageattr-test.c
--- a/arch/x86/mm/pageattr-test.c~use-warn-in-arch-x86-mm-pageattrc
+++ a/arch/x86/mm/pageattr-test.c
@@ -216,8 +216,7 @@ static int pageattr_test(void)
 	failed += print_split(&sc);
 
 	if (failed) {
-		printk(KERN_ERR "NOT PASSED. Please report.\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "NOT PASSED. Please report.\n");
 		return -EINVAL;
 	} else {
 		if (print)
diff -puN arch/x86/mm/pageattr.c~use-warn-in-arch-x86-mm-pageattrc arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~use-warn-in-arch-x86-mm-pageattrc
+++ a/arch/x86/mm/pageattr.c
@@ -586,10 +586,9 @@ repeat:
 	if (!pte_val(old_pte)) {
 		if (!primary)
 			return 0;
-		printk(KERN_WARNING "CPA: called for zero pte. "
+		WARN(1, KERN_WARNING "CPA: called for zero pte. "
 		       "vaddr = %lx cpa->vaddr = %lx\n", address,
 		       cpa->vaddr);
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
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

