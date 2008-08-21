From: akpm@linux-foundation.org
Subject: + r8169-balance-pci_map-pci_unmap-pair.patch added to -mm tree
Date: Thu, 21 Aug 2008 14:57:27 -0700
Message-ID: <200808212157.m7LLvROo028029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757423AbYHUV7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 17:59:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com, alistair@devzero.co.uk, edward_hsu@realtek.com.tw, ilpo.jarvinen@helsinki.fi, jeff@garzik.org, stable@kernel.org, tjfontaine@atxconsulting.com


The patch titled
     r8169: balance pci_map / pci_unmap pair
has been added to the -mm tree.  Its filename is
     r8169-balance-pci_map-pci_unmap-pair.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: r8169: balance pci_map / pci_unmap pair
=46rom: Francois Romieu <romieu@fr.zoreil.com>

The leak hurts with swiotlb and jumbo frames (see
http://bugzilla.kernel.org/show_bug.cgi?id=3D9468).

Heavily hinted by Ilpo J=E4rvinen

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Tested-by: Alistair John Strachan <alistair@devzero.co.uk>
Tested-by: Timothy J Fontaine <tjfontaine@atxconsulting.com>
Cc: Edward Hsu <edward_hsu@realtek.com.tw>
Cc: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r8169.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/r8169.c~r8169-balance-pci_map-pci_unmap-pair driv=
ers/net/r8169.c
--- a/drivers/net/r8169.c~r8169-balance-pci_map-pci_unmap-pair
+++ a/drivers/net/r8169.c
@@ -2792,7 +2792,7 @@ static int rtl8169_rx_interrupt(struct n
 					pkt_size, PCI_DMA_FROMDEVICE);
 				rtl8169_mark_to_asic(desc, tp->rx_buf_sz);
 			} else {
-				pci_unmap_single(pdev, addr, pkt_size,
+				pci_unmap_single(pdev, addr, tp->rx_buf_sz,
 						 PCI_DMA_FROMDEVICE);
 				tp->Rx_skbuff[entry] =3D NULL;
 			}
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

r8169-balance-pci_map-pci_unmap-pair.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
