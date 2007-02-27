From: akpm@linux-foundation.org
Subject: + allow-kernel-to-build-on-cygwin.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:37:05 -0800
Message-ID: <200702272037.l1RKb9Dt027624@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50779 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090AbXB0Uh1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:37:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsaxena@plexity.net, dsaxena@mvista.com, sam@ravnborg.org


The patch titled
     Allow kernel to build on Cygwin
has been added to the -mm tree.  Its filename is
     allow-kernel-to-build-on-cygwin.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow kernel to build on Cygwin
From: Deepak Saxena <dsaxena@plexity.net>

This patch contains a set of small fixes to allow the kernel to build under
the Cygwin environment, which is unfortunately used by more people than
one would think in the embedded world. :(

Signed-off-by: Deepak Saxena <dsaxena@mvista.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/gen_crc32table.c                       |    2 ++
 scripts/kconfig/Makefile                   |    6 ++++++
 scripts/kconfig/lxdialog/check-lxdialog.sh |    4 ++++
 scripts/mod/file2alias.c                   |    4 ++++
 scripts/mod/mk_elfconfig.c                 |    4 ++++
 scripts/mod/modpost.h                      |    4 ++++
 scripts/mod/sumversion.c                   |    6 +++++-
 7 files changed, 29 insertions(+), 1 deletion(-)

diff -puN lib/gen_crc32table.c~allow-kernel-to-build-on-cygwin lib/gen_crc32table.c
--- a/lib/gen_crc32table.c~allow-kernel-to-build-on-cygwin
+++ a/lib/gen_crc32table.c
@@ -1,6 +1,8 @@
 #include <stdio.h>
 #include "crc32defs.h"
+#ifndef __CYGWIN__
 #include <inttypes.h>
+#endif
 
 #define ENTRIES_PER_LINE 4
 
diff -puN scripts/kconfig/Makefile~allow-kernel-to-build-on-cygwin scripts/kconfig/Makefile
--- a/scripts/kconfig/Makefile~allow-kernel-to-build-on-cygwin
+++ a/scripts/kconfig/Makefile
@@ -161,6 +161,12 @@ HOSTLOADLIBES_gconf	= `pkg-config --libs
 HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
                           -D LKC_DIRECT_LINK
 
+HOST_OS := $(shell uname -o)
+ifeq ($(HOST_OS),Cygwin)
+HOSTLOADLIBES_mconf	= -lintl
+HOSTLOADLIBES_conf	= -lintl
+endif
+
 $(obj)/qconf.o: $(obj)/.tmp_qtcheck
 
 ifeq ($(qconf-target),1)
diff -puN scripts/kconfig/lxdialog/check-lxdialog.sh~allow-kernel-to-build-on-cygwin scripts/kconfig/lxdialog/check-lxdialog.sh
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh~allow-kernel-to-build-on-cygwin
+++ a/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -4,6 +4,10 @@
 # What library to link
 ldflags()
 {
+	if [ "`uname -o`" == "Cygwin" ]; then
+		echo '-lintl -lncurses'
+		exit
+	fi
 	$cc -print-file-name=libncursesw.so | grep -q /
 	if [ $? -eq 0 ]; then
 		echo '-lncursesw'
diff -puN scripts/mod/file2alias.c~allow-kernel-to-build-on-cygwin scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~allow-kernel-to-build-on-cygwin
+++ a/scripts/mod/file2alias.c
@@ -29,7 +29,11 @@ typedef Elf64_Addr	kernel_ulong_t;
 
 #include <ctype.h>
 
+#if defined(__CYGWIN__)
+typedef __uint32_t	__u32;
+#else
 typedef uint32_t	__u32;
+#endif
 typedef uint16_t	__u16;
 typedef unsigned char	__u8;
 
diff -puN scripts/mod/mk_elfconfig.c~allow-kernel-to-build-on-cygwin scripts/mod/mk_elfconfig.c
--- a/scripts/mod/mk_elfconfig.c~allow-kernel-to-build-on-cygwin
+++ a/scripts/mod/mk_elfconfig.c
@@ -1,7 +1,11 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#ifdef __CYGWIN__
+#include <libelf.h>
+#else
 #include <elf.h>
+#endif
 
 int
 main(int argc, char **argv)
diff -puN scripts/mod/modpost.h~allow-kernel-to-build-on-cygwin scripts/mod/modpost.h
--- a/scripts/mod/modpost.h~allow-kernel-to-build-on-cygwin
+++ a/scripts/mod/modpost.h
@@ -7,7 +7,11 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include <unistd.h>
+#ifdef __CYGWIN__
+#include <libelf.h>
+#else
 #include <elf.h>
+#endif
 
 #include "elfconfig.h"
 
diff -puN scripts/mod/sumversion.c~allow-kernel-to-build-on-cygwin scripts/mod/sumversion.c
--- a/scripts/mod/sumversion.c~allow-kernel-to-build-on-cygwin
+++ a/scripts/mod/sumversion.c
@@ -1,7 +1,11 @@
+#if defined(__sun__)
 #include <netinet/in.h>
-#ifdef __sun__
 #include <inttypes.h>
+#elif defined(__CYGWIN__)
+#include <asm/byteorder.h>	/* For ntohl/htonl */
+#include <limits.h>
 #else
+#include <netinet/in.h>
 #include <stdint.h>
 #endif
 #include <ctype.h>
_

Patches currently in -mm which might be from dsaxena@plexity.net are

allow-kernel-to-build-on-cygwin.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
