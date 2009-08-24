From: akpm@linux-foundation.org
Subject: + ia64-use-printk_once.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:25:31 -0700
Message-ID: <200908242125.n7OLPV5C030302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbZHXVZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:25:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, fenghua.yu@intel.com, tony.luck@intel.com


The patch titled
     ia64: use printk_once
has been added to the -mm tree.  Its filename is
     ia64-use-printk_once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: use printk_once
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/unaligned.c    |    6 ++----
 arch/ia64/sn/kernel/io_common.c |    8 ++------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff -puN arch/ia64/kernel/unaligned.c~ia64-use-printk_once arch/ia64/kernel/unaligned.c
--- a/arch/ia64/kernel/unaligned.c~ia64-use-printk_once
+++ a/arch/ia64/kernel/unaligned.c
@@ -60,7 +60,6 @@ dump (const char *str, void *vp, size_t 
  */
 int no_unaligned_warning;
 int unaligned_dump_stack;
-static int noprint_warning;
 
 /*
  * For M-unit:
@@ -1357,9 +1356,8 @@ ia64_handle_unaligned (unsigned long ifa
 			/* watch for command names containing %s */
 			printk(KERN_WARNING "%s", buf);
 		} else {
-			if (no_unaligned_warning && !noprint_warning) {
-				noprint_warning = 1;
-				printk(KERN_WARNING "%s(%d) encountered an "
+			if (no_unaligned_warning) {
+				printk_once(KERN_WARNING "%s(%d) encountered an "
 				       "unaligned exception which required\n"
 				       "kernel assistance, which degrades "
 				       "the performance of the application.\n"
diff -puN arch/ia64/sn/kernel/io_common.c~ia64-use-printk_once arch/ia64/sn/kernel/io_common.c
--- a/arch/ia64/sn/kernel/io_common.c~ia64-use-printk_once
+++ a/arch/ia64/sn/kernel/io_common.c
@@ -119,7 +119,6 @@ sn_pcidev_info_get(struct pci_dev *dev)
  * Additionally note that the struct sn_flush_device_war also has to be
  * removed from arch/ia64/sn/include/xtalk/hubdev.h
  */
-static u8 war_implemented = 0;
 
 static s64 sn_device_fixup_war(u64 nasid, u64 widget, int device,
 			       struct sn_flush_device_common *common)
@@ -128,11 +127,8 @@ static s64 sn_device_fixup_war(u64 nasid
 	struct sn_flush_device_war *dev_entry;
 	struct ia64_sal_retval isrv = {0,0,0,0};
 
-	if (!war_implemented) {
-		printk(KERN_WARNING "PROM version < 4.50 -- implementing old "
-		       "PROM flush WAR\n");
-		war_implemented = 1;
-	}
+	printk_once(KERN_WARNING
+		"PROM version < 4.50 -- implementing old PROM flush WAR\n");
 
 	war_list = kzalloc(DEV_PER_WIDGET * sizeof(*war_list), GFP_KERNEL);
 	BUG_ON(!war_list);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

linux-next.patch
alpha-use-printk_once.patch
ia64-use-printk_once.patch
ata-use-printk_once.patch
ide-use-printk_once.patch
vsprintf-use-warn_on_once.patch

