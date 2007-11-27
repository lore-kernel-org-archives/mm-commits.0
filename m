From: akpm@linux-foundation.org
Subject: + ppc-chrp-fix-possible-null-pointer-dereference.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:31:42 -0800
Message-ID: <200711270531.lAR5Vgsx029108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbXK0FcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:32:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, benh@kernel.crashing.org, olof@lixom.net, paulus@samba.org


The patch titled
     PPC: CHRP: fix possible NULL pointer dereference
has been added to the -mm tree.  Its filename is
     ppc-chrp-fix-possible-null-pointer-dereference.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PPC: CHRP: fix possible NULL pointer dereference
From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix possible NULL pointer dereference inside of strncmp() if
of_get_property() failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/chrp/setup.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/platforms/chrp/setup.c~ppc-chrp-fix-possible-null-pointer-dereference arch/powerpc/platforms/chrp/setup.c
--- a/arch/powerpc/platforms/chrp/setup.c~ppc-chrp-fix-possible-null-pointer-dereference
+++ a/arch/powerpc/platforms/chrp/setup.c
@@ -115,7 +115,7 @@ void chrp_show_cpuinfo(struct seq_file *
 	seq_printf(m, "machine\t\t: CHRP %s\n", model);
 
 	/* longtrail (goldengate) stuff */
-	if (!strncmp(model, "IBM,LongTrail", 13)) {
+	if (model && !strncmp(model, "IBM,LongTrail", 13)) {
 		/* VLSI VAS96011/12 `Golden Gate 2' */
 		/* Memory banks */
 		sdramen = (in_le32(gg2_pci_config_base + GG2_PCI_DRAM_CTRL)
@@ -203,15 +203,20 @@ static void __init sio_fixup_irq(const c
 static void __init sio_init(void)
 {
 	struct device_node *root;
+	const char *model;
 
-	if ((root = of_find_node_by_path("/")) &&
-	    !strncmp(of_get_property(root, "model", NULL),
-			"IBM,LongTrail", 13)) {
+	root = of_find_node_by_path("/");
+	if (!root)
+		return;
+
+	model = of_get_property(root, "model", NULL);
+	if (model && !strncmp(model,"IBM,LongTrail", 13)) {
 		/* logical device 0 (KBC/Keyboard) */
 		sio_fixup_irq("keyboard", 0, 1, 2);
 		/* select logical device 1 (KBC/Mouse) */
 		sio_fixup_irq("mouse", 1, 12, 2);
 	}
+
 	of_node_put(root);
 }
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-powerpc.patch
ppc-fix-missed-increment-on-device-interface-counter.patch
ppc-chrp-fix-possible-null-pointer-dereference.patch
git-sparc64.patch
git-x86.patch
