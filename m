From: akpm@linux-foundation.org
Subject: - hpwdt-dont-use-static-flags.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:32 -0700
Message-ID: <200807301914.m6UJEWCe010914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbYG3TPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, thomas.mingarelli@hp.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     hpwdt: don't use static flags
has been removed from the -mm tree.  Its filename was
     hpwdt-dont-use-static-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpwdt: don't use static flags
From: Alexey Dobriyan <adobriyan@gmail.com>

Static (read: global) is potential problem.  Two threads can corrupt each
other's interrupt status, better avoid this.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/hpwdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/hpwdt.c~hpwdt-dont-use-static-flags drivers/watchdog/hpwdt.c
--- a/drivers/watchdog/hpwdt.c~hpwdt-dont-use-static-flags
+++ a/drivers/watchdog/hpwdt.c
@@ -420,7 +420,7 @@ static int __devinit detect_cru_service(
 static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 			    void *data)
 {
-	static unsigned long rom_pl;
+	unsigned long rom_pl;
 	static int die_nmi_called;
 
 	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
git-infiniband.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
vt8623fb-fix-kernel-oops.patch
proc-fix-inode-number-bogorithmetic.patch
proc-switch-inode-number-allocation-to-ida.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
devpts-switch-to-ida.patch
devpts-switch-to-ida-checkpatch-fixes.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

