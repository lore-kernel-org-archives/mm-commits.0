From: akpm@linux-foundation.org
Subject: - uml-fix-nonremovability-of-watchdog.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:02 -0700
Message-ID: <200710162037.l9GKb2fc015252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763242AbXJPVH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix nonremovability of watchdog
has been removed from the -mm tree.  Its filename was
     uml-fix-nonremovability-of-watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix nonremovability of watchdog
From: Jeff Dike <jdike@addtoit.com>

The UML watchdog driver was using the wrong config variable to control whether
it can be unloaded once active.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/harddog_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/harddog_kern.c~uml-fix-nonremovability-of-watchdog arch/um/drivers/harddog_kern.c
--- a/arch/um/drivers/harddog_kern.c~uml-fix-nonremovability-of-watchdog
+++ a/arch/um/drivers/harddog_kern.c
@@ -69,7 +69,7 @@ static int harddog_open(struct inode *in
 	spin_lock(&lock);
 	if(timer_alive)
 		goto err;
-#ifdef CONFIG_HARDDOG_NOWAYOUT
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
 	__module_get(THIS_MODULE);
 #endif
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
