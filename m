From: akpm@linux-foundation.org
Subject: - powerpc-powermac-add-missing-of_node_put.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:31 -0800
Message-ID: <200901082251.n08MpVaS030627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759299AbZAHWvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npalix@diku.dk, julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     powerpc/powermac: Add missing of_node_put
has been removed from the -mm tree.  Its filename was
     powerpc-powermac-add-missing-of_node_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc/powermac: Add missing of_node_put
From: Nicolas Palix <npalix@diku.dk>

of_node_put is needed before discarding a value received from
of_find_node_by_name, eg in error handling code or when the device
node is no longer used.

The semantic match that catches the bug is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression struct device_node *n;
position p1, p2;
struct device_node *n1;
statement S;
identifier f;
expression E;
expression *ptr != NULL;
@@

n@p1 = of_find_node_by_name(...)
...
if (!n) S
... when != of_node_put(n)
    when != n1 = f(n,...)
    when != E = n
    when any
    when strict
(
  return \(0\|<+...n...+>\|ptr\);
|
return@p2 ...;
|
  of_node_put(n);
|
  n1 = f(n,...)
|
  E = n
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s of_find_node_by_name %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powermac/pci.c  |    2 ++
 arch/powerpc/platforms/powermac/time.c |    9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/platforms/powermac/pci.c~powerpc-powermac-add-missing-of_node_put arch/powerpc/platforms/powermac/pci.c
--- a/arch/powerpc/platforms/powermac/pci.c~powerpc-powermac-add-missing-of_node_put
+++ a/arch/powerpc/platforms/powermac/pci.c
@@ -661,6 +661,7 @@ static void __init init_second_ohare(voi
 			pci_find_hose_for_OF_device(np);
 		if (!hose) {
 			printk(KERN_ERR "Can't find PCI hose for OHare2 !\n");
+			of_node_put(np);
 			return;
 		}
 		early_read_config_word(hose, bus, devfn, PCI_COMMAND, &cmd);
@@ -669,6 +670,7 @@ static void __init init_second_ohare(voi
 		early_write_config_word(hose, bus, devfn, PCI_COMMAND, cmd);
 	}
 	has_second_ohare = 1;
+	of_node_put(np);
 }
 
 /*
diff -puN arch/powerpc/platforms/powermac/time.c~powerpc-powermac-add-missing-of_node_put arch/powerpc/platforms/powermac/time.c
--- a/arch/powerpc/platforms/powermac/time.c~powerpc-powermac-add-missing-of_node_put
+++ a/arch/powerpc/platforms/powermac/time.c
@@ -270,11 +270,11 @@ int __init via_calibrate_decr(void)
 	if (vias == 0)
 		vias = of_find_node_by_name(NULL, "via");
 	if (vias == 0 || of_address_to_resource(vias, 0, &rsrc))
-		return 0;
+		goto fail;
 	via = ioremap(rsrc.start, rsrc.end - rsrc.start + 1);
 	if (via == NULL) {
 		printk(KERN_ERR "Failed to map VIA for timer calibration !\n");
-		return 0;
+		goto fail;
 	}
 
 	/* set timer 1 for continuous interrupts */
@@ -297,8 +297,11 @@ int __init via_calibrate_decr(void)
 	ppc_tb_freq = (dstart - dend) * 100 / 6;
 
 	iounmap(via);
-	
+
 	return 1;
+fail:
+	of_node_put(vias);
+	return 0;
 }
 #endif
 
_

Patches currently in -mm which might be from npalix@diku.dk are

origin.patch

