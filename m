From: akpm@linux-foundation.org
Subject: + rcu-fix-sparse-shadowed-variable-warning.patch added to -mm tree
Date: Wed, 27 Aug 2008 20:22:24 -0700
Message-ID: <200808280322.m7S3MOUg004835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYH1DXK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:23:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com


The patch titled
     rcu: fix sparse shadowed variable warning
has been added to the -mm tree.  Its filename is
     rcu-fix-sparse-shadowed-variable-warning.patch

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
Subject: rcu: fix sparse shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>

kernel/rcuclassic.c:564:18: warning: symbol 'flags' shadows an earlier one
kernel/rcuclassic.c:527:16: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcuclassic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/rcuclassic.c~rcu-fix-sparse-shadowed-variable-warning kernel/rcuclassic.c
--- a/kernel/rcuclassic.c~rcu-fix-sparse-shadowed-variable-warning
+++ a/kernel/rcuclassic.c
@@ -561,15 +561,15 @@ static void __rcu_process_callbacks(stru
 		local_irq_restore(flags);
 
 		if (rcu_batch_after(rdp->batch, rcp->pending)) {
-			unsigned long flags;
+			unsigned long flags2;
 
 			/* and start it/schedule start if it's a new batch */
-			spin_lock_irqsave(&rcp->lock, flags);
+			spin_lock_irqsave(&rcp->lock, flags2);
 			if (rcu_batch_after(rdp->batch, rcp->pending)) {
 				rcp->pending = rdp->batch;
 				rcu_start_batch(rcp);
 			}
-			spin_unlock_irqrestore(&rcp->lock, flags);
+			spin_unlock_irqrestore(&rcp->lock, flags2);
 		}
 	}
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-mt9m111c-make-function-static.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
rcu-spinlocks-take-an-unsigned-long-flags.patch
rcu-fix-sparse-shadowed-variable-warning.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-new-headers-for-make-headers-install.patch
pvrusb2-use-proper-byteorder-interface.patch

