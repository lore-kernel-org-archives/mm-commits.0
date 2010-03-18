From: akpm@linux-foundation.org
Subject: [merged] phonet-use-for_each_set_bit.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:08:52 -0400
Message-ID: <201003181809.o2II9XeC007571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab0CRSKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:10:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, davem@davemloft.net, remi.denis-courmont@nokia.com, mm-commits@vger.kernel.org


The patch titled
     phonet: use for_each_set_bit()
has been removed from the -mm tree.  Its filename was
     phonet-use-for_each_set_bit.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: phonet: use for_each_set_bit()
=46rom: Akinobu Mita <akinobu.mita@gmail.com>

Replace open-coded loop with for_each_set_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: R=E9mi Denis-Courmont <remi.denis-courmont@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/phonet/pn_dev.c     |    3 +--
 net/phonet/pn_netlink.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN net/phonet/pn_dev.c~phonet-use-for_each_set_bit net/phonet/pn=
_dev.c
--- a/net/phonet/pn_dev.c~phonet-use-for_each_set_bit
+++ a/net/phonet/pn_dev.c
@@ -107,8 +107,7 @@ static void phonet_device_destroy(struct
 	if (pnd) {
 		u8 addr;
=20
-		for (addr =3D find_first_bit(pnd->addrs, 64); addr < 64;
-			addr =3D find_next_bit(pnd->addrs, 64, 1+addr))
+		for_each_set_bit(addr, pnd->addrs, 64)
 			phonet_address_notify(RTM_DELADDR, dev, addr);
 		kfree(pnd);
 	}
diff -puN net/phonet/pn_netlink.c~phonet-use-for_each_set_bit net/phone=
t/pn_netlink.c
--- a/net/phonet/pn_netlink.c~phonet-use-for_each_set_bit
+++ a/net/phonet/pn_netlink.c
@@ -141,8 +141,7 @@ static int getaddr_dumpit(struct sk_buff
 			continue;
=20
 		addr_idx =3D 0;
-		for (addr =3D find_first_bit(pnd->addrs, 64); addr < 64;
-			addr =3D find_next_bit(pnd->addrs, 64, 1+addr)) {
+		for_each_set_bit(addr, pnd->addrs, 64) {
 			if (addr_idx++ < addr_start_idx)
 				continue;
=20
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
ntfs-use-bitmap_weight.patch
hpet-use-for_each_set_bit.patch
linux-next.patch
intel-iommu-use-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
bitops-remove-temporary-for_each_bit.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
