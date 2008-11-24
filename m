From: akpm@linux-foundation.org
Subject: + kernel-doc-handle-varargs-cleanly.patch added to -mm tree
Date: Mon, 24 Nov 2008 13:25:02 -0800
Message-ID: <200811242125.mAOLP2pU024384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbYKXVZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 16:25:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: handle varargs cleanly
has been added to the -mm tree.  Its filename is
     kernel-doc-handle-varargs-cleanly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: handle varargs cleanly
From: Randy Dunlap <randy.dunlap@oracle.com>

The method for listing varargs in kernel-doc notation is:
 * @...: these arguments are printed by the @fmt argument

but scripts/kernel-doc is confused:  it always lists varargs as:
	...	variable arguments
and ignores the @...: line's description, but then prints that
line after the list of function parameters as though it's
not part of the function parameters.

This patch makes kernel-doc print the supplied @...  description if it is
present; otherwise a boilerplate "variable arguments" is printed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-handle-varargs-cleanly scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-handle-varargs-cleanly
+++ a/scripts/kernel-doc
@@ -378,6 +378,10 @@ sub dump_section {
 #	print STDERR "parameter def '$1' = '$contents'\n";
 	$name = $1;
 	$parameterdescs{$name} = $contents;
+    } elsif ($name eq "@\.\.\.") {
+#	print STDERR "parameter def '...' = '$contents'\n";
+	$name = "...";
+	$parameterdescs{$name} = $contents;
     } else {
 #	print STDERR "other section '$name' = '$contents'\n";
 	if (defined($sections{$name}) && ($sections{$name} ne "")) {
@@ -1588,12 +1592,12 @@ sub push_parameter($$$) {
 
 	if ($type eq "" && $param =~ /\.\.\.$/)
 	{
-	    $type="";
-	    $parameterdescs{$param} = "variable arguments";
+	    if (!defined $parameterdescs{$param} || $parameterdescs{$param} eq "") {
+		$parameterdescs{$param} = "variable arguments";
+	    }
 	}
 	elsif ($type eq "" && ($param eq "" or $param eq "void"))
 	{
-	    $type="";
 	    $param="void";
 	    $parameterdescs{void} = "no arguments";
 	}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
scripts-extract-ikconfig-remove-bashisms.patch
drivers-ata-pata_radisysc-cleanup-kernel-doc.patch
drivers-ata-libata-corec-cleanup-kernel-doc.patch
drivers-ata-pata_oldpiixc-cleanup-kernel-doc.patch
drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch
drivers-ata-pata_legacyc-cleanup-kernel-doc.patch
drivers-ata-pata_sisc-cleanup-kernel-doc.patch
drivers-ata-pata_c-the-rest-remove-redundant-comments.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
kernel-doc-handle-varargs-cleanly.patch
irqh-fix-missing-extra-kernel-doc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
profile-likely-unlikely-macros.patch

