From: akpm@linux-foundation.org
Subject: - edd-fix-incorrect-return-of-1-from-module_init.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:21 -0700
Message-ID: <200806081947.m58JlLFn017411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755207AbYFHTrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:47:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, Matt_Domsch@dell.com, mm-commits@vger.kernel.org


The patch titled
     edd: fix incorrect return of 1 from module_init
has been removed from the -mm tree.  Its filename was
     edd-fix-incorrect-return-of-1-from-module_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edd: fix incorrect return of 1 from module_init
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/edd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/edd.c~edd-fix-incorrect-return-of-1-from-module_init drivers/firmware/edd.c
--- a/drivers/firmware/edd.c~edd-fix-incorrect-return-of-1-from-module_init
+++ a/drivers/firmware/edd.c
@@ -753,7 +753,7 @@ edd_init(void)
 
 	if (!edd_num_devices()) {
 		printk(KERN_INFO "EDD information not available.\n");
-		return 1;
+		return -ENODEV;
 	}
 
 	edd_kset = kset_create_and_add("edd", NULL, firmware_kobj);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
cifs-switch-to-seq_files.patch
isdn-divas-fix-proc-creation.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

