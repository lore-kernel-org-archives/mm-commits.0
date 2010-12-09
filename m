From: akpm@linux-foundation.org
Subject: + pci-update-mcp55-quirk-to-not-affect-non-hypertransport-variants.patch added to -mm tree
Date: Thu, 09 Dec 2010 15:40:06 -0800
Message-ID: <201012092340.oB9Ne64N014055__33063.454196281$1291938086$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756661Ab0LIXlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 18:41:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, jbarnes@virtuousgeek.org, mathieu@mberard.eu, stable@kernel.org, vgoyal@redhat.com


The patch titled
     pci: update MCP55 quirk to not affect non HyperTransport variants
has been added to the -mm tree.  Its filename is
     pci-update-mcp55-quirk-to-not-affect-non-hypertransport-variants.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: pci: update MCP55 quirk to not affect non HyperTransport varia=
nts
=46rom: Neil Horman <nhorman@tuxdriver.com>

I wrote this quirk awhile ago to properly setup MCP55 chips on
hypertransport busses so that interrupts reached whatever cpu happend t=
o
boot the kdump kernel.  while that works well, it was recently shown to=
 me
that a a non-hypertransport variant of the MCP55 exists, and on those
system the register that this quirk manipulates causes hangs if you wri=
te
to it.  Since the quirk was only meant to handle errors found on MCP55
chips that have a HT interface, this patch adds a filter to make sure t=
he
chip is an HT capable before making the needed register adjustment.  Th=
is
lets the broken MCP55s work with kdump while not breaking the non-HT
variants.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=3D23952

Tested successfully by the reporter and myself.

Reported-by: Mathieu B=E9rard <mathieu@mberard.eu>
Tested-by: Mathieu B=E9rard <mathieu@mberard.eu>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/pci/quirks.c~pci-update-mcp55-quirk-to-not-affect-non=
-hypertransport-variants drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-update-mcp55-quirk-to-not-affect-non-hyp=
ertransport-variants
+++ a/drivers/pci/quirks.c
@@ -2329,6 +2329,9 @@ static void __devinit nvbridge_check_leg
 {
 	u32 cfg;
=20
+	if (!pci_find_capability(dev, PCI_CAP_ID_HT))
+		return;
+
 	pci_read_config_dword(dev, 0x74, &cfg);
=20
 	if (cfg & ((1 << 2) | (1 << 15))) {
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
pci-update-mcp55-quirk-to-not-affect-non-hypertransport-variants.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
