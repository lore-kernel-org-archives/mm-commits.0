From: akpm@linux-foundation.org
Subject: [nacked] coccinelle-semantic-patch-for-simple_open.patch removed from -mm tree
Date: Wed, 07 Mar 2012 15:33:04 -0800
Message-ID: <20120307233304.A38F6A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:64907 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab2CGXdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Mar 2012 18:33:05 -0500
Received: by ghbz15 with SMTP id z15so873850ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Mar 2012 15:33:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, Julia.Lawall@lip6.fr, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coccinelle: semantic patch for simple_open()
has been removed from the -mm tree.  Its filename was
     coccinelle-semantic-patch-for-simple_open.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: coccinelle: semantic patch for simple_open()

Find instances of an open-coded simple_open() and replace them with calls
to simple_open().

This seems to eat the definition of simple_open() as well.  Is there a way
to say only remove both the function and the reference to the function so
that libfs survives?

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/api/simple_open.cocci |   34 +++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN /dev/null scripts/coccinelle/api/simple_open.cocci
--- /dev/null
+++ a/scripts/coccinelle/api/simple_open.cocci
@@ -0,0 +1,34 @@
+// This removes an open coded simple_open() function
+// and replaces file operations references to the function
+// with simple_open() instead.
+//
+
+virtual patch
+virtual context
+
+@ open @
+identifier open_f;
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
+...
+-.open = open_f,
++.open = simple_open,
+...
+};
+
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch
libfs-add-simple_open.patch

