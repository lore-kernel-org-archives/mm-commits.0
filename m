From: akpm@linux-foundation.org
Subject: - uml-fix-umid-in-xterm-titles.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:35 -0700
Message-ID: <200705080006.l4806ZjH009204@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967397AbXEHAG7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davide.brini@unibo.it, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix umid in xterm titles
has been removed from the -mm tree.  Its filename was
     uml-fix-umid-in-xterm-titles.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix umid in xterm titles
From: Davide Brini <davide.brini@unibo.it>

Calls lines_init() *after* xterm_title is modified to include umid.

Signed-off-by: Davide Brini <davide.brini@unibo.it>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Acked-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
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

origin.patch
