From: akpm@linux-foundation.org
Subject: + avm-fix-sparse-warning-using-integer-as-null-pointer.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:38 -0800
Message-ID: <200802230735.m1N7ZR2p018360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbYBWIBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:01:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, jeff@garzik.org, kkeil@suse.de


The patch titled
     avm: fix sparse warning using integer as NULL pointer
has been added to the -mm tree.  Its filename is
     avm-fix-sparse-warning-using-integer-as-null-pointer.patch

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
Subject: avm: fix sparse warning using integer as NULL pointer
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/isdn/hardware/avm/b1isa.c:206:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1isa.c:208:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1.c:664:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1.c:666:44: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1.c:668:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1.c:791:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1.c:793:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1pci.c:385:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1pci.c:387:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1dma.c:886:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1dma.c:888:44: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1dma.c:890:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1dma.c:973:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1dma.c:975:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1pcmcia.c:204:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1pcmcia.c:206:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/t1isa.c:554:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/t1isa.c:556:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/t1pci.c:236:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/t1pci.c:238:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1091:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1093:44: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1095:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1170:21: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1294:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1296:33: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/avm/b1.c       |   10 +++++-----
 drivers/isdn/hardware/avm/b1dma.c    |   10 +++++-----
 drivers/isdn/hardware/avm/b1isa.c    |    4 ++--
 drivers/isdn/hardware/avm/b1pci.c    |    4 ++--
 drivers/isdn/hardware/avm/b1pcmcia.c |    4 ++--
 drivers/isdn/hardware/avm/c4.c       |   12 ++++++------
 drivers/isdn/hardware/avm/t1isa.c    |    4 ++--
 drivers/isdn/hardware/avm/t1pci.c    |    4 ++--
 8 files changed, 26 insertions(+), 26 deletions(-)

