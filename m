From: akpm@linux-foundation.org
Subject: [merged] coccinelle-add-api-d_find_aliascocci.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:39:35 -0800
Message-ID: <20121219203936.1AE75200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:60797 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2LSUji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:39:38 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so133945wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:39:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tipecaml@gmail.com, Gilles.Muller@lip6.fr, Julia.Lawall@lip6.fr, nicolas.palix@imag.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: Coccinelle: add api/d_find_alias.cocci
has been removed from the -mm tree.  Its filename was
     coccinelle-add-api-d_find_aliascocci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyril Roelandt <tipecaml@gmail.com>
Subject: Coccinelle: add api/d_find_alias.cocci

Ensure that calls to d_find_alias() have a corresponding dput().

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/api/d_find_alias.cocci |   80 ++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff -puN /dev/null scripts/coccinelle/api/d_find_alias.cocci
--- /dev/null
+++ a/scripts/coccinelle/api/d_find_alias.cocci
@@ -0,0 +1,80 @@
+/// Make sure calls to d_find_alias() have a corresponding call to dput().
+//
+// Keywords: d_find_alias, dput
+//
+// Confidence: Moderate
+// URL: http://coccinelle.lip6.fr/
+// Options: -include_headers
+
+virtual context
+virtual org
+virtual patch
+virtual report
+
+@r exists@
+local idexpression struct dentry *dent;
+expression E, E1;
+statement S1, S2;
+position p1, p2;
+@@
+(
+	if (!(dent@p1 = d_find_alias(...))) S1
+|
+	dent@p1 = d_find_alias(...)
+)
+
+<...when != dput(dent)
+    when != if (...) { <+... dput(dent) ...+> }
+    when != true !dent || ...
+    when != dent = E
+    when != E = dent
+if (!dent || ...) S2
+...>
+(
+	return <+...dent...+>;
+|
+	return @p2 ...;
+|
+	dent@p2 = E1;
+|
+	E1 = dent;
+)
+
+@depends on context@
+local idexpression struct dentry *r.dent;
+position r.p1,r.p2;
+@@
+* dent@p1 = ...
+  ...
+(
+* return@p2 ...;
+|
+* dent@p2
+)
+
+
+@script:python depends on org@
+p1 << r.p1;
+p2 << r.p2;
+@@
+cocci.print_main("Missing call to dput()",p1)
+cocci.print_secs("",p2)
+
+@depends on patch@
+local idexpression struct dentry *r.dent;
+position r.p2;
+@@
+(
++ dput(dent);
+  return @p2 ...;
+|
++ dput(dent);
+  dent@p2 = ...;
+)
+
+@script:python depends on report@
+p1 << r.p1;
+p2 << r.p2;
+@@
+msg = "Missing call to dput() at line %s."
+coccilib.report.print_report(p1[0], msg % (p2[0].line))
_

Patches currently in -mm which might be from tipecaml@gmail.com are

origin.patch

