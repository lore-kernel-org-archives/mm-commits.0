From: akpm@linux-foundation.org
Subject: + kernel-doc-warn-on-badly-formatted-short-description.patch added to -mm tree
Date: Wed, 30 Jan 2008 17:00:25 -0800
Message-ID: <200801310100.m0V10Q1O001197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785AbYAaBB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 20:01:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: warn on badly formatted short description
has been added to the -mm tree.  Its filename is
     kernel-doc-warn-on-badly-formatted-short-description.patch

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
git-alsa.patch
docbook-fix-drivers-base-class-warning.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
profile-likely-unlikely-macros.patch
