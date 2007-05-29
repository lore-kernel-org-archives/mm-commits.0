From: akpm@linux-foundation.org
Subject: + atm-fix-warning.patch added to -mm tree
Date: Tue, 29 May 2007 15:53:52 -0700
Message-ID: <200705292253.l4TMrqag013706@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbXE2WyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, chas@cmf.nrl.navy.mil, davem@davemloft.net


The patch titled
     ATM: fix warning
has been added to the -mm tree.  Its filename is
     atm-fix-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: ATM: fix warning
=46rom: Jeff Garzik <jeff@garzik.org>

The compiler warning

drivers/atm/firestream.c: In function =E2=80=98top_off_fp=E2=80=99:
drivers/atm/firestream.c:1505: warning: cast to pointer from integer of=
 different size

does indicate a bug, albeit a minor one.  Fixed, by using a 32-bit
temporary prior to the call to bus_to_virt().

The larger bug is still present: the entire driver assumes that machine
pointers are 32-bit, as it stores pointers in 32-bit hardware registers=
=2E=20
This is obvious to anyone who knows the driver well, but for the casual
readers it is helpfully noted with FIXME.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: chas williams <chas@cmf.nrl.navy.mil>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/firestream.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/atm/firestream.c~atm-fix-warning drivers/atm/firestre=
am.c
--- a/drivers/atm/firestream.c~atm-fix-warning
+++ a/drivers/atm/firestream.c
@@ -1475,6 +1475,7 @@ static void top_off_fp (struct fs_dev *d
 	struct FS_BPENTRY *qe, *ne;
 	struct sk_buff *skb;
 	int n =3D 0;
+	u32 qe_tmp;
=20
 	fs_dprintk (FS_DEBUG_QUEUE, "Topping off queue at %x (%d-%d/%d)\n",=20
 		    fp->offset, read_fs (dev, FP_CNT (fp->offset)), fp->n,=20
@@ -1502,10 +1503,16 @@ static void top_off_fp (struct fs_dev *d
 		ne->skb =3D skb;
 		ne->fp =3D fp;
=20
-		qe =3D (struct FS_BPENTRY *) (read_fs (dev, FP_EA(fp->offset)));
-		fs_dprintk (FS_DEBUG_QUEUE, "link at %p\n", qe);
-		if (qe) {
-			qe =3D bus_to_virt ((long) qe);
+		/*
+		 * FIXME: following code encodes and decodes
+		 * machine pointers (could be 64-bit) into a
+		 * 32-bit register.
+		 */
+
+		qe_tmp =3D read_fs (dev, FP_EA(fp->offset));
+		fs_dprintk (FS_DEBUG_QUEUE, "link at %x\n", qe_tmp);
+		if (qe_tmp) {
+			qe =3D bus_to_virt ((long) qe_tmp);
 			qe->next =3D virt_to_bus(ne);
 			qe->flags &=3D ~FP_FLAGS_EPI;
 		} else
_

Patches currently in -mm which might be from jeff@garzik.org are

pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480.patch
git-ieee1394.patch
git-libata-all.patch
git-ubi.patch
git-netdev-all.patch
8139too-force-media-setting-fix.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
atm-fix-warning.patch
git-ioat.patch
remove-pci_dac_dma_-apis.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
s390-spinlock-initializer-cleanup.patch
git-scsi-misc.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
add-select-phylib-to-the-ucc_geth-kconfig-option.patch
potential-parse-error-in-ifdef.patch
e1000-restore-netif_poll_enable-call-but-make-sure-irqs-are-off.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups-update.patch
git-gccbug.patch
