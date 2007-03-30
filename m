From: akpm@linux-foundation.org
Subject: + uml-fix-umid-in-xterm-titles.patch added to -mm tree
Date: Fri, 30 Mar 2007 14:21:35 -0700
Message-ID: <200703302121.l2ULLZ8k005956@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53229 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbXC3VVn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 17:21:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davide.brini@unibo.it, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: fix umid in xterm titles
has been added to the -mm tree.  Its filename is
     uml-fix-umid-in-xterm-titles.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix umid in xterm titles
From: Davide Brini <davide.brini@unibo.it>

Calls lines_init() *after* xterm_title is modified to include umid.

Signed-off-by: Davide Brini <davide.brini@unibo.it>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ssl.c           |    4 ++--
 arch/um/drivers/stdio_console.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/um/drivers/ssl.c~uml-fix-umid-in-xterm-titles arch/um/drivers/ssl.c
--- a/arch/um/drivers/ssl.c~uml-fix-umid-in-xterm-titles
+++ a/arch/um/drivers/ssl.c
@@ -191,12 +191,12 @@ static int ssl_init(void)
 	ssl_driver = register_lines(&driver, &ssl_ops, serial_lines,
 				    ARRAY_SIZE(serial_lines));
 
-	lines_init(serial_lines, ARRAY_SIZE(serial_lines), &opts);
-
 	new_title = add_xterm_umid(opts.xterm_title);
 	if (new_title != NULL)
 		opts.xterm_title = new_title;
 
+	lines_init(serial_lines, ARRAY_SIZE(serial_lines), &opts);
+
 	ssl_init_done = 1;
 	register_console(&ssl_cons);
 	return 0;
diff -puN arch/um/drivers/stdio_console.c~uml-fix-umid-in-xterm-titles arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-fix-umid-in-xterm-titles
+++ a/arch/um/drivers/stdio_console.c
@@ -166,12 +166,12 @@ int stdio_init(void)
 		return -1;
 	printk(KERN_INFO "Initialized stdio console driver\n");
 
-	lines_init(vts, ARRAY_SIZE(vts), &opts);
-
 	new_title = add_xterm_umid(opts.xterm_title);
 	if(new_title != NULL)
 		opts.xterm_title = new_title;
 
+	lines_init(vts, ARRAY_SIZE(vts), &opts);
+
 	con_init_done = 1;
 	register_console(&stdiocons);
 	return 0;
_

Patches currently in -mm which might be from davide.brini@unibo.it are

uml-fix-umid-in-xterm-titles.patch
