From: akpm@linux-foundation.org
Subject: + scripts-replace-gawk-head-bc-with-shell-update.patch added to -mm tree
Date: Tue, 06 Feb 2007 14:59:42 -0800
Message-ID: <200702062259.l16Mxgsq031859@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54632 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030504AbXBFXFE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:05:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olecom@flower.upol.cz, azarah@nosferatu.za.org, sam@ravnborg.org, wstearns@pobox.com, zippel@linux-m68k.org


The patch titled
     scripts: replace gawk, head, bc with shell, update
has been added to the -mm tree.  Its filename is
     scripts-replace-gawk-head-bc-with-shell-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scripts: replace gawk, head, bc with shell, update
From: Oleg Verych <olecom@flower.upol.cz>

Replacing overhead of using some (external) programs instead of good old `sh'.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: William Stearns <wstearns@pobox.com>
Cc: Martin Schlemmer <azarah@nosferatu.za.org>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |   43 ++++++++++++++++----------------
 scripts/makelst               |   34 ++++++++++++-------------
 2 files changed, 39 insertions(+), 38 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~scripts-replace-gawk-head-bc-with-shell-update scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~scripts-replace-gawk-head-bc-with-shell-update
+++ a/scripts/gen_initramfs_list.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 # Copyright (C) Martin Schlemmer <azarah@nosferatu.za.org>
-# Copyright (c) 2006           Sam Ravnborg <sam@ravnborg.org>
+# Copyright (C) 2006 Sam Ravnborg <sam@ravnborg.org>
 #
 # Released under the terms of the GNU GPL
 #
@@ -17,15 +17,15 @@ cat << EOF
 Usage:
 $0 [-o <file>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} ...
 	-o <file>      Create gzipped initramfs file named <file> using
-	               gen_init_cpio and gzip
+		       gen_init_cpio and gzip
 	-u <uid>       User ID to map to user ID 0 (root).
-	               <uid> is only meaningful if <cpio_source>
-	               is a directory.
+		       <uid> is only meaningful if <cpio_source>
+		       is a directory.
 	-g <gid>       Group ID to map to group ID 0 (root).
-	               <gid> is only meaningful if <cpio_source>
-	               is a directory.
+		       <gid> is only meaningful if <cpio_source>
+		       is a directory.
 	<cpio_source>  File list or directory for cpio archive.
-	               If <cpio_source> is a .cpio file it will be used
+		       If <cpio_source> is a .cpio file it will be used
 		       as direct input to initramfs.
 	-d             Output the default cpio list.
 
@@ -36,6 +36,12 @@ to reset the root/group mapping.
 EOF
 }
 
+# awk style field access
+# $1 - field number; rest is argument string
+field() {
+	shift $1 ; echo $1
+}
+
 list_default_initramfs() {
 	# echo usr/kinit/kinit
 	:
@@ -119,22 +125,17 @@ parse() {
 			str="${ftype} ${name} ${location} ${str}"
 			;;
 		"nod")
-			local dev_type=
-			local maj=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{sub(/,/, "", $5); print $5}')
-			local min=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{print $6}')
-
-			if [ -b "${location}" ]; then
-				dev_type="b"
-			else
-				dev_type="c"
-			fi
-			str="${ftype} ${name} ${str} ${dev_type} ${maj} ${min}"
+			local dev=`LC_ALL=C ls -l "${location}"`
+			local maj=`field 5 ${dev}`
+			local min=`field 6 ${dev}`
+			maj=${maj%,}
+
+			[ -b "${location}" ] && dev="b" || dev="c"
+
+			str="${ftype} ${name} ${str} ${dev} ${maj} ${min}"
 			;;
 		"slink")
-			local target=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{print $11}')
+			local target=`field 11 $(LC_ALL=C ls -l "${location}")`
 			str="${ftype} ${name} ${target} ${str}"
 			;;
 		*)
diff -puN scripts/makelst~scripts-replace-gawk-head-bc-with-shell-update scripts/makelst
--- a/scripts/makelst~scripts-replace-gawk-head-bc-with-shell-update
+++ a/scripts/makelst
@@ -1,31 +1,31 @@
-#!/bin/bash
+#!/bin/sh
 # A script to dump mixed source code & assembly
 # with correct relocations from System.map
-# Requires the following lines in Rules.make.
-# Author(s): DJ Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com) 
-#            William Stearns <wstearns@pobox.com>
+# Requires the following lines in makefile:
 #%.lst: %.c
 #	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$@) -g -c -o $*.o $<
-#	$(TOPDIR)/scripts/makelst $*.o $(TOPDIR)/System.map $(OBJDUMP)
+#	$(srctree)/scripts/makelst $*.o $(objtree)/System.map $(OBJDUMP)
 #
-#    Copyright (C) 2000 IBM Corporation
-#    Author(s): DJ Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com) 
+# Copyright (C) 2000 IBM Corporation
+# Author(s): DJ Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com)
+#            William Stearns <wstearns@pobox.com>
 #
 
-t1=`$3 --syms $1 | grep .text | grep " F " | head -n 1`
+# awk style field access
+field() {
+  shift $1 ; echo $1
+}
+
+t1=`$3 --syms $1 | grep .text | grep -m1 " F "`
 if [ -n "$t1" ]; then
-  t2=`echo $t1 | gawk '{ print $6 }'`
+  t2=`field 6 $t1`
   if [ ! -r $2 ]; then
     echo "No System.map" >&2
-    t7=0
   else
     t3=`grep $t2 $2`
-    t4=`echo $t3 | gawk '{ print $1 }'`
-    t5=`echo $t1 | gawk '{ print $1 }'`
-    t6=`echo $t4 - $t5 | tr a-f A-F`
-    t7=`( echo  ibase=16 ; echo $t6 ) | bc`
+    t4=`field 1 $t3`
+    t5=`field 1 $t1`
+    t6=`printf "%lu" $((0x$t4 - 0x$t5))`
   fi
-else
-  t7=0
 fi
-$3 -r --source --adjust-vma=$t7 $1
+$3 -r --source --adjust-vma=${t6:-0} $1
_

Patches currently in -mm which might be from olecom@flower.upol.cz are

scripts-replace-gawk-head-bc-with-shell-update.patch
kbuild-improve-option-checking-kbuildinclude-cleanup.patch
kbuild-correctly-skip-tilded-backups-in-localversion-files.patch
deprecate-smbfs-in-favour-of-cifs-docs.patch
