From: akpm@linux-foundation.org
Subject: - doc-oops-tracing-add-code-decode-info-fix-scripts-decodecode-add-aflags.patch removed from -mm tree
Date: Mon, 09 Jul 2007 15:00:42 -0700
Message-ID: <200707092200.l69M0gOC014895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756620AbXGIWAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 18:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     scripts/decodecode: add AFLAGS
has been removed from the -mm tree.  Its filename was
     doc-oops-tracing-add-code-decode-info-fix-scripts-decodecode-add-aflags.patch

This patch was dropped because it was folded into doc-oops-tracing-add-code-decode-info.patch

------------------------------------------------------
Subject: scripts/decodecode: add AFLAGS
From: Randy Dunlap <randy.dunlap@oracle.com>

Add AFLAGS=options environment variable for the 'as' command.  This enables
us to generate code for something other than the host system architecture. 
E.g., on an x86_64 system:

AFLAGS=--32 scripts/decodecode < i386.oops
generates code for i386 (and then objdump uses the object file's
arch. to disassemble it).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN scripts/decodecode~doc-oops-tracing-add-code-decode-info-fix-scripts-decodecode-add-aflags scripts/decodecode
--- a/scripts/decodecode~doc-oops-tracing-add-code-decode-info-fix-scripts-decodecode-add-aflags
+++ a/scripts/decodecode
@@ -1,6 +1,10 @@
 #!/bin/sh
 # Disassemble the Code: line in Linux oopses
 # usage: decodecode < oops.file
+#
+# options: set env. variable AFLAGS=options to pass options to "as";
+# e.g., to decode an i386 oops on an x86_64 system, use:
+# AFLAGS=--32 decodecode < 386.oops
 
 T=`mktemp`
 code=
@@ -31,7 +35,7 @@ if [ $marker -ne 0 ]; then
 	beforemark=`echo "$code" | cut -c-$((${marker} - 1))`
 	echo -n "	.byte 0x" > $T.s
 	echo $beforemark | sed -e 's/ /,0x/g' >> $T.s
-	as -o $T.o $T.s
+	as $AFLAGS -o $T.o $T.s
 	objdump -S $T.o
 	rm $T.o $T.s
 
@@ -42,6 +46,6 @@ fi
 code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g'`
 echo -n "	.byte 0x" > $T.s
 echo $code >> $T.s
-as -o $T.o $T.s
+as $AFLAGS -o $T.o $T.s
 objdump -S $T.o
 rm $T.o $T.s
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-alsa.patch
git-mtd.patch
romfs-printk-format-warnings.patch
ubi-one-less-bug-usage.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
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
doc-oops-tracing-add-code-decode-info-fix-scripts-decodecode-add-aflags.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
