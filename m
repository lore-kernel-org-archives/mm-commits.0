From: akpm@linux-foundation.org
Subject: - doc-oops-tracing-add-code-decode-info-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 15:00:39 -0700
Message-ID: <200707092200.l69M0duK014890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756696AbXGIWAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 18:00:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, argggh@dolphinics.no, mm-commits@vger.kernel.org


The patch titled
     scripts/decodecode: fix for /bin/sh
has been removed from the -mm tree.  Its filename was
     doc-oops-tracing-add-code-decode-info-fix.patch

This patch was dropped because it was folded into doc-oops-tracing-add-code-decode-info.patch

------------------------------------------------------
Subject: scripts/decodecode: fix for /bin/sh
From: Randy Dunlap <randy.dunlap@oracle.com>

Convert substring expressions to be sh-compatible.

Tested by Arne Georg Gleditsch <argggh@dolphinics.no>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/decodecode~doc-oops-tracing-add-code-decode-info-fix scripts/decodecode
--- a/scripts/decodecode~doc-oops-tracing-add-code-decode-info-fix
+++ a/scripts/decodecode
@@ -28,7 +28,7 @@ if [ $marker -eq 0 ]; then
 fi
 
 if [ $marker -ne 0 ]; then
-	beforemark=${code:0:$((marker - 1))}
+	beforemark=`echo "$code" | cut -c-$((${marker} - 1))`
 	echo -n "	.byte 0x" > $T.s
 	echo $beforemark | sed -e 's/ /,0x/g' >> $T.s
 	as -o $T.o $T.s
@@ -36,7 +36,7 @@ if [ $marker -ne 0 ]; then
 	rm $T.o $T.s
 
 # and fix code at-and-after marker
-	code=${code:$marker}
+	code=`echo "$code" | cut -c$((${marker} + 1))-`
 fi
 
 code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g'`
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
doc-oops-tracing-add-code-decode-info-fix.patch
doc-oops-tracing-add-code-decode-info-fix-scripts-decodecode-add-aflags.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
