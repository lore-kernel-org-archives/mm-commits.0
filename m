From: akpm@linux-foundation.org
Subject: - drivers-serial-uartlitec-add-missing-of_node_put.patch removed from -mm tree
Date: Tue, 11 Dec 2007 14:41:55 -0800
Message-ID: <200712112241.lBBMftoU012570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757190AbXLKWoW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 17:44:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, grant.likely@secretlab.ca, jacmet@sunsite.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/serial/uartlite.c: Add missing of_node_put
has been removed from the -mm tree.  Its filename was
     drivers-serial-uartlitec-add-missing-of_node_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/serial/uartlite.c: Add missing of_node_put
From: Julia Lawall <julia@diku.dk>

There should be an of_node_put when breaking out of a loop that iterates
using for_each_compatible_node.

This was detected and fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
identifier d;
type T;
expression e;
iterator for_each_compatible_node;
@@

T *d;
...
for_each_compatible_node(d,...)
  {... when != of_node_put(d)
       when != e = d
(
   return d;
|
+  of_node_put(d);
?  return ...;
)
...}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/uartlite.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/uartlite.c~drivers-serial-uartlitec-add-missing-of_node_put drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c~drivers-serial-uartlitec-add-missing-of_node_put
+++ a/drivers/serial/uartlite.c
@@ -393,6 +393,7 @@ static inline void __init ulite_console_
 			continue;
 
 		ulite_ports[id].mapbase = res.start;
+		of_node_put(np);
 		return;
 	}
 }
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa.patch
drivers-char-remove-unnecessary-pci_dev_put.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
git-input.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
