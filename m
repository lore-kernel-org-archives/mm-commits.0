From: akpm@linux-foundation.org
Subject: - kernel-doc-small-kernel-doc-optimization.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:28 -0700
Message-ID: <200705092150.l49LoSph002811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756567AbXEIVuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: small kernel-doc optimization
has been removed from the -mm tree.  Its filename was
     kernel-doc-small-kernel-doc-optimization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: small kernel-doc optimization
From: Borislav Petkov <bbpetkov@yahoo.de>

Get the kernel version string only once from the environment, thus slightly
speeding up kernel-doc.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-small-kernel-doc-optimization scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-small-kernel-doc-optimization
+++ a/scripts/kernel-doc
@@ -337,6 +337,7 @@ sub get_kernel_version() {
     }
     return $version;
 }
+my $kernelversion = get_kernel_version();
 
 # generate a sequence of code that will splice in highlighting information
 # using the s// operator.
@@ -610,7 +611,7 @@ sub output_function_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
+    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'function'}."</refname>\n";
@@ -687,7 +688,7 @@ sub output_struct_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
+    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
@@ -772,7 +773,7 @@ sub output_enum_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
+    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>enum ".$args{'enum'}."</refname>\n";
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
