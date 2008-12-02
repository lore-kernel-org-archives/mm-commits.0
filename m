From: akpm@linux-foundation.org
Subject: - kernel-doc-handle-varargs-cleanly.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:59 -0800
Message-ID: <200812021838.mB2Icx4C007252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbYLBSjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:39:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: handle varargs cleanly
has been removed from the -mm tree.  Its filename was
     kernel-doc-handle-varargs-cleanly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
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
document-hadling-of-bad-memory.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
fix-similar-typos-to-successfull-v2.patch

