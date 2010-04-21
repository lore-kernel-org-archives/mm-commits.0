From: akpm@linux-foundation.org
Subject: + bfa-fix-compilation-warning-and-endianness-bugs-in-powerpc.patch added to -mm tree
Date: Wed, 21 Apr 2010 16:15:22 -0700
Message-ID: <201004212315.o3LNFMR9015474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754339Ab0DUXP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 19:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: huangj@Brocade.com, James.Bottomley@HansenPartnership.comhuangj@Brocade.com, kgudipat@Brocade.com


The patch titled
     bfa: fix compilation warning and endianness bugs in powerpc
has been added to the -mm tree.  Its filename is
     bfa-fix-compilation-warning-and-endianness-bugs-in-powerpc.patch

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
Subject: bfa: fix compilation warning and endianness bugs in powerpc
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

The same change also fixes endian issues we found in powerpc test.  This
patch has been tested in x86 and powerpc platform.

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

bfa-fix-compilation-warning-and-endianness-bugs-in-powerpc.patch

