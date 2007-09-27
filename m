From: akpm@linux-foundation.org
Subject: - git-net-fix-pasemi_mac.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:34 -0700
Message-ID: <200709270143.l8R1hYgC013974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48304 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581AbXI0BvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     git-net: fix pasemi_mac
has been removed from the -mm tree.  Its filename was
     git-net-fix-pasemi_mac.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: git-net: fix pasemi_mac
=46rom: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

drivers/net/pasemi_mac.c: In function =E2=80=98pasemi_mac_probe=E2=80=99=
:
drivers/net/pasemi_mac.c:1153: error: conflicting types for =E2=80=98ma=
c=E2=80=99
drivers/net/pasemi_mac.c:1151: error: previous declaration of =E2=80=98=
mac=E2=80=99 was here
drivers/net/pasemi_mac.c:1170: error: incompatible types in assignment
drivers/net/pasemi_mac.c:1172: error: request for member =E2=80=98pdev=E2=
=80=99 in
something not a structure or union

In the function
static int __devinit
pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
{
<snip>
struct pasemi_mac *mac;
int err;
DECLARE_MAC_BUF(mac);

introduction of mac as var [18] triggers the build failure, so in the b=
elow
patch renaming mac as mac_buf is done, because it is used to print the =
mac
address using the newly introduced print_mac function.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pasemi_mac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/pasemi_mac.c~git-net-fix-pasemi_mac drivers/net/p=
asemi_mac.c
--- a/drivers/net/pasemi_mac.c~git-net-fix-pasemi_mac
+++ a/drivers/net/pasemi_mac.c
@@ -1150,7 +1150,7 @@ pasemi_mac_probe(struct pci_dev *pdev, c
 	struct net_device *dev;
 	struct pasemi_mac *mac;
 	int err;
-	DECLARE_MAC_BUF(mac);
+	DECLARE_MAC_BUF(mac_buf);
=20
 	err =3D pci_enable_device(pdev);
 	if (err)
@@ -1236,7 +1236,7 @@ pasemi_mac_probe(struct pci_dev *pdev, c
 		       "hw addr %s\n",
 		       dev->name, mac->type =3D=3D MAC_TYPE_GMAC ? "GMAC" : "XAUI",
 		       mac->dma_if, mac->dma_txch, mac->dma_rxch,
-		       print_mac(mac, dev->dev_addr));
+		       print_mac(mac_buf, dev->dev_addr));
=20
 	return err;
=20
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.co=
m are

git-net.patch
git-nfsd.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patc=
h
use-extended-crashkernel-command-line-on-ia64-fix.patch
