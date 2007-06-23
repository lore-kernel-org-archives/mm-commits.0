From: akpm@linux-foundation.org
Subject: + doc-oops-tracing-add-code-decode-info.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:53:29 -0700
Message-ID: <200706231653.l5NGrQ1q019682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755410AbXFWQ50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ak@suse.de


The patch titled
     doc/oops-tracing: add Code: decode info
has been added to the -mm tree.  Its filename is
     doc-oops-tracing-add-code-decode-info.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: doc/oops-tracing: add Code: decode info
From: Randy Dunlap <randy.dunlap@oracle.com>

Add info that the Code: bytes line contains <xy> or (wxyz) in some
architecture oops reports and what that means.

Add a script by Andi Kleen that reads the Code: line from an Oops report
file and generates assembly code from the hex bytes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt |   14 +++++++++
 scripts/decodecode             |   47 +++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff -puN Documentation/oops-tracing.txt~doc-oops-tracing-add-code-decode-info Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~doc-oops-tracing-add-code-decode-info
+++ a/Documentation/oops-tracing.txt
@@ -86,6 +86,20 @@ stuff are the values reported by the Oop
 and do a replace of spaces to "\x" - that's what I do, as I'm too lazy 
 to write a program to automate this all).
 
+Alternatively, you can use the shell script in scripts/decodecode.
+Its usage is:  decodecode < oops.txt
+
+The hex bytes that follow "Code:" may (in some architectures) have a series
+of bytes that precede the current instruction pointer as well as bytes at and
+following the current instruction pointer.  In some cases, one instruction
+byte or word is surrounded by <> or (), as in "<86>" or "(f00d)".  These
+<> or () markings indicate the current instruction pointer.  Example from
+i386, split into multiple lines for readability:
+
+Code: f9 0f 8d f9 00 00 00 8d 42 0c e8 dd 26 11 c7 a1 60 ea 2b f9 8b 50 08 a1
+64 ea 2b f9 8d 34 82 8b 1e 85 db 74 6d 8b 15 60 ea 2b f9 <8b> 43 04 39 42 54
+7e 04 40 89 42 54 8b 43 04 3b 05 00 f6 52 c0
+
 Finally, if you want to see where the code comes from, you can do
 
 	cd /usr/src/linux
diff -puN /dev/null scripts/decodecode
--- /dev/null
+++ a/scripts/decodecode
@@ -0,0 +1,47 @@
+#!/bin/sh
+# Disassemble the Code: line in Linux oopses
+# usage: decodecode < oops.file
+
+T=`mktemp`
+code=
+
+while read i ; do
+
+case "$i" in
+*Code:*)
+	code=$i
+	;;
+esac
+
+done
+
+if [ -z "$code" ]; then
+	exit
+fi
+
+echo $code
+code=`echo $code | sed -e 's/.*Code: //'`
+
+marker=`expr index "$code" "\<"`
+if [ $marker -eq 0 ]; then
+	marker=`expr index "$code" "\("`
+fi
+
+if [ $marker -ne 0 ]; then
+	beforemark=${code:0:$((marker - 1))}
+	echo -n "	.byte 0x" > $T.s
+	echo $beforemark | sed -e 's/ /,0x/g' >> $T.s
+	as -o $T.o $T.s
+	objdump -S $T.o
+	rm $T.o $T.s
+
+# and fix code at-and-after marker
+	code=${code:$marker}
+fi
+
+code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g'`
+echo -n "	.byte 0x" > $T.s
+echo $code >> $T.s
+as -o $T.o $T.s
+objdump -S $T.o
+rm $T.o $T.s
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
x86_64-use-null-for-pointer.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
doc-oops-tracing-add-code-decode-info.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
