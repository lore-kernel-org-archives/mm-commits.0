From: akpm@linux-foundation.org
Subject: + s390-use-div_round_up.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:03:42 -0800
Message-ID: <200802181004.m1IA4ebk019171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756724AbYBRKFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:05:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     s390: use DIV_ROUND_UP
has been added to the -mm tree.  Its filename is
     s390-use-div_round_up.patch

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
Subject: s390: use DIV_ROUND_UP
From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/net/claw.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/s390/net/claw.c~s390-use-div_round_up drivers/s390/net/claw.c
--- a/drivers/s390/net/claw.c~s390-use-div_round_up
+++ a/drivers/s390/net/claw.c
@@ -2114,8 +2114,7 @@ init_ccw_bk(struct net_device *dev)
         */
         ccw_blocks_perpage= PAGE_SIZE /  CCWBK_SIZE;
         ccw_pages_required=
-		(ccw_blocks_required+ccw_blocks_perpage -1) /
-			 ccw_blocks_perpage;
+		DIV_ROUND_UP(ccw_blocks_required, ccw_blocks_perpage);
 
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: %s() > ccw_blocks_perpage=%d\n",
@@ -2133,12 +2132,12 @@ init_ccw_bk(struct net_device *dev)
          */
         if (privptr->p_env->read_size < PAGE_SIZE) {
             claw_reads_perpage= PAGE_SIZE / privptr->p_env->read_size;
-            claw_read_pages= (privptr->p_env->read_buffers +
-	    	claw_reads_perpage -1) / claw_reads_perpage;
+	     claw_read_pages=
+		DIV_ROUND_UP(privptr->p_env->read_buffers, claw_reads_perpage);
          }
          else {       /* > or equal  */
             privptr->p_buff_pages_perread=
-	    	(privptr->p_env->read_size + PAGE_SIZE - 1) / PAGE_SIZE;
+		DIV_ROUND_UP(privptr->p_env->read_size, PAGE_SIZE);
             claw_read_pages=
 	    	privptr->p_env->read_buffers * privptr->p_buff_pages_perread;
          }
@@ -2146,13 +2145,13 @@ init_ccw_bk(struct net_device *dev)
             claw_writes_perpage=
 	    	PAGE_SIZE / privptr->p_env->write_size;
             claw_write_pages=
-	    	(privptr->p_env->write_buffers + claw_writes_perpage -1) /
-			claw_writes_perpage;
+		DIV_ROUND_UP(privptr->p_env->write_buffers,
+			     claw_writes_perpage);
 
         }
         else {      /* >  or equal  */
             privptr->p_buff_pages_perwrite=
-	    	 (privptr->p_env->read_size + PAGE_SIZE - 1) / PAGE_SIZE;
+		DIV_ROUND_UP(privptr->p_env->read_size, PAGE_SIZE);
             claw_write_pages=
 	     	privptr->p_env->write_buffers * privptr->p_buff_pages_perwrite;
         }
_

Patches currently in -mm which might be from julia@diku.dk are

git-hid.patch
git-net.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
s390-use-div_round_up.patch
drivers-block-viodasdc-use-field_sizeof.patch
usb-use-div_round_up.patch
fbdev-use-div_round_up-or-roundup.patch
