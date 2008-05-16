From: akpm@linux-foundation.org
Subject: - iphase-fix-64bit-warning.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:54 -0700
Message-ID: <200805162253.m4GMrspj003182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718AbYEPWya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, chas@cmf.nrl.navy.mil, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     iphase: fix 64bit warning
has been removed from the -mm tree.  Its filename was
     iphase-fix-64bit-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iphase: fix 64bit warning
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Time is unsigned long (except when you are in a hurry) so we need to store
rx_tmp_jif in the right sized object.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: chas williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/iphase.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/atm/iphase.h~iphase-fix-64bit-warning drivers/atm/iphase.h
--- a/drivers/atm/iphase.h~iphase-fix-64bit-warning
+++ a/drivers/atm/iphase.h
@@ -1025,7 +1025,8 @@ typedef struct iadev_t {  
         spinlock_t rx_lock, misc_lock;
 	struct atm_vcc **rx_open;	/* list of all open VCs */  
         u16 num_rx_desc, rx_buf_sz, rxing;
-        u32 rx_pkt_ram, rx_tmp_cnt, rx_tmp_jif;
+        u32 rx_pkt_ram, rx_tmp_cnt;
+        unsigned long rx_tmp_jif;
         void __iomem *RX_DESC_BASE_ADDR;
         u32 drop_rxpkt, drop_rxcell, rx_cell_cnt, rx_pkt_cnt;
 	struct atm_dev *next_board;	/* other iphase devices */  
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

