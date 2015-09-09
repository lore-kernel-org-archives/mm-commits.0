From: akpm@linux-foundation.org
Subject: [merged]
 coccinelle-mm-scripts-coccinelle-api-alloc-pool_zalloc-simplecocci.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:47:05 -0700
Message-ID: <55f08cb9.mDpZ3q8qdUkAnXkd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbbIITrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sean.stalley@intel.com, Gilles.Muller@lip6.fr, bhelgaas@google.com, bigeasy@linutronix.de, corbet@lwn.net, julia.lawall@lip6.fr, mmarek@suse.cz, nicolas.palix@imag.fr, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coccinelle: mm: scripts/coccinelle/api/alloc/pool_zalloc-simple.cocci
has been removed from the -mm tree.  Its filename was
     coccinelle-mm-scripts-coccinelle-api-alloc-pool_zalloc-simplecocci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Sean O. Stalley" <sean.stalley@intel.com>
Subject: coccinelle: mm: scripts/coccinelle/api/alloc/pool_zalloc-simple.cocci

add [pci|dma]_pool_zalloc coccinelle check.
replaces instances of [pci|dma]_pool_alloc() followed by memset(0)
with [pci|dma]_pool_zalloc().

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/api/alloc/pool_zalloc-simple.cocci |   84 ++++++++++
 1 file changed, 84 insertions(+)

diff -puN /dev/null scripts/coccinelle/api/alloc/pool_zalloc-simple.cocci
--- /dev/null
+++ a/scripts/coccinelle/api/alloc/pool_zalloc-simple.cocci
@@ -0,0 +1,84 @@
+///
+/// Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0
+///
+// Copyright: (C) 2015 Intel Corp.  GPLv2.
+// Options: --no-includes --include-headers
+//
+// Keywords: dma_pool_zalloc, pci_pool_zalloc
+//
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+//----------------------------------------------------------
+//  For context mode
+//----------------------------------------------------------
+
+@depends on context@
+expression x;
+statement S;
+@@
+
+* x = \(dma_pool_alloc\|pci_pool_alloc\)(...);
+  if ((x==NULL) || ...) S
+* memset(x,0, ...);
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on patch@
+expression x;
+expression a,b,c;
+statement S;
+@@
+
+- x = dma_pool_alloc(a,b,c);
++ x = dma_pool_zalloc(a,b,c);
+  if ((x==NULL) || ...) S
+- memset(x,0,...);
+
+@depends on patch@
+expression x;
+expression a,b,c;
+statement S;
+@@
+
+- x = pci_pool_alloc(a,b,c);
++ x = pci_pool_zalloc(a,b,c);
+  if ((x==NULL) || ...) S
+- memset(x,0,...);
+
+//----------------------------------------------------------
+//  For org and report mode
+//----------------------------------------------------------
+
+@r depends on org || report@
+expression x;
+expression a,b,c;
+statement S;
+position p;
+@@
+
+ x = @p\(dma_pool_alloc\|pci_pool_alloc\)(a,b,c);
+ if ((x==NULL) || ...) S
+ memset(x,0, ...);
+
+@script:python depends on org@
+p << r.p;
+x << r.x;
+@@
+
+msg="%s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)
+
+@script:python depends on report@
+p << r.p;
+x << r.x;
+@@
+
+msg="WARNING: *_pool_zalloc should be used for %s, instead of *_pool_alloc/memset" % (x)
+coccilib.report.print_report(p[0], msg)
_

Patches currently in -mm which might be from sean.stalley@intel.com are


