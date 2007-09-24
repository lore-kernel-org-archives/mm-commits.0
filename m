From: akpm@linux-foundation.org
Subject: + git-net-fix-pasemi_mac.patch added to -mm tree
Date: Mon, 24 Sep 2007 15:33:54 -0700
Message-ID: <200709242233.l8OMXsL5021125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530AbXIXWd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 18:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, davem@davemloft.net


The patch titled
     git-net: fix pasemi_mac
has been added to the -mm tree.  Its filename is
     git-net-fix-pasemi_mac.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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

fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
git-net-fix-macec.patch
git-net-fix-pasemi_mac.patch
git-block-ps3disk-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patc=
h
use-extended-crashkernel-command-line-on-ia64-fix.patch
