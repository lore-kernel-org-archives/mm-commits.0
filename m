From: akpm@linux-foundation.org
Subject: + drivers-pcmcia-add-missing-iounmap.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:07:00 -0800
Message-ID: <200801120107.m0C1707D007017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762559AbYALBHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:07:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, arnd@arndb.de, benh@kernel.crashing.org, galak@kernel.crashing.org, linux@dominikbrodowski.net, olof@lixom.net, paulus@samba.org, sfr@canb.auug.org.au, vitb@kernel.crashing.org


The patch titled
     drivers/pcmcia: Add missing iounmap
has been added to the -mm tree.  Its filename is
     drivers-pcmcia-add-missing-iounmap.patch

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

git-alsa.patch
git-agpgart.patch
git-powerpc.patch
drivers-media-radio-use-video_device_release-rather-than-kfree.patch
drivers-media-common-add-missing-video_device_release.patch
git-input.patch
drivers-pcmcia-add-missing-iounmap.patch
git-x86.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
