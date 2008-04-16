From: akpm@linux-foundation.org
Subject: + drivers-atm-use-time_before-time_before_eq-etc.patch added to -mm tree
Date: Tue, 15 Apr 2008 21:35:53 -0700
Message-ID: <200804160435.m3G4Zrx8032273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbYDPEg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 00:36:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/atm: use time_before, time_before_eq, etc
has been added to the -mm tree.  Its filename is
     drivers-atm-use-time_before-time_before_eq-etc.patch

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

git-alsa-tiwai.patch
git-powerpc.patch
git-gfs2-nmw.patch
git-infiniband.patch
git-udf.patch
git-net.patch
drivers-atm-use-time_before-time_before_eq-etc.patch
git-ocfs2.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

