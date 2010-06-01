From: akpm@linux-foundation.org
Subject: + drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:19:05 -0700
Message-ID: <201006012119.o51LJ5sX019295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634Ab0FAVTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:19:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, alan@linux.intel.com, gregkh@suse.de


The patch titled
     drivers/char/n_gsm.c: add missing spin_unlock_irqrestore
has been added to the -mm tree.  Its filename is
     drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch

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
Subject: drivers/char/n_gsm.c: add missing spin_unlock_irqrestore
From: Julia Lawall <julia@diku.dk>

Add a spin_unlock_irqrestore missing on the error path.  Converting the
return to break leads to the spin_unlock_irqrestore at the end of the
function.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock_irqsave(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock_irqrestore(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_gsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/n_gsm.c~drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore drivers/char/n_gsm.c
--- a/drivers/char/n_gsm.c~drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore
+++ a/drivers/char/n_gsm.c
@@ -920,7 +920,7 @@ static void gsm_dlci_data_sweep(struct g
 		else
 			len = gsm_dlci_data_output_framed(gsm, dlci);
 		if (len < 0)
-			return;
+			break;
 		/* DLCI empty - try the next */
 		if (len == 0)
 			i++;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-media-use-memdup_user.patch
drivers-i2c-use-memdup_user.patch
drivers-ide-use-memdup_user.patch
fs-ubifs-use-err_cast.patch
drivers-net-wireless-prism54-use-memdup_user.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
drivers-staging-dream-camera-use-memdup_user.patch
drivers-usb-gadget-use-memdup_user.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
arch-x86-kernel-add-missing-spin_unlock.patch
arch-ia64-kvm-add-missing-spin_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch
fs-ocfs2-dlm-add-missing-spin_unlock.patch
drivers-staging-vme-bridges-add-missing-unlocks.patch

