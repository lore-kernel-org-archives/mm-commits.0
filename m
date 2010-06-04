From: akpm@linux-foundation.org
Subject: + drivers-scsi-arcmsr-introduce-missing-kfree.patch added to -mm tree
Date: Fri, 04 Jun 2010 13:10:27 -0700
Message-ID: <201006042010.o54KARmK014709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554Ab0FDULE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 16:11:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@HansenPartnership.com, nick.cheng@areca.com.tw


The patch titled
     drivers/scsi/arcmsr/arcmsr_hba.c: introduce missing kfree
has been added to the -mm tree.  Its filename is
     drivers-scsi-arcmsr-introduce-missing-kfree.patch

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
Subject: drivers/scsi/arcmsr/arcmsr_hba.c: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nick Cheng <nick.cheng@areca.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/arcmsr/arcmsr_hba.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/arcmsr/arcmsr_hba.c~drivers-scsi-arcmsr-introduce-missing-kfree drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c~drivers-scsi-arcmsr-introduce-missing-kfree
+++ a/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1526,6 +1526,7 @@ static int arcmsr_iop_message_xfer(struc
 		if (!acb->fw_state) {
 			pcmdmessagefld->cmdmessage.ReturnCode =
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			kfree(ver_addr);
 			goto message_out;
 		}
 
@@ -1578,6 +1579,7 @@ static int arcmsr_iop_message_xfer(struc
 		if (!acb->fw_state) {
 			pcmdmessagefld->cmdmessage.ReturnCode =
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			kfree(ver_addr);
 			goto message_out;
 		}
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-dma-eliminate-a-null-pointer-dereference.patch
drivers-media-use-memdup_user.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
arch-ia64-kvm-add-missing-spin_unlock.patch
drivers-ide-use-memdup_user.patch
drivers-mfd-kzalloc-doesnt-return-err_ptr.patch
fs-ubifs-use-err_cast.patch
fs-ocfs2-dlm-add-missing-spin_unlock.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
arch-sparc-kernel-eliminate-what-looks-like-a-null-pointer-dereference.patch
drivers-staging-dream-camera-use-memdup_user.patch
drivers-staging-vme-bridges-add-missing-unlocks.patch
drivers-staging-eliminate-a-null-pointer-dereference.patch
drivers-usb-gadget-use-memdup_user.patch
drivers-usb-serial-eliminate-a-null-pointer-dereference.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch
drivers-mfd-introduce-missing-kfree.patch
drivers-scsi-arcmsr-introduce-missing-kfree.patch

