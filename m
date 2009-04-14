From: akpm@linux-foundation.org
Subject: [merged] kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:46 -0700
Message-ID: <200904141950.n3EJokUK020355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172AbZDNTxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: make it possible for the linker to discard local symbols from vmlinux
has been removed from the -mm tree.  Its filename was
     kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: make it possible for the linker to discard local symbols from vmlinux
From: David Howells <dhowells@redhat.com>

Make it possible for the linker to discard local symbols from vmlinux as
they cause vmlinux to balloon when CONFIG_KALLSYMS=y and they cause
dump_stack() and get_wchan() to produce useless information under some
circumstances.

With this we add a config option (CONFIG_STRIP_ASM_SYMS) that will cause
the build to supply -X to the linker to tell it to strip temporary local
symbols.

This doesn't seem to cause gdb any problems.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile     |    4 ++++
 init/Kconfig |    8 ++++++++
 2 files changed, 12 insertions(+)

diff -puN Makefile~kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux Makefile
--- a/Makefile~kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux
+++ a/Makefile
@@ -591,6 +591,10 @@ LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma
 LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
 LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
 
+ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
+LDFLAGS_vmlinux	+= -X
+endif
+
 # Default kernel image to build when no specific target is given.
 # KBUILD_IMAGE may be overruled on the command line or
 # set in the environment
diff -puN init/Kconfig~kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux init/Kconfig
--- a/init/Kconfig~kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux
+++ a/init/Kconfig
@@ -740,6 +740,14 @@ config KALLSYMS_EXTRA_PASS
 	   you wait for kallsyms to be fixed.
 
 
+config STRIP_ASM_SYMS
+	bool "Strip assembler-generated symbols during link"
+	default n
+	help
+	  Strip internal assembler-generated symbols during a link (symbols
+	  that look like '.Lxxx') so they don't pollute the output of
+	  get_wchan() and suchlike.
+
 config HOTPLUG
 	bool "Support for hot-pluggable devices" if EMBEDDED
 	default y
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-duplicate-output_buffer-of-e03.patch
flat-fix-data-sections-alignment.patch
mutex-subsystem-synchro-test-module.patch

