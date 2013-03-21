From: akpm@linux-foundation.org
Subject: + fs-make-binfmt-support-for-scripts-modular-and-removable.patch added to -mm tree
Date: Thu, 21 Mar 2013 12:40:51 -0700
Message-ID: <20130321194051.724D15A4232@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36665 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3CUTkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 15:40:52 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so294702vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 12:40:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@joshtriplett.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs: make binfmt support for #! scripts modular and removable
has been added to the -mm tree.  Its filename is
     fs-make-binfmt-support-for-scripts-modular-and-removable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
