From: akpm@linux-foundation.org
Subject: [merged] scripts-coccinelle-api-simple_opencocci-semantic-patch-for-simple_open.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:48:59 -0700
Message-ID: <20120406184859.74364A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:34634 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab2DFStA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:49:00 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so298977ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:48:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/coccinelle/api/simple_open.cocci: semantic patch for simple_open()
has been removed from the -mm tree.  Its filename was
     scripts-coccinelle-api-simple_opencocci-semantic-patch-for-simple_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: scripts/coccinelle/api/simple_open.cocci: semantic patch for simple_open()

Find instances of an open-coded simple_open() and replace them with calls
to simple_open().

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/api/simple_open.cocci |   70 +++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff -puN /dev/null scripts/coccinelle/api/simple_open.cocci
--- /dev/null
+++ a/scripts/coccinelle/api/simple_open.cocci
@@ -0,0 +1,70 @@
+/// This removes an open coded simple_open() function
+/// and replaces file operations references to the function
+/// with simple_open() instead.
+///
+// Confidence: High
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual patch
+virtual report
+
+@ open depends on patch @
+identifier open_f != simple_open;
+identifier i, f;
+@@
+-int open_f(struct inode *i, struct file *f)
+-{
+(
+-if (i->i_private)
+-f->private_data = i->i_private;
+|
+-f->private_data = i->i_private;
+)
+-return 0;
+-}
+
+@ has_open depends on open @
+identifier fops;
+identifier open.open_f;
+@@
+struct file_operations fops = {
+...,
+-.open = open_f,
++.open = simple_open,
+...
+};
+
+@ openr depends on report @
+identifier open_f != simple_open;
+identifier i, f;
+position p;
+@@
+int open_f@p(struct inode *i, struct file *f)
+{
+(
+if (i->i_private)
+f->private_data = i->i_private;
+|
+f->private_data = i->i_private;
+)
+return 0;
+}
+
+@ has_openr depends on openr @
+identifier fops;
+identifier openr.open_f;
+position p;
+@@
+struct file_operations fops = {
+...,
+.open = open_f@p,
+...
+};
+
+@script:python@
+pf << openr.p;
+ps << has_openr.p;
+@@
+
+coccilib.report.print_report(pf[0],"WARNING opportunity for simple_open, see also structure on line %s"%(ps[0].line))
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

origin.patch
linux-next.patch

