From: akpm@linux-foundation.org
Subject: - drivers-pcmcia-add-missing-iounmap.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:26 -0800
Message-ID: <200802052227.m15MR7nr011752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762762AbYBEWo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, arnd@arndb.de, benh@kernel.crashing.org, galak@kernel.crashing.org, linux@dominikbrodowski.net, olof@lixom.net, paulus@samba.org, sfr@canb.auug.org.au, vitb@kernel.cras


The patch titled
     drivers/pcmcia: Add missing iounmap
has been removed from the -mm tree.  Its filename was
     drivers-pcmcia-add-missing-iounmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/pcmcia: Add missing iounmap
From: Julia Lawall <julia@diku.dk>

of_iomap calls ioremap, and so should be matched with an iounmap.  At the
two error returns, the result of calling of_iomap is only stored in a local
variable, so these error paths need to call iounmap.  Furthermore, this
function ultimately stores the result of of_iomap in an array that is local
to the file.  These values should be iounmapped at some point.  I have
added a corresponding call to iounmap at the end of the function
m8xx_remove.

The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2,x3;
int ret;
@@

  T E;
  ...
* E = of_iomap(...);
  if (E == NULL) S
  ... when != iounmap(...,(T1)E,...)
      when != if (E != NULL) { ... iounmap(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (...) {
    ... when != iounmap(...,(T2)E,...)
        when != if (E != NULL) { ... iounmap(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/m8xx_pcmcia.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/pcmcia/m8xx_pcmcia.c~drivers-pcmcia-add-missing-iounmap drivers/pcmcia/m8xx_pcmcia.c
--- a/drivers/pcmcia/m8xx_pcmcia.c~drivers-pcmcia-add-missing-iounmap
+++ a/drivers/pcmcia/m8xx_pcmcia.c
@@ -1174,8 +1174,10 @@ static int __init m8xx_probe(struct of_d
 
 	pcmcia_schlvl = irq_of_parse_and_map(np, 0);
 	hwirq = irq_map[pcmcia_schlvl].hwirq;
-	if (pcmcia_schlvl < 0)
+	if (pcmcia_schlvl < 0) {
+		iounmap(pcmcia);
 		return -EINVAL;
+	}
 
 	m8xx_pgcrx[0] = &pcmcia->pcmc_pgcra;
 	m8xx_pgcrx[1] = &pcmcia->pcmc_pgcrb;
@@ -1189,6 +1191,7 @@ static int __init m8xx_probe(struct of_d
 			driver_name, socket)) {
 		pcmcia_error("Cannot allocate IRQ %u for SCHLVL!\n",
 			     pcmcia_schlvl);
+		iounmap(pcmcia);
 		return -1;
 	}
 
@@ -1284,6 +1287,7 @@ static int m8xx_remove(struct of_device 
 	}
 	for (i = 0; i < PCMCIA_SOCKETS_NO; i++)
 		pcmcia_unregister_socket(&socket[i].socket);
+	iounmap(pcmcia);
 
 	free_irq(pcmcia_schlvl, NULL);
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch
arch-powerpc-platforms-pseries-add-missing-of_node_put.patch
arch-powerpc-sysdev-add-missing-of_node_put.patch
arch-powerpc-platforms-82xx-add-missing-of_node_put.patch
git-input.patch
git-mtd.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
drivers-video-add-missing-pci_dev_get.patch
