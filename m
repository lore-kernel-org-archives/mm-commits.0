From: akpm@linux-foundation.org
Subject: - kernel-doc-allow-more-whitespace.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:53:38 -0800
Message-ID: <200702112253.l1BMrcP0016113@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60405 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932832AbXBKWxw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:53:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: allow more whitespace
has been removed from the -mm tree.  Its filename was
     kernel-doc-allow-more-whitespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: allow more whitespace
From: Randy Dunlap <randy.dunlap@oracle.com>

Allow whitespace in pointer-to-function
	[accept "(* done)", not just "(*done)"].

Allow tabs (spaces are already allowed) between "#define" and a macro name.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
git-drm.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
ueagle-atmc-needs-schedh.patch
com20020-build-fix.patch
drivers-telephony-ixj-convert-to-generic-boolean.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
