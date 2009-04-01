From: akpm@linux-foundation.org
Subject: [merged] alpha-fix-macros.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:04 -0700
Message-ID: <200904011839.n31Id4kW008488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934085AbZDATXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fix macros
has been removed from the -mm tree.  Its filename was
     alpha-fix-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: fix macros
From: Roel Kluin <roel.kluin@gmail.com>

When this macros isn't called with 'fixup', e.g.  with foo this will
incorectly expand to foo->foo.bits.errreg

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/uaccess.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/alpha/include/asm/uaccess.h~alpha-fix-macros arch/alpha/include/asm/uaccess.h
--- a/arch/alpha/include/asm/uaccess.h~alpha-fix-macros
+++ a/arch/alpha/include/asm/uaccess.h
@@ -498,13 +498,13 @@ struct exception_table_entry
 };
 
 /* Returns the new pc */
-#define fixup_exception(map_reg, fixup, pc)			\
+#define fixup_exception(map_reg, _fixup, pc)			\
 ({								\
-	if ((fixup)->fixup.bits.valreg != 31)			\
-		map_reg((fixup)->fixup.bits.valreg) = 0;	\
-	if ((fixup)->fixup.bits.errreg != 31)			\
-		map_reg((fixup)->fixup.bits.errreg) = -EFAULT;	\
-	(pc) + (fixup)->fixup.bits.nextinsn;			\
+	if ((_fixup)->fixup.bits.valreg != 31)			\
+		map_reg((_fixup)->fixup.bits.valreg) = 0;	\
+	if ((_fixup)->fixup.bits.errreg != 31)			\
+		map_reg((_fixup)->fixup.bits.errreg) = -EFAULT;	\
+	(pc) + (_fixup)->fixup.bits.nextinsn;			\
 })
 
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch

