From: akpm@linux-foundation.org
Subject: + edd-fix-incorrect-return-of-1-from-module_init.patch added to -mm tree
Date: Fri, 30 May 2008 16:53:45 -0700
Message-ID: <200805302353.m4UNrjeN017896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405AbYE3Xxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 19:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, Matt_Domsch@dell.com


The patch titled
     edd: fix incorrect return of 1 from module_init
has been added to the -mm tree.  Its filename is
     edd-fix-incorrect-return-of-1-from-module_init.patch

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

edd-fix-incorrect-return-of-1-from-module_init.patch
linux-next.patch
cifs-switch-to-seq_files.patch
atl1-fix-4g-memory-corruption-bug.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

