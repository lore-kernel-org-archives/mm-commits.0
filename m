From: akpm@linux-foundation.org
Subject: [merged] bfa-fix-compilation-warning-and-endianness-bugs-in-powerpc.patch removed from -mm tree
Date: Mon, 03 May 2010 13:09:51 -0400
Message-ID: <201005032011.o43KBMLj019197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756716Ab0ECUL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 May 2010 16:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: huangj@Brocade.com, James.Bottomley@HansenPartnership.comhuangj@Brocade.com, kgudipat@Brocade.com, mm-commits@vger.kernel.org


The patch titled
     bfa: fix compilation warning and endianness issues in powerpc
has been removed from the -mm tree.  Its filename was
     bfa-fix-compilation-warning-and-endianness-bugs-in-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bfa: fix compilation warning and endianness issues in powerpc
From: Jing Huang <huangj@Brocade.com>

Fix the compilation warning in powerpc:

drivers/scsi/bfa/bfa_ioc.c: In function 'bfa_ioc_msgget':
drivers/scsi/bfa/bfa_ioc.c:1331: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_notify_hbfail':
drivers/scsi/bfa/bfa_ioc_ct.c:177: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c:180: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_pll_init':
drivers/scsi/bfa/bfa_ioc_ct.c:381: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_ownership_reset':
drivers/scsi/bfa/bfa_ioc_ct.c:421: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_cb.c: In function 'bfa_ioc_cb_notify_hbfail':
drivers/scsi/bfa/bfa_ioc_cb.c:99: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_cb.c: In function 'bfa_ioc_cb_ownership_reset':
drivers/scsi/bfa/bfa_ioc_cb.c:272: warning: value computed is not used

The same change also fixes endian issues we found in powerpc test.  I
remove an unnecessary word swap in bfa_os_reg_read() and
bfa_os_reg_write() because the kernel provided readl and writel are
already doing so.  The compilation warning also goes away after this
change.  For bfa_os_mem_read() and bfa_os_mem_write() macros, I add a swap
since these two macros are designed to read/write from/to a memory region
that is in BE format per ASIC spec.

This patch has been tested in x86 and powerpc platform.

Signed-off-by: Jing Huang <huangj@brocade.com>
Cc: Jing Huang <huangj@brocade.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Krishna Gudipati <kgudipat@brocade.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfa_os_inc.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/bfa/bfa_os_inc.h~bfa-fix-compilation-warning-and-endianness-bugs-in-powerpc drivers/scsi/bfa/bfa_os_inc.h
--- a/drivers/scsi/bfa/bfa_os_inc.h~bfa-fix-compilation-warning-and-endianness-bugs-in-powerpc
+++ a/drivers/scsi/bfa/bfa_os_inc.h
@@ -176,12 +176,12 @@ int bfa_os_MWB(void *);
 #define bfa_os_addr_t char __iomem *
 #define bfa_os_panic()
 
-#define bfa_os_reg_read(_raddr) bfa_os_wtole(readl(_raddr))
-#define bfa_os_reg_write(_raddr, _val) writel(bfa_os_wtole((_val)), (_raddr))
+#define bfa_os_reg_read(_raddr) readl(_raddr)
+#define bfa_os_reg_write(_raddr, _val) writel((_val), (_raddr))
 #define bfa_os_mem_read(_raddr, _off)                                   \
-	bfa_os_ntohl(readl(((_raddr) + (_off))))
+	bfa_os_swap32(readl(((_raddr) + (_off))))
 #define bfa_os_mem_write(_raddr, _off, _val)                            \
-	writel(bfa_os_htonl((_val)), ((_raddr) + (_off)))
+	writel(bfa_os_swap32((_val)), ((_raddr) + (_off)))
 
 #define BFA_TRC_TS(_trcm)						\
 			({						\
_

Patches currently in -mm which might be from huangj@Brocade.com are

linux-next.patch

