From: akpm@linux-foundation.org
Subject: - kgdb-use-put_unaligned_be32-helper.patch removed from -mm tree
Date: Thu, 05 Jun 2008 11:21:21 -0700
Message-ID: <200806051821.m55ILLkN023222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876AbYFESVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:21:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jason.wessel@windriver.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kgdb: use put_unaligned_be32 helper
has been removed from the -mm tree.  Its filename was
     kgdb-use-put_unaligned_be32-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kgdb: use put_unaligned_be32 helper
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kgdb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/kgdb.c~kgdb-use-put_unaligned_be32-helper kernel/kgdb.c
--- a/kernel/kgdb.c~kgdb-use-put_unaligned_be32-helper
+++ a/kernel/kgdb.c
@@ -52,6 +52,7 @@
 #include <asm/byteorder.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
+#include <asm/unaligned.h>
 
 static int kgdb_break_asap;
 
@@ -510,10 +511,7 @@ static void int_to_threadref(unsigned ch
 	scan = (unsigned char *)id;
 	while (i--)
 		*scan++ = 0;
-	*scan++ = (value >> 24) & 0xff;
-	*scan++ = (value >> 16) & 0xff;
-	*scan++ = (value >> 8) & 0xff;
-	*scan++ = (value & 0xff);
+	put_unaligned_be32(value, scan);
 }
 
 static struct task_struct *getthread(struct pt_regs *regs, int tid)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

lib-export-bitrev16.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
bluetooth-hci_bcspc-small-cleanups-api-users.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
usb-cp2101c-fix-sparse-signedness-mismatch-warnings.patch
usb-speedtchc-fix-sparse-shadowed-variable-warning.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

