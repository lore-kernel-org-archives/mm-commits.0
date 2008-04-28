From: akpm@linux-foundation.org
Subject: - avm-fix-sparse-warning-using-integer-as-null-pointer.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:42 -0700
Message-ID: <200804282156.m3SLugex018256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936243AbYD1V4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jeff@garzik.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     avm: fix sparse warning using integer as NULL pointer
has been removed from the -mm tree.  Its filename was
     avm-fix-sparse-warning-using-integer-as-null-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

