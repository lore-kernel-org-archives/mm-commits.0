From: akpm@linux-foundation.org
Subject: + edac-cpc925-mc-platform-device-setup-v3.patch added to -mm tree
Date: Fri, 17 Apr 2009 11:30:08 -0700
Message-ID: <200904171830.n3HIU87O026865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570AbZDQSfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qingtao.cao@windriver.com, benh@kernel.crashing.org, galak@gate.crashing.org, michael@ellerman.id.au, norsk5@yahoo.com, paulus@samba.org


The patch titled
     edac-cpc925-mc-platform-device-setup-v3
has been added to the -mm tree.  Its filename is
     edac-cpc925-mc-platform-device-setup-v3.patch

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
Subject: edac-cpc925-mc-platform-device-setup-v3
From: Harry Ciao <qingtao.cao@windriver.com>

Fixup the number of cells for the values of CPC925 Memory Controller,
and setup related platform device during system booting up, against
which CPC925 Memory Controller EDAC driver would be matched.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/prom_init.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/powerpc/kernel/prom_init.c~edac-cpc925-mc-platform-device-setup-v3 arch/powerpc/kernel/prom_init.c
--- a/arch/powerpc/kernel/prom_init.c~edac-cpc925-mc-platform-device-setup-v3
+++ a/arch/powerpc/kernel/prom_init.c
@@ -1956,6 +1956,8 @@ static void __init fixup_device_tree_map
 	phandle mc;
 	u32 mc_reg[4];
 	char *name = "/hostbridge@f8000000";
+	struct prom_t *_prom = &RELOC(prom);
+	u32 ac, sc;
 
 	mc = call_prom("finddevice", 1, 1, ADDR(name));
 	if (!PHANDLE_VALID(mc))
@@ -1964,6 +1966,11 @@ static void __init fixup_device_tree_map
 	if (prom_getproplen(mc, "reg") != 8)
 		return;
 
+	prom_getprop(_prom->root, "#address-cells", &ac, sizeof(ac));
+	prom_getprop(_prom->root, "#size-cells", &sc, sizeof(sc));
+	if ((ac != 2) || (sc != 2))
+		return;
+
 	if (prom_getprop(mc, "reg", mc_reg, sizeof(mc_reg)) == PROM_ERROR)
 		return;
 
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

edac-add-cpc925-memory-controller-driver.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-cpc925-mc-platform-device-setup.patch
edac-cpc925-mc-platform-device-setup-v3.patch

