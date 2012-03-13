From: akpm@linux-foundation.org
Subject: + scripts-coccinelle-api-simple_opencocci-semantic-patch-for-simple_open.patch added to -mm tree
Date: Tue, 13 Mar 2012 13:54:38 -0700
Message-ID: <20120313205439.422FFA00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37571 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab2CMUyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Mar 2012 16:54:41 -0400
Received: by yhgm50 with SMTP id m50so165142yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Mar 2012 13:54:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Julia.Lawall@lip6.fr, sboyd@codeaurora.org


The patch titled
     Subject: scripts/coccinelle/api/simple_open.cocci: semantic patch for simple_open()
has been added to the -mm tree.  Its filename is
     scripts-coccinelle-api-simple_opencocci-semantic-patch-for-simple_open.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: scripts/coccinelle/api/simple_open.cocci: semantic patch for simple_open()

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

linux-next.patch
libfs-add-simple_open.patch
scripts-coccinelle-api-simple_opencocci-semantic-patch-for-simple_open.patch
simple_open-automatically-convert-to-simple_open.patch
drivers-video-backlight-wm831x_blc-use-devm_-functions.patch
drivers-video-backlight-use-devm_-functions.patch
drivers-video-backlight-adp5520_blc-use-devm_-functions.patch

