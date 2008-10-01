From: akpm@linux-foundation.org
Subject: - rcu-fix-sparse-shadowed-variable-warning.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:27:38 -0700
Message-ID: <200810012127.m91LRcmX004858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753241AbYJAV1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:27:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcu: fix sparse shadowed variable warning
has been removed from the -mm tree.  Its filename was
     rcu-fix-sparse-shadowed-variable-warning.patch

This patch was dropped because it is obsolete

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

fbcon-fix-monochrome-color-value-calculation.patch
git-avr32.patch
git-powerpc.patch
git-x86.patch
git-xtensa.patch
git-hid.patch
git-v4l-dvb.patch
git-xfs.patch
git-net.patch
git-sound.patch
git-block.patch
git-pcmcia.patch
git-battery.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
rcu-fix-sparse-shadowed-variable-warning.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
lib-pull-base-guessing-logic-to-helper-function.patch
lib-trivial-whitespace-tidy.patch
lib-remove-defining-macros-for-strict_strto.patch