diff -puN drivers/isdn/hardware/avm/b1.c~avm-fix-sparse-warning-using-integer-as-null-pointer drivers/isdn/hardware/avm/b1.c
--- a/drivers/isdn/hardware/avm/b1.c~avm-fix-sparse-warning-using-integer-as-null-pointer
+++ a/drivers/isdn/hardware/avm/b1.c
@@ -661,11 +661,11 @@ int b1ctl_read_proc(char *page, char **s
 	len += sprintf(page+len, "%-16s %s\n", "type", s);
 	if (card->cardtype == avm_t1isa)
 	   len += sprintf(page+len, "%-16s %d\n", "cardnr", card->cardnr);
-	if ((s = cinfo->version[VER_DRIVER]) != 0)
+	if ((s = cinfo->version[VER_DRIVER]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_driver", s);
-	if ((s = cinfo->version[VER_CARDTYPE]) != 0)
+	if ((s = cinfo->version[VER_CARDTYPE]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_cardtype", s);
-	if ((s = cinfo->version[VER_SERIAL]) != 0)
+	if ((s = cinfo->version[VER_SERIAL]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_serial", s);
 
 	if (card->cardtype != avm_m1) {
@@ -788,9 +788,9 @@ static int __init b1_init(void)
 	char *p;
 	char rev[32];
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff -puN drivers/isdn/hardware/avm/b1dma.c~avm-fix-sparse-warning-using-integer-as-null-pointer drivers/isdn/hardware/avm/b1dma.c
--- a/drivers/isdn/hardware/avm/b1dma.c~avm-fix-sparse-warning-using-integer-as-null-pointer
+++ a/drivers/isdn/hardware/avm/b1dma.c
@@ -883,11 +883,11 @@ int b1dmactl_read_proc(char *page, char 
 	default: s = "???"; break;
 	}
 	len += sprintf(page+len, "%-16s %s\n", "type", s);
-	if ((s = cinfo->version[VER_DRIVER]) != 0)
+	if ((s = cinfo->version[VER_DRIVER]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_driver", s);
-	if ((s = cinfo->version[VER_CARDTYPE]) != 0)
+	if ((s = cinfo->version[VER_CARDTYPE]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_cardtype", s);
-	if ((s = cinfo->version[VER_SERIAL]) != 0)
+	if ((s = cinfo->version[VER_SERIAL]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_serial", s);
 
 	if (card->cardtype != avm_m1) {
@@ -970,9 +970,9 @@ static int __init b1dma_init(void)
 	char *p;
 	char rev[32];
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, sizeof(rev));
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff -puN drivers/isdn/hardware/avm/b1isa.c~avm-fix-sparse-warning-using-integer-as-null-pointer drivers/isdn/hardware/avm/b1isa.c
--- a/drivers/isdn/hardware/avm/b1isa.c~avm-fix-sparse-warning-using-integer-as-null-pointer
+++ a/drivers/isdn/hardware/avm/b1isa.c
@@ -203,9 +203,9 @@ static int __init b1isa_init(void)
 	char rev[32];
 	int i;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff -puN drivers/isdn/hardware/avm/b1pci.c~avm-fix-sparse-warning-using-integer-as-null-pointer drivers/isdn/hardware/avm/b1pci.c
--- a/drivers/isdn/hardware/avm/b1pci.c~avm-fix-sparse-warning-using-integer-as-null-pointer
+++ a/drivers/isdn/hardware/avm/b1pci.c
@@ -382,9 +382,9 @@ static int __init b1pci_init(void)
 	char rev[32];
 	int err;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff -puN drivers/isdn/hardware/avm/b1pcmcia.c~avm-fix-sparse-warning-using-integer-as-null-pointer drivers/isdn/hardware/avm/b1pcmcia.c
--- a/drivers/isdn/hardware/avm/b1pcmcia.c~avm-fix-sparse-warning-using-integer-as-null-pointer
+++ a/drivers/isdn/hardware/avm/b1pcmcia.c
@@ -201,9 +201,9 @@ static int __init b1pcmcia_init(void)
 	char *p;
 	char rev[32];
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff -puN drivers/isdn/hardware/avm/c4.c~avm-fix-sparse-warning-using-integer-as-null-pointer drivers/isdn/hardware/avm/c4.c
--- a/drivers/isdn/hardware/avm/c4.c~avm-fix-sparse-warning-using-integer-as-null-pointer
+++ a/drivers/isdn/hardware/avm/c4.c
@@ -1088,11 +1088,11 @@ static int c4_read_proc(char *page, char
 	default: s = "???"; break;
 	}
 	len += sprintf(page+len, "%-16s %s\n", "type", s);
-	if ((s = cinfo->version[VER_DRIVER]) != 0)
+	if ((s = cinfo->version[VER_DRIVER]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_driver", s);
-	if ((s = cinfo->version[VER_CARDTYPE]) != 0)
+	if ((s = cinfo->version[VER_CARDTYPE]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_cardtype", s);
-	if ((s = cinfo->version[VER_SERIAL]) != 0)
+	if ((s = cinfo->version[VER_SERIAL]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_serial", s);
 
 	if (card->cardtype != avm_m1) {
@@ -1167,7 +1167,7 @@ static int c4_add_card(struct capicardpa
 	}
 
 	card->mbase = ioremap(card->membase, 128);
-	if (card->mbase == 0) {
+	if (card->mbase == NULL) {
 		printk(KERN_NOTICE "c4: can't remap memory at 0x%lx\n",
 		       card->membase);
 		retval = -EIO;
@@ -1291,9 +1291,9 @@ static int __init c4_init(void)
 	char rev[32];
 	int err;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff -puN drivers/isdn/hardware/avm/t1isa.c~avm-fix-sparse-warning-using-integer-as-null-pointer drivers/isdn/hardware/avm/t1isa.c
--- a/drivers/isdn/hardware/avm/t1isa.c~avm-fix-sparse-warning-using-integer-as-null-pointer
+++ a/drivers/isdn/hardware/avm/t1isa.c
@@ -551,9 +551,9 @@ static int __init t1isa_init(void)
 	char *p;
 	int i;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff -puN drivers/isdn/hardware/avm/t1pci.c~avm-fix-sparse-warning-using-integer-as-null-pointer drivers/isdn/hardware/avm/t1pci.c
--- a/drivers/isdn/hardware/avm/t1pci.c~avm-fix-sparse-warning-using-integer-as-null-pointer
+++ a/drivers/isdn/hardware/avm/t1pci.c
@@ -233,9 +233,9 @@ static int __init t1pci_init(void)
 	char rev[32];
 	int err;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
markers-fix-sparse-warnings-in-markersc.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
