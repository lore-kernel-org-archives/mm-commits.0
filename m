From: akpm@linux-foundation.org
Subject: + docsrc-build-documentation-sources.patch added to -mm tree
Date: Wed, 30 Jul 2008 00:20:33 -0700
Message-ID: <200807300720.m6U7KXih013597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758960AbYG3HWE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 03:22:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     docsrc: build Documentation/ sources
has been added to the -mm tree.  Its filename is
     docsrc-build-documentation-sources.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docsrc: build Documentation/ sources
From: Randy Dunlap <randy.dunlap@oracle.com>

Currently source files in the Documentation/ sub-dir can easily bit-rot
since they are not generally buildable, either because they are hidden in
text files or because there are no Makefile rules for them.  This needs to
be fixed so that the source files remain usable and good examples of code
instead of bad examples.

Add the ability to build source files that are in the Documentation/ dir. 
Add to Kconfig as "BUILD_DOCSRC" config symbol.

Use "CONFIG_BUILD_DOCSRC=1 make ..." to build objects from the
Documentation/ sources.  Or enable BUILD_DOCSRC in the *config system. 
However, this symbol depends on HEADERS_CHECK since the header files need
to be installed (for userspace builds).

Built (using cross-tools) for x86-64, i386, alpha, ia64, sparc32,
sparc64, powerpc, sh, m68k, & mips.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile              |    7 +++++++
 Documentation/Makefile                      |    3 +++
 Documentation/accounting/Makefile           |   10 ++++++++++
 Documentation/auxdisplay/Makefile           |   10 ++++++++++
 Documentation/connector/Makefile            |   11 +++++++++++
 Documentation/filesystems/configfs/Makefile |    3 +++
 Documentation/ia64/Makefile                 |    8 ++++++++
 Documentation/networking/Makefile           |    8 ++++++++
 Documentation/pcmcia/Makefile               |   10 ++++++++++
 Documentation/spi/Makefile                  |   11 +++++++++++
 Documentation/video4linux/Makefile          |    8 ++++++++
 Documentation/vm/Makefile                   |    8 ++++++++
 Documentation/watchdog/src/Makefile         |    8 ++++++++
 Makefile                                    |    5 ++++-
 lib/Kconfig.debug                           |    9 +++++++++
 15 files changed, 118 insertions(+), 1 deletion(-)

diff -puN Documentation/DocBook/Makefile~docsrc-build-documentation-sources Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~docsrc-build-documentation-sources
+++ a/Documentation/DocBook/Makefile
@@ -102,6 +102,13 @@ C-procfs-example = procfs_example.xml
 C-procfs-example2 = $(addprefix $(obj)/,$(C-procfs-example))
 $(obj)/procfs-guide.xml: $(C-procfs-example2)
 
+# List of programs to build
+##oops, this is a kernel module::hostprogs-y := procfs_example
+obj-m += procfs_example.o
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
 notfoundtemplate = echo "*** You have to install docbook-utils or xmlto ***"; \
 		   exit 1
 db2xtemplate = db2TYPE -o $(dir $@) $<
diff -puN /dev/null Documentation/Makefile
--- /dev/null
+++ a/Documentation/Makefile
@@ -0,0 +1,3 @@
+obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
+	filesystems/configfs/ ia64/ networking/ \
+	pcmcia/ spi/ video4linux/ vm/ watchdog/src/
diff -puN /dev/null Documentation/accounting/Makefile
--- /dev/null
+++ a/Documentation/accounting/Makefile
@@ -0,0 +1,10 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := getdelays
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_getdelays.o += -I$(objtree)/usr/include
diff -puN /dev/null Documentation/auxdisplay/Makefile
--- /dev/null
+++ a/Documentation/auxdisplay/Makefile
@@ -0,0 +1,10 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := cfag12864b-example
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_cfag12864b-example.o += -I$(objtree)/usr/include
diff -puN /dev/null Documentation/connector/Makefile
--- /dev/null
+++ a/Documentation/connector/Makefile
@@ -0,0 +1,11 @@
+ifneq ($(CONFIG_CONNECTOR),)
+obj-m += cn_test.o
+endif
+
+# List of programs to build
+hostprogs-y := ucon
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_ucon.o += -I$(objtree)/usr/include
diff -puN /dev/null Documentation/filesystems/configfs/Makefile
--- /dev/null
+++ a/Documentation/filesystems/configfs/Makefile
@@ -0,0 +1,3 @@
+ifneq ($(CONFIG_CONFIGFS_FS),)
+obj-m += configfs_example_explicit.o configfs_example_macros.o
+endif
diff -puN /dev/null Documentation/ia64/Makefile
--- /dev/null
+++ a/Documentation/ia64/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := aliasing-test
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
diff -puN /dev/null Documentation/networking/Makefile
--- /dev/null
+++ a/Documentation/networking/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := ifenslave
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
diff -puN /dev/null Documentation/pcmcia/Makefile
--- /dev/null
+++ a/Documentation/pcmcia/Makefile
@@ -0,0 +1,10 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := crc32hash
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_crc32hash.o += -I$(objtree)/usr/include
diff -puN /dev/null Documentation/spi/Makefile
--- /dev/null
+++ a/Documentation/spi/Makefile
@@ -0,0 +1,11 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := spidev_test spidev_fdx
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_spidev_test.o += -I$(objtree)/usr/include
+HOSTCFLAGS_spidev_fdx.o += -I$(objtree)/usr/include
diff -puN /dev/null Documentation/video4linux/Makefile
--- /dev/null
+++ a/Documentation/video4linux/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := v4lgrab
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
diff -puN /dev/null Documentation/vm/Makefile
--- /dev/null
+++ a/Documentation/vm/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := slabinfo
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
diff -puN /dev/null Documentation/watchdog/src/Makefile
--- /dev/null
+++ a/Documentation/watchdog/src/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := watchdog-simple watchdog-test
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
diff -puN Makefile~docsrc-build-documentation-sources Makefile
--- a/Makefile~docsrc-build-documentation-sources
+++ a/Makefile
@@ -821,6 +821,9 @@ endif
 ifdef CONFIG_SAMPLES
 	$(Q)$(MAKE) $(build)=samples
 endif
+ifdef CONFIG_BUILD_DOCSRC
+	$(Q)$(MAKE) $(build)=Documentation
+endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
@@ -1165,7 +1168,7 @@ MRPROPER_FILES += .config .config.old in
 #
 clean: rm-dirs  := $(CLEAN_DIRS)
 clean: rm-files := $(CLEAN_FILES)
-clean-dirs      := $(addprefix _clean_,$(srctree) $(vmlinux-alldirs))
+clean-dirs      := $(addprefix _clean_,$(srctree) $(vmlinux-alldirs) Documentation)
 
 PHONY += $(clean-dirs) clean archclean
 $(clean-dirs):
diff -puN lib/Kconfig.debug~docsrc-build-documentation-sources lib/Kconfig.debug
--- a/lib/Kconfig.debug~docsrc-build-documentation-sources
+++ a/lib/Kconfig.debug
@@ -644,6 +644,15 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
 	  If unsure, say N.
 
+menuconfig BUILD_DOCSRC
+	bool "Build targets in Documentation/ tree"
+	depends on HEADERS_CHECK
+	help
+	  This option attempts to build objects from the source files in the
+	  kernel Documentation/ tree.
+
+	  Say N if you are unsure.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
v4l-fix-kernel-doc-warning-function-name-and-docbook-filename.patch
genksyms-parser-fix-the-__attribute__-rule.patch
genksyms-include-extern-information-in-dumps.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works-comment.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

