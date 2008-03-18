From: akpm@linux-foundation.org
Subject: + drivers-net-tokenring-3c359c-use-time_-macros.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:21:21 -0700
Message-ID: <200803180421.m2I4LLjm013916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557AbYCREVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, jeff@garzik.org


The patch titled
     drivers/net/tokenring/3c359.c: use time_* macros
has been added to the -mm tree.  Its filename is
     drivers-net-tokenring-3c359c-use-time_-macros.patch

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
Subject: drivers/net/tokenring/3c359.c: use time_* macros
From: S.Caglar Onur <caglar@pardus.org.tr>

The functions time_before, time_before_eq, time_after, and time_after_eq are
more robust for comparing jiffies against other values.

So use the time_after() macro, defined in linux/jiffies.h, which deals with
wrapping correctly.

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tokenring/3c359.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN drivers/net/tokenring/3c359.c~drivers-net-tokenring-3c359c-use-time_-macros drivers/net/tokenring/3c359.c
--- a/drivers/net/tokenring/3c359.c~drivers-net-tokenring-3c359c-use-time_-macros
+++ a/drivers/net/tokenring/3c359.c
@@ -42,6 +42,7 @@
 
 #define XL_DEBUG 0
 
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -408,7 +409,7 @@ static int xl_hw_reset(struct net_device
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 40*HZ) {
+		if(time_after(jiffies, t + 40 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL  card not responding to global reset.\n", dev->name);
 			return -ENODEV;
 		}
@@ -519,7 +520,7 @@ static int xl_hw_reset(struct net_device
 	t=jiffies;
 	while ( !(readw(xl_mmio + MMIO_INTSTATUS_AUTO) & INTSTAT_SRB) ) { 
 		schedule();		
-		if(jiffies-t > 15*HZ) {
+		if(time_after(jiffies, t + 15 * HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			return -ENODEV; 
 		}
@@ -790,7 +791,7 @@ static int xl_open_hw(struct net_device 
 	t=jiffies;
 	while (! (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_SRB)) { 
 		schedule();		
-		if(jiffies-t > 40*HZ) {
+		if(time_after(jiffies, t + 40 * HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			break ; 
 		}
@@ -1003,7 +1004,7 @@ static void xl_reset(struct net_device *
 
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
-		if(jiffies-t > 40*HZ) {
+		if(time_after(jiffies, t + 40 * HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			break ; 
 		}
@@ -1270,7 +1271,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNSTALL not responding.\n", dev->name);
 			break ; 
 		}
@@ -1279,7 +1280,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNDISABLE not responding.\n", dev->name);
 			break ;
 		}
@@ -1288,7 +1289,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-UPSTALL not responding.\n", dev->name);
 			break ; 
 		}
@@ -1305,7 +1306,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (!(readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_SRB)) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-CLOSENIC not responding.\n", dev->name);
 			break ; 
 		}
@@ -1334,7 +1335,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-UPRESET not responding.\n", dev->name);
 			break ; 
 		}
@@ -1343,7 +1344,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNRESET not responding.\n", dev->name);
 			break ; 
 		}
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
arch-powerpc-platforms-iseries-pcic-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros-checkpatch-fixes.patch
drivers-net-tokenring-3c359c-use-time_-macros.patch
drivers-net-wireless-atmelc-use-time_-macros.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch
fix-indentation.patch

