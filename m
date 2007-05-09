From: akpm@linux-foundation.org
Subject: - allow-arch-to-initialize-arch-field-of-the-module-structure.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:16 -0700
Message-ID: <200705092154.l49LsGtR003157@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759319AbXEIVyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Allow arch to initialize arch field of the module structure
has been removed from the -mm tree.  Its filename was
     allow-arch-to-initialize-arch-field-of-the-module-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Allow arch to initialize arch field of the module structure
From: Roman Zippel <zippel@linux-m68k.org>

This will later allow an arch to add module specific information via linker
generated tables instead of poking directly in the module object structure.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    3 +++
 scripts/mod/modpost.c  |    1 +
 2 files changed, 4 insertions(+)

diff -puN include/linux/module.h~allow-arch-to-initialize-arch-field-of-the-module-structure include/linux/module.h
--- a/include/linux/module.h~allow-arch-to-initialize-arch-field-of-the-module-structure
+++ a/include/linux/module.h
@@ -356,6 +356,9 @@ struct module
 	   keeping pointers to this stuff */
 	char *args;
 };
+#ifndef MODULE_ARCH_INIT
+#define MODULE_ARCH_INIT {}
+#endif
 
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
diff -puN scripts/mod/modpost.c~allow-arch-to-initialize-arch-field-of-the-module-structure scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~allow-arch-to-initialize-arch-field-of-the-module-structure
+++ a/scripts/mod/modpost.c
@@ -1343,6 +1343,7 @@ static void add_header(struct buffer *b,
 		buf_printf(b, "#ifdef CONFIG_MODULE_UNLOAD\n"
 			      " .exit = cleanup_module,\n"
 			      "#endif\n");
+	buf_printf(b, " .arch = MODULE_ARCH_INIT,\n");
 	buf_printf(b, "};\n");
 }
 
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
