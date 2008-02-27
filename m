From: akpm@linux-foundation.org
Subject: + epcac-static-functions-and-integer-as-null-pointer-fixes.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:35:45 -0800
Message-ID: <200802272335.m1RNZj0Q004337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756519AbYB0Xgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:36:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     epca.c: static functions and integer as NULL pointer fixes
has been added to the -mm tree.  Its filename is
     epcac-static-functions-and-integer-as-null-pointer-fixes.patch

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
Subject: epca.c: static functions and integer as NULL pointer fixes
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/char/epca.c:926:28: warning: Using plain integer as NULL pointer
drivers/char/epca.c:1841:2: warning: Using plain integer as NULL pointer

Forward declarations were already marked static, mark the definitions too.
drivers/char/epca.c:2493:6: warning: symbol 'digi_send_break' was not declared. Should it be static?
drivers/char/epca.c:2881:12: warning: symbol 'init_PCI' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/epca.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/epca.c~epcac-static-functions-and-integer-as-null-pointer-fixes drivers/char/epca.c
--- a/drivers/char/epca.c~epcac-static-functions-and-integer-as-null-pointer-fixes
+++ a/drivers/char/epca.c
@@ -923,7 +923,7 @@ static int pc_open(struct tty_struct *tt
 		return(-ENODEV);
 	}
 
-	if ((bc = ch->brdchan) == 0) {
+	if ((bc = ch->brdchan) == NULL) {
 		tty->driver_data = NULL;
 		return -ENODEV;
 	}
@@ -1838,7 +1838,7 @@ static void epcaparam(struct tty_struct 
 	unsigned mval, hflow, cflag, iflag;
 
 	bc = ch->brdchan;
-	epcaassert(bc !=0, "bc out of range");
+	epcaassert(bc != NULL, "bc out of range");
 
 	assertgwinon(ch);
 	ts = tty->termios;
@@ -2477,7 +2477,7 @@ static void pc_unthrottle(struct tty_str
 	}
 }
 
-void digi_send_break(struct channel *ch, int msec)
+static void digi_send_break(struct channel *ch, int msec)
 {
 	unsigned long flags;
 
@@ -2865,7 +2865,7 @@ static struct pci_device_id epca_pci_tbl
 
 MODULE_DEVICE_TABLE(pci, epca_pci_tbl);
 
-int __init init_PCI (void)
+static int __init init_PCI (void)
 {
 	memset (&epca_driver, 0, sizeof (epca_driver));
 	epca_driver.name = "epca";
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
git-dvb.patch
git-dlm.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-net.patch
git-nfsd.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
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
fbcon-replace-mono_col-macro-with-static-inline.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
