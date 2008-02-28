From: akpm@linux-foundation.org
Subject: - kernel-doc-set-verbose-mode-via-environment.patch removed from -mm tree
Date: Thu, 28 Feb 2008 10:42:53 -0800
Message-ID: <200802281842.m1SIgrTI014375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbYB1Sni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 13:43:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: set verbose mode via environment
has been removed from the -mm tree.  Its filename was
     kernel-doc-set-verbose-mode-via-environment.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: set verbose mode via environment
From: Randy Dunlap <randy.dunlap@oracle.com>

Allow setting environment variable "KERNEL_DOC_VERBOSE=1" to enable verbose
mode in scripts/kernel-doc.  Useful for getting more info and warnings from
kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN scripts/kernel-doc~kernel-doc-set-verbose-mode-via-environment scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-set-verbose-mode-via-environment
+++ a/scripts/kernel-doc
@@ -247,6 +247,10 @@ my ($function, %function_table,%paramete
 my ($type,$declaration_name,$return_type);
 my ($newsection,$newcontents,$prototype,$filelist, $brcount, %source_map);
 
+if (defined($ENV{'KERNEL_DOC_VERBOSE'})) {
+	$verbose = "$ENV{'KERNEL_DOC_VERBOSE'}";
+}
+
 # Generated docbook code is inserted in a template at a point where
 # docbook v3.1 requires a non-zero sequence of RefEntry's; see:
 # http://www.oasis-open.org/docbook/documentation/reference/html/refentry.html
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
kprobes-move-kprobe-examples-to-samples.patch
x86-visws-fix-printk-format-warnings.patch
apanel-fix-kconfig-dependencies.patch
let-log_buf_shift-default-to-17.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
kernel-doc-set-verbose-mode-via-environment.patch
profile-likely-unlikely-macros.patch

