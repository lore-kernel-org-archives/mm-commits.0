From: akpm@osdl.org
Subject: + kernel-doc-allow-more-whitespace.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:54:25 -0800
Message-ID: <200701082254.l08MsPPx021619@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51068 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030257AbXAHWy6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:54:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: allow more whitespace
has been added to the -mm tree.  Its filename is
     kernel-doc-allow-more-whitespace.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: allow more whitespace
From: Randy Dunlap <randy.dunlap@oracle.com>

Allow whitespace in pointer-to-function
	[accept "(* done)", not just "(*done)"].

Allow tabs (spaces are already allowed) between "#define" and a macro name.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kernel-doc |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-allow-more-whitespace scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-allow-more-whitespace
+++ a/scripts/kernel-doc
@@ -1433,7 +1433,7 @@ sub create_parameterlist($$$) {
 	} elsif ($arg =~ m/\(.*\*/) {
 	    # pointer-to-function
 	    $arg =~ tr/#/,/;
-	    $arg =~ m/[^\(]+\(\*([^\)]+)\)/;
+	    $arg =~ m/[^\(]+\(\*\s*([^\)]+)\)/;
 	    $param = $1;
 	    $type = $arg;
 	    $type =~ s/([^\(]+\(\*)$param/$1/;
@@ -1536,7 +1536,7 @@ sub dump_function($$) {
     $prototype =~ s/^__always_inline +//;
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
-    $prototype =~ s/^#define +//; #ak added
+    $prototype =~ s/^#define\s+//; #ak added
     $prototype =~ s/__attribute__ \(\([a-z,]*\)\)//;
 
     # Yes, this truly is vile.  We are looking for:
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-alsa.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-rc-fixes.patch
megaraid-fix-kernel-doc.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-showblockedtasks-is-sysrq-w.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch
