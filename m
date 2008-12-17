From: akpm@linux-foundation.org
Subject: - powerpc-chrp-add-missing-of_node_put-in-pcic.patch removed from -mm tree
Date: Wed, 17 Dec 2008 12:48:26 -0800
Message-ID: <200812172048.mBHKmQLT006772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbYLQUtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 15:49:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npalix@diku.dk, julia@diku.dk, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     powerpc/chrp: Add missing of_node_put in pci.c
has been removed from the -mm tree.  Its filename was
     powerpc-chrp-add-missing-of_node_put-in-pcic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc/chrp: Add missing of_node_put in pci.c
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
statement S1,S2;
expression E,E1;
expression *ptr != NULL;
@@

(
if (!(n@p1 = of_find_node_by_name(...))) S1
|
n@p1 = of_find_node_by_name(...)
)
<... when != of_node_put(n)
    when != if (...) { <+... of_node_put(n) ...+> }
    when != true !n  || ...
    when != n = E
    when != E = n
if (!n || ...) S2
...>
(
  return \(0\|<+...n...+>\|ptr\);
|
return@p2 ...;
|
n = E1
|
E1 = n
)
@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s of_find_node_by_name %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/chrp/pci.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/platforms/chrp/pci.c~powerpc-chrp-add-missing-of_node_put-in-pcic arch/powerpc/platforms/chrp/pci.c
--- a/arch/powerpc/platforms/chrp/pci.c~powerpc-chrp-add-missing-of_node_put-in-pcic
+++ a/arch/powerpc/platforms/chrp/pci.c
@@ -141,6 +141,7 @@ hydra_init(void)
 		of_node_put(np);
 		return 0;
 	}
+	of_node_put(np);
 	Hydra = ioremap(r.start, r.end-r.start);
 	printk("Hydra Mac I/O at %llx\n", (unsigned long long)r.start);
 	printk("Hydra Feature_Control was %x",
_

Patches currently in -mm which might be from npalix@diku.dk are

linux-next.patch
powerpc-powermac-add-missing-of_node_put.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch

