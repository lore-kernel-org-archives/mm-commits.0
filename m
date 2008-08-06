From: akpm@linux-foundation.org
Subject: + drivers-scsi-a2091c-make-2-functions-static.patch added to -mm tree
Date: Wed, 06 Aug 2008 15:52:44 -0700
Message-ID: <200808062252.m76MqiwH019784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715AbYHFWwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 18:52:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, James.Bottomley@HansenPartnership.com


The patch titled
     drivers/scsi/a2091.c: make 2 functions static
has been added to the -mm tree.  Its filename is
     drivers-scsi-a2091c-make-2-functions-static.patch

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
Subject: drivers/scsi/a2091.c: make 2 functions static
From: Adrian Bunk <bunk@kernel.org>

a2091_{detect,release}() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/a2091.c |    6 ++++--
 drivers/scsi/a2091.h |    3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/a2091.c~drivers-scsi-a2091c-make-2-functions-static drivers/scsi/a2091.c
--- a/drivers/scsi/a2091.c~drivers-scsi-a2091c-make-2-functions-static
+++ a/drivers/scsi/a2091.c
@@ -23,6 +23,8 @@
 #define DMA(ptr) ((a2091_scsiregs *)((ptr)->base))
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
+static int a2091_release(struct Scsi_Host *instance);
+
 static irqreturn_t a2091_intr (int irq, void *_instance)
 {
     unsigned long flags;
@@ -144,7 +146,7 @@ static void dma_stop(struct Scsi_Host *i
     }
 }
 
-int __init a2091_detect(struct scsi_host_template *tpnt)
+static int __init a2091_detect(struct scsi_host_template *tpnt)
 {
     static unsigned char called = 0;
     struct Scsi_Host *instance;
@@ -227,7 +229,7 @@ static struct scsi_host_template driver_
 
 #include "scsi_module.c"
 
-int a2091_release(struct Scsi_Host *instance)
+static int a2091_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
 	DMA(instance)->CNTR = 0;
diff -puN drivers/scsi/a2091.h~drivers-scsi-a2091c-make-2-functions-static drivers/scsi/a2091.h
--- a/drivers/scsi/a2091.h~drivers-scsi-a2091c-make-2-functions-static
+++ a/drivers/scsi/a2091.h
@@ -11,9 +11,6 @@
 
 #include <linux/types.h>
 
-int a2091_detect(struct scsi_host_template *);
-int a2091_release(struct Scsi_Host *);
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
_

Patches currently in -mm which might be from bunk@kernel.org are

feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
git-block.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
reiser4.patch
fs-partitions-acornc-remove-dead-code.patch
the-overdue-eepro100-removal.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
parport-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
maintainers-remove-zf-machz-watchdog-entry.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
ntfs-update-homepage.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
binfmt_somc-add-module_license.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
the-scheduled-serial_coldfire-removal.patch

