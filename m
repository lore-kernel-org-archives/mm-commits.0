From: akpm@linux-foundation.org
Subject: + coccinelle-semantic-patch-for-simple_open.patch added to -mm tree
Date: Tue, 06 Mar 2012 16:41:14 -0800
Message-ID: <20120307004114.F2E1FA0313@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:62734 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2CGAlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 19:41:16 -0500
Received: by vcbfk26 with SMTP id fk26so717830vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 16:41:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, Julia.Lawall@lip6.fr, viro@zeniv.linux.org.uk


The patch titled
     Subject: coccinelle: semantic patch for simple_open()
has been added to the -mm tree.  Its filename is
     coccinelle-semantic-patch-for-simple_open.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: coccinelle: semantic patch for simple_open()

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch
libfs-add-simple_open.patch
coccinelle-semantic-patch-for-simple_open.patch

