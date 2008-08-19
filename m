From: akpm@linux-foundation.org
Subject: - kernel-doc-allow-space-in-macro-define.patch removed from -mm tree
Date: Tue, 19 Aug 2008 15:40:24 -0700
Message-ID: <200808192240.m7JMeOQQ010645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbYHSWkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 18:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: allow space in macro #define
has been removed from the -mm tree.  Its filename was
     kernel-doc-allow-space-in-macro-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: allow space in macro #define
From: Randy Dunlap <randy.dunlap@oracle.com>

Allow macros that are annotated with kernel-doc to contain whitespace
between the '#' and "define".  It's valid and being used, so allow it.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-allow-space-in-macro-define scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-allow-space-in-macro-define
+++ a/scripts/kernel-doc
@@ -1644,7 +1644,7 @@ sub dump_function($$) {
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
     $prototype =~ s/__init +//;
-    $prototype =~ s/^#define\s+//; #ak added
+    $prototype =~ s/^#\s*define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
     # Yes, this truly is vile.  We are looking for:
@@ -1760,13 +1760,13 @@ sub process_state3_function($$) {
 
     $x =~ s@\/\/.*$@@gos; # strip C99-style comments to end of line
 
-    if ($x =~ m#\s*/\*\s+MACDOC\s*#io || ($x =~ /^#/ && $x !~ /^#define/)) {
+    if ($x =~ m#\s*/\*\s+MACDOC\s*#io || ($x =~ /^#/ && $x !~ /^#\s*define/)) {
 	# do nothing
     }
     elsif ($x =~ /([^\{]*)/) {
 	$prototype .= $1;
     }
-    if (($x =~ /\{/) || ($x =~ /\#define/) || ($x =~ /;/)) {
+    if (($x =~ /\{/) || ($x =~ /\#\s*define/) || ($x =~ /;/)) {
 	$prototype =~ s@/\*.*?\*/@@gos;	# strip comments.
 	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/cr's.
 	$prototype =~ s@^\s+@@gos; # strip leading spaces
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

documentation-describe-bootmem_debug-kernel-parameter.patch
linux-next.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

