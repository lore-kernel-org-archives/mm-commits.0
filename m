From: akpm@linux-foundation.org
Subject: + lkdtm-fix-for-config_scsi=n.patch added to -mm tree
Date: Tue, 01 Jul 2008 01:36:20 -0700
Message-ID: <200807010836.m618aKUS017766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbYGAIil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ankita@in.ibm.com


The patch titled
     lkdtm: fix for CONFIG_SCSI=n
has been added to the -mm tree.  Its filename is
     lkdtm-fix-for-config_scsi=n.patch

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
Subject: lkdtm: fix for CONFIG_SCSI=n
From: Randy Dunlap <randy.dunlap@oracle.com>


Fix lkdtm test code for case of CONFIG_SCSI=n, to avoid build errors:

In file included from linux-next-20080618/tests/lkdtm.c:55:
linux-next-20080618/include/scsi/scsi_cmnd.h:28:25: warning: "BLK_MAX_CDB" is not defined
linux-next-20080618/include/scsi/scsi_cmnd.h:29:3: error: #error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
In file included from linux-next-20080618/tests/lkdtm.c:55:
linux-next-20080618/include/scsi/scsi_cmnd.h: In function 'scsi_bidi_cmnd':
linux-next-20080618/include/scsi/scsi_cmnd.h:183: error: implicit declaration of function 'blk_bidi_rq'
linux-next-20080618/include/scsi/scsi_cmnd.h:184: error: dereferencing pointer to incomplete type
linux-next-20080618/include/scsi/scsi_cmnd.h: In function 'scsi_in':
linux-next-20080618/include/scsi/scsi_cmnd.h:190: error: dereferencing pointer to incomplete type
make[2]: *** [tests/lkdtm.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <ankita@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tests/lkdtm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN tests/lkdtm.c~lkdtm-fix-for-config_scsi=n tests/lkdtm.c
--- a/tests/lkdtm.c~lkdtm-fix-for-config_scsi=n
+++ a/tests/lkdtm.c
@@ -52,7 +52,9 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/hrtimer.h>
+#ifdef CONFIG_SCSI
 #include <scsi/scsi_cmnd.h>
+#endif
 
 #ifdef CONFIG_IDE
 #include <linux/ide.h>
@@ -175,12 +177,14 @@ static int jp_hrtimer_start(struct hrtim
 	return 0;
 }
 
+#ifdef CONFIG_SCSI
 static int jp_scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_IDE
 int jp_generic_ide_ioctl(ide_drive_t *drive, struct file *file,
@@ -307,8 +311,12 @@ static int __init lkdtm_module_init(void
 		lkdtm.entry = (kprobe_opcode_t*) jp_hrtimer_start;
 		break;
 	case SCSI_DISPATCH_CMD:
+#ifdef CONFIG_SCSI
 		lkdtm.kp.symbol_name = "scsi_dispatch_cmd";
 		lkdtm.entry = (kprobe_opcode_t*) jp_scsi_dispatch_cmd;
+#else
+		printk(KERN_INFO "lkdtm : Crash point not available\n");
+#endif
 		break;
 	case IDE_CORE_CP:
 #ifdef CONFIG_IDE
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

doc-kernel-parameterstxt-fix-stale-references.patch
fujitsu-laptop-depends-on-input.patch
x86-mm-init_64-fix-printk-format-warning.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
bluetooth-hci_bcsp-fix-bitrev-kconfig.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
e100-fix-printk-format-warning.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
iwlwifi-fix-build-for-config_input=n.patch
audit-fix-kernel-doc-parameter-notation.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
kallsyms-unify-32-and-64-bit-code.patch
uio-howtotmpl-use-standard-copyright-legal-markings.patch
uio-howtotmpl-use-unique-output-names.patch
procfs-guide-drop-pointless-nbsp-entities.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch

