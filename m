From: akpm@linux-foundation.org
Subject: + iphase-fix-64bit-warning.patch added to -mm tree
Date: Mon, 05 May 2008 13:26:20 -0700
Message-ID: <200805052026.m45KQKq6003348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754120AbYEEU07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 16:26:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, chas@cmf.nrl.navy.mil, davem@davemloft.net, jeff@garzik.org


The patch titled
     iphase: fix 64bit warning
has been added to the -mm tree.  Its filename is
     iphase-fix-64bit-warning.patch

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

linux-next.patch
sxc-fix-printk-warnings-on-sparc32.patch
git-gfs2-nmw.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-dont-disable.patch
iphase-fix-64bit-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
vt-fix-vcs-sysfs-file-creation-race.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

