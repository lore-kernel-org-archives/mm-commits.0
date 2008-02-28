From: akpm@linux-foundation.org
Subject: + kernel-doc-set-verbose-mode-via-environment.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:11:09 -0800
Message-ID: <200802280311.m1S3B98I012796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbYB1DMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:12:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     kernel-doc: set verbose mode via environment
has been added to the -mm tree.  Its filename is
     kernel-doc-set-verbose-mode-via-environment.patch

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
