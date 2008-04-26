From: akpm@linux-foundation.org
Subject: - drivers-atm-use-time_before-time_before_eq-etc.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:30 -0700
Message-ID: <200804261641.m3QGfUMS031130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757271AbYDZQtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:49:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/atm: use time_before, time_before_eq, etc
has been removed from the -mm tree.  Its filename was
     drivers-atm-use-time_before-time_before_eq-etc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/atm: use time_before, time_before_eq, etc
From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/iphase.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/atm/iphase.c~drivers-atm-use-time_before-time_before_eq-etc drivers/atm/iphase.c
--- a/drivers/atm/iphase.c~drivers-atm-use-time_before-time_before_eq-etc
+++ a/drivers/atm/iphase.c
@@ -60,7 +60,8 @@
 #include <asm/uaccess.h>  
 #include <asm/string.h>  
 #include <asm/byteorder.h>  
-#include <linux/vmalloc.h>  
+#include <linux/vmalloc.h>
+#include <linux/jiffies.h>
 #include "iphase.h"		  
 #include "suni.h"		  
 #define swap(x) (((x & 0xff) << 8) | ((x & 0xff00) >> 8))  
@@ -189,7 +190,7 @@ static u16 get_desc (IADEV *dev, struct 
   int ltimeout;
 
   ia_hack_tcq (dev);
-  if(((jiffies - timer)>50)||((dev->ffL.tcq_rd==dev->host_tcq_wr))){      
+  if((time_after(jiffies,timer+50)) || ((dev->ffL.tcq_rd==dev->host_tcq_wr))) {
      timer = jiffies; 
      i=0;
      while (i < dev->num_tx_desc) {
@@ -1225,7 +1226,7 @@ static void rx_intr(struct atm_dev *dev)
         iadev->rx_tmp_jif = jiffies; 
         iadev->rxing = 0;
      } 
-     else if (((jiffies - iadev->rx_tmp_jif) > 50) && 
+     else if ((time_after(jiffies, iadev->rx_tmp_jif + 50)) &&
                ((iadev->rx_pkt_cnt - iadev->rx_tmp_cnt) == 0)) {
         for (i = 1; i <= iadev->num_rx_desc; i++)
                free_desc(dev, i);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
serial-use-time_before-time_before_eq-etc.patch
drivers-char-rtcc-use-time_before-time_before_eq-etc.patch
fbdev-use-div_round_up-or-roundup.patch
drivers-md-use-time_before-time_before_eq-etc.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

