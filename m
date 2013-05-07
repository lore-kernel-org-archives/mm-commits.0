From: akpm@linux-foundation.org
Subject: [merged] fs-make-binfmt-support-for-scripts-modular-and-removable.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:21 -0700
Message-ID: <20130507174821.7B1075A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:49767 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab3EGRsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:22 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so85191yen.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: make binfmt support for #! scripts modular and removable
has been removed from the -mm tree.  Its filename was
     fs-make-binfmt-support-for-scripts-modular-and-removable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: fs: make binfmt support for #! scripts modular and removable

Add a new configuration option CONFIG_BINFMT_SCRIPT to configure support
for interpreted scripts starting with "#!"; allow compiling out that
support, or building it as a module.  Embedded systems running exclusively
compiled binaries could leave this support out, and systems that don't
need scripts before mounting the root filesystem can build this as a
module.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig.binfmt |   14 ++++++++++++++
 fs/Makefile       |    5 +----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN fs/Kconfig.binfmt~fs-make-binfmt-support-for-scripts-modular-and-removable fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~fs-make-binfmt-support-for-scripts-modular-and-removable
+++ a/fs/Kconfig.binfmt
@@ -65,6 +65,20 @@ config CORE_DUMP_DEFAULT_ELF_HEADERS
 	  This config option changes the default setting of coredump_filter
 	  seen at boot time.  If unsure, say Y.
 
+config BINFMT_SCRIPT
+	tristate "Kernel support for scripts starting with #!"
+	default y
+	help
+	  Say Y here if you want to execute interpreted scripts starting with
+	  #! followed by the path to an interpreter.
+
+	  You can build this support as a module; however, until that module
+	  gets loaded, you cannot run scripts.  Thus, if you want to load this
+	  module from an initramfs, the portion of the initramfs before loading
+	  this module must consist of compiled binaries only.
+
+	  Most systems will not boot if you say M or N here.  If unsure, say Y.
+
 config BINFMT_FLAT
 	bool "Kernel support for flat binaries"
 	depends on !MMU && (!FRV || BROKEN)
diff -puN fs/Makefile~fs-make-binfmt-support-for-scripts-modular-and-removable fs/Makefile
--- a/fs/Makefile~fs-make-binfmt-support-for-scripts-modular-and-removable
+++ a/fs/Makefile
@@ -34,10 +34,7 @@ obj-$(CONFIG_COMPAT)		+= compat.o compat
 obj-$(CONFIG_BINFMT_AOUT)	+= binfmt_aout.o
 obj-$(CONFIG_BINFMT_EM86)	+= binfmt_em86.o
 obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
-
-# binfmt_script is always there
-obj-y				+= binfmt_script.o
