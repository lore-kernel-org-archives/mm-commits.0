From: akpm@linux-foundation.org
Subject: - isdn-divas-fix-proc-creation.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:58 -0700
Message-ID: <200806122036.m5CKawAW005386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755967AbYFLUhE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn divas: fix proc creation
has been removed from the -mm tree.  Its filename was
     isdn-divas-fix-proc-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn divas: fix proc creation
From: Alexey Dobriyan <adobriyan@gmail.com>

1. creating proc entry and not saving pointer to PDE and checking it
   is not going to work.
2. if proc entry wasn't created, no reason to remove it on error path.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/divasmain.c |    1 -
 drivers/isdn/hardware/eicon/divasproc.c |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/isdn/hardware/eicon/divasmain.c~isdn-divas-fix-proc-creation drivers/isdn/hardware/eicon/divasmain.c
--- a/drivers/isdn/hardware/eicon/divasmain.c~isdn-divas-fix-proc-creation
+++ a/drivers/isdn/hardware/eicon/divasmain.c
@@ -808,7 +808,6 @@ static int DIVA_INIT_FUNCTION divas_init
 
 	if (!create_divas_proc()) {
 #ifdef MODULE
-		remove_divas_proc();
 		divas_unregister_chrdev();
 		divasfunc_exit();
 #endif
diff -puN drivers/isdn/hardware/eicon/divasproc.c~isdn-divas-fix-proc-creation drivers/isdn/hardware/eicon/divasproc.c
--- a/drivers/isdn/hardware/eicon/divasproc.c~isdn-divas-fix-proc-creation
+++ a/drivers/isdn/hardware/eicon/divasproc.c
@@ -125,8 +125,8 @@ static const struct file_operations diva
 
 int create_divas_proc(void)
 {
-	proc_create(divas_proc_name, S_IFREG | S_IRUGO, proc_net_eicon,
-		    &divas_fops);
+	divas_proc_entry = proc_create(divas_proc_name, S_IFREG | S_IRUGO,
+					proc_net_eicon, &divas_fops);
 	if (!divas_proc_entry)
 		return (0);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
cifs-switch-to-seq_files.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

