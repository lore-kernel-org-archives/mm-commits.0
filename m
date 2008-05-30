From: akpm@linux-foundation.org
Subject: + isdn-divas-fix-proc-creation.patch added to -mm tree
Date: Fri, 30 May 2008 16:55:33 -0700
Message-ID: <200805302355.m4UNtXDs017921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193AbYE3Xzi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 19:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, kkeil@suse.de


The patch titled
     isdn divas: fix proc creation
has been added to the -mm tree.  Its filename is
     isdn-divas-fix-proc-creation.patch

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

edd-fix-incorrect-return-of-1-from-module_init.patch
linux-next.patch
cifs-switch-to-seq_files.patch
isdn-divas-fix-proc-creation.patch
atl1-fix-4g-memory-corruption-bug.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

