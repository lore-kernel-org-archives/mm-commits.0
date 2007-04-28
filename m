From: akpm@linux-foundation.org
Subject: - round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:53:39 -0700
Message-ID: <200704281053.l3SArdTj020090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965694AbXD1Kxz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:53:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, davem@davemloft.net, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ROUND_UP macro cleanup in drivers/net/ppp_generic.c
has been removed from the -mm tree.  Its filename was
     round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ROUND_UP macro cleanup in drivers/net/ppp_generic.c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

ROUND_UP macro cleanup use DIV_ROUND_UP

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ppp_generic.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/net/ppp_generic.c~round_up-macro-cleanup-in-drivers-net-ppp_genericc drivers/net/ppp_generic.c
--- a/drivers/net/ppp_generic.c~round_up-macro-cleanup-in-drivers-net-ppp_genericc
+++ a/drivers/net/ppp_generic.c
@@ -88,8 +88,6 @@ struct ppp_file {
 #define PF_TO_PPP(pf)		PF_TO_X(pf, struct ppp)
 #define PF_TO_CHANNEL(pf)	PF_TO_X(pf, struct channel)
 
-#define ROUNDUP(n, x)		(((n) + (x) - 1) / (x))
-
 /*
  * Data structure describing one ppp unit.
  * A ppp unit corresponds to a ppp network interface device
@@ -1297,7 +1295,7 @@ static int ppp_mp_explode(struct ppp *pp
 	 */
 	fragsize = len;
 	if (nfree > 1)
-		fragsize = ROUNDUP(fragsize, nfree);
+		fragsize = DIV_ROUND_UP(fragsize, nfree);
 	/* nbigger channels get fragsize bytes, the rest get fragsize-1,
 	   except if nbigger==0, then they all get fragsize. */
 	nbigger = len % nfree;
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

origin.patch
git-alsa.patch
git-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
git-ieee1394.patch
git-jfs.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
git-netdev-all.patch
nfs-use-__set_current_state.patch
git-ocfs2.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch
reiserfs-use-__set_current_state.patch
drivers-char-use-__set_current_state.patch
