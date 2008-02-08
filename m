From: akpm@linux-foundation.org
Subject: - kernel-doc-warn-on-badly-formatted-short-description.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:36 -0800
Message-ID: <200802080802.m1882HNP014025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60247 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761506AbYBHIUL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: warn on badly formatted short description
has been removed from the -mm tree.  Its filename was
     kernel-doc-warn-on-badly-formatted-short-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: warn on badly formatted short description
From: Randy Dunlap <randy.dunlap@oracle.com>

Make kernel-doc warn when a function/struct/union/typedef does not contain
a properly formatted short description, such as:
 * scsi_devinfo: set up the dynamic device list
or
 * scsi_devinfo -

This warning is only generated when verbose (-v) mode is used.

Also explain the -v command line option in the -h output.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/kernel-doc~kernel-doc-warn-on-badly-formatted-short-description scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-warn-on-badly-formatted-short-description
+++ a/scripts/kernel-doc
@@ -218,6 +218,7 @@ sub usage {
     print "         [ -function funcname [ -function funcname ...] ]\n";
     print "         [ -nofunction funcname [ -nofunction funcname ...] ]\n";
     print "         c source file(s) > outputfile\n";
+    print "         -v : verbose output, more warnings & other info listed\n";
     exit 1;
 }
 
@@ -1881,6 +1882,13 @@ sub process_file($) {
 		} else {
 		    $declaration_purpose = "";
 		}
+
+		if (($declaration_purpose eq "") && $verbose) {
+			print STDERR "Warning(${file}:$.): missing initial short description on line:\n";
+			print STDERR $_;
+			++$warnings;
+		}
+
 		if ($identifier =~ m/^struct/) {
 		    $decl_type = 'struct';
 		} elsif ($identifier =~ m/^union/) {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
