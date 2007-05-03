From: akpm@linux-foundation.org
Subject: + allow-arch-to-initialize-arch-field-of-the-module-structure.patch added to -mm tree
Date: Wed, 02 May 2007 21:27:29 -0700
Message-ID: <200705030427.l434RT3K004703@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767378AbXECE1m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 00:27:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, geert@linux-m68k.org


The patch titled
     Allow arch to initialize arch field of the module structure
has been added to the -mm tree.  Its filename is
     allow-arch-to-initialize-arch-field-of-the-module-structure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -360,6 +360,9 @@ struct module
 	const struct __mark_marker *markers;
 	unsigned int num_markers;
 };
+#ifndef MODULE_ARCH_INIT
+#define MODULE_ARCH_INIT {}
+#endif
 
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
diff -puN scripts/mod/modpost.c~allow-arch-to-initialize-arch-field-of-the-module-structure scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~allow-arch-to-initialize-arch-field-of-the-module-structure
+++ a/scripts/mod/modpost.c
@@ -1356,6 +1356,7 @@ static void add_header(struct buffer *b,
 		buf_printf(b, "#ifdef CONFIG_MODULE_UNLOAD\n"
 			      " .exit = cleanup_module,\n"
 			      "#endif\n");
+	buf_printf(b, " .arch = MODULE_ARCH_INIT,\n");
 	buf_printf(b, "};\n");
 }
 
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
introduce-config_has_dma.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
git-kbuild.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
is_power_of_2-in-fs-hfs.patch
optimize-timespec_trunc.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch
wrap-access-to-thread_info.patch
rename-thread_info-to-stack.patch
