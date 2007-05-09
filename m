From: akpm@linux-foundation.org
Subject: - round_up-macro-cleanup-in-drivers-char-lpc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:02 -0700
Message-ID: <200705090249.l492n2Is009178@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966107AbXEICtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ROUND_UP macro cleanup in drivers/char/lp.c
has been removed from the -mm tree.  Its filename was
     round_up-macro-cleanup-in-drivers-char-lpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ROUND_UP macro cleanup in drivers/char/lp.c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

ROUND_UP macro cleanup use DIV_ROUND_UP

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/lp.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/char/lp.c~round_up-macro-cleanup-in-drivers-char-lpc drivers/char/lp.c
--- a/drivers/char/lp.c~round_up-macro-cleanup-in-drivers-char-lpc
+++ a/drivers/char/lp.c
@@ -138,9 +138,6 @@
 /* if you have more than 8 printers, remember to increase LP_NO */
 #define LP_NO 8
 
-/* ROUND_UP macro from fs/select.c */
-#define ROUND_UP(x,y) (((x)+(y)-1)/(y))
-
 static struct lp_struct lp_table[LP_NO];
 
 static unsigned int lp_count = 0;
@@ -651,7 +648,7 @@ static int lp_ioctl(struct inode *inode,
 			    (par_timeout.tv_usec < 0)) {
 				return -EINVAL;
 			}
-			to_jiffies = ROUND_UP(par_timeout.tv_usec, 1000000/HZ);
+			to_jiffies = DIV_ROUND_UP(par_timeout.tv_usec, 1000000/HZ);
 			to_jiffies += par_timeout.tv_sec * (long) HZ;
 			if (to_jiffies <= 0) {
 				return -EINVAL;
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

origin.patch
git-alsa.patch
git-ia64.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
nfs-use-__set_current_state.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
