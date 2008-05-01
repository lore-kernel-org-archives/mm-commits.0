From: akpm@linux-foundation.org
Subject: - epcac-static-functions-and-integer-as-null-pointer-fixes.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:44 -0700
Message-ID: <200805010929.m419Ti6C030706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419AbYEAJ3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     epca.c: static functions and integer as NULL pointer fixes
has been removed from the -mm tree.  Its filename was
     epcac-static-functions-and-integer-as-null-pointer-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epca.c: static functions and integer as NULL pointer fixes
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/char/epca.c:926:28: warning: Using plain integer as NULL pointer
drivers/char/epca.c:1841:2: warning: Using plain integer as NULL pointer

Forward declarations were already marked static, mark the definitions too.
drivers/char/epca.c:2493:6: warning: symbol 'digi_send_break' was not declared. Should it be static?
drivers/char/epca.c:2881:12: warning: symbol 'init_PCI' was not declared. Should it be static?

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/epca.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/epca.c~epcac-static-functions-and-integer-as-null-pointer-fixes drivers/char/epca.c
--- a/drivers/char/epca.c~epcac-static-functions-and-integer-as-null-pointer-fixes
+++ a/drivers/char/epca.c
@@ -923,7 +923,8 @@ static int pc_open(struct tty_struct *tt
 		return(-ENODEV);
 	}
 
-	if ((bc = ch->brdchan) == 0) {
+	bc = ch->brdchan;
+	if (bc == NULL) {
 		tty->driver_data = NULL;
 		return -ENODEV;
 	}
@@ -1838,7 +1839,7 @@ static void epcaparam(struct tty_struct 
 	unsigned mval, hflow, cflag, iflag;
 
 	bc = ch->brdchan;
-	epcaassert(bc !=0, "bc out of range");
+	epcaassert(bc != NULL, "bc out of range");
 
 	assertgwinon(ch);
 	ts = tty->termios;
@@ -2477,7 +2478,7 @@ static void pc_unthrottle(struct tty_str
 	}
 }
 
-void digi_send_break(struct channel *ch, int msec)
+static void digi_send_break(struct channel *ch, int msec)
 {
 	unsigned long flags;
 
@@ -2865,7 +2866,7 @@ static struct pci_device_id epca_pci_tbl
 
 MODULE_DEVICE_TABLE(pci, epca_pci_tbl);
 
-int __init init_PCI (void)
+static int __init init_PCI(void)
 {
 	memset (&epca_driver, 0, sizeof (epca_driver));
 	epca_driver.name = "epca";
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

