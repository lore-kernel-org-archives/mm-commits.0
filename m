From: akpm@linux-foundation.org
Subject: + pci-enable-msi-on-8132.patch added to -mm tree
Date: Wed, 18 Feb 2009 02:00:21 -0800
Message-ID: <200902181000.n1IA0Lpa019116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbZBRKAx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 05:00:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, david@lang.hm, jbarnes@virtuousgeek.org, mingo@elte.hu


The patch titled
     pci: enable MSI on 8132
has been added to the -mm tree.  Its filename is
     pci-enable-msi-on-8132.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: enable MSI on 8132
From: Yinghai Lu <yinghai@kernel.org>

Impact: workaround BIOS that doesn't enable that bit

David reported that LSI sas doesn't work with MSI.  it turns out that BIOS
doesn't enable HT MSI 8132 does support HT MSI.  add quirk to enable it

Reported-by: David Lang <david@lang.hm>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pci/quirks.c~pci-enable-msi-on-8132 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-enable-msi-on-8132
+++ a/drivers/pci/quirks.c
@@ -2008,7 +2008,6 @@ static void __devinit quirk_msi_ht_cap(s
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
 			quirk_msi_ht_cap);
 
