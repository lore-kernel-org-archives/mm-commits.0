From: akpm@linux-foundation.org
Subject: + kill-warnings-when-building-mandocs.patch added to -mm tree
Date: Sun, 22 Apr 2007 12:07:51 -0700
Message-ID: <200704221907.l3MJ7pT8032176@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030241AbXDVTHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 15:07:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de, rdunlap@xenotime.net


The patch titled
     kill warnings when building mandocs
has been added to the -mm tree.  Its filename is
     kill-warnings-when-building-mandocs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kill warnings when building mandocs
From: Borislav Petkov <bbpetkov@yahoo.de>

This patch shuts warnings of the sort:

make -C /mnt/samsung_200/sam/kernel/trees/21-rc6/build \
	KBUILD_SRC=/mnt/samsung_200/sam/kernel/trees/21-rc6 \
	KBUILD_EXTMOD="" -f /mnt/samsung_200/sam/kernel/trees/21-rc6/Makefile mandocs
make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=scripts/basic
make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=Documentation/DocBook mandocs
  SRCTREE=/mnt/samsung_200/sam/kernel/trees/21-rc6/ /mnt/samsung_200/sam/kernel/trees/21-rc6/build/scripts/basic/docproc doc /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/wanbook.tmpl >Documentation/DocBook/wanbook.xml
  if grep -q refentry Documentation/DocBook/wanbook.xml; then xmlto man -m /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/man Documentation/DocBook/wanbook.xml ; gzip -f Documentation/DocBook/man/*.9; fi
Note: meta version: No productnumber or alternative     sppp_close
Note: meta version: No refmiscinfo@class=version        sppp_close
Note: Writing sppp_close.9
Note: meta version: No productnumber or alternative     sppp_open
Note: meta version: No refmiscinfo@class=version        sppp_open

by adding a RefMiscInfo xml tag in the form of the current kernel version
to the function, struct and enum definitions in files included by
kernel-doc when building 'mandocs'.  However, the version string appears
truncated on the manpage due to some constraints in the xml DTD for the man
header, I believe, for the troff output is truncated too.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN scripts/kernel-doc~kill-warnings-when-building-mandocs scripts/kernel-doc
--- a/scripts/kernel-doc~kill-warnings-when-building-mandocs
+++ a/scripts/kernel-doc
@@ -328,6 +328,15 @@ while ($ARGV[0] =~ m/^-(.*)/) {
     }
 }
 
+# get kernel version from env
+sub get_kernel_version() {
+    my $version;
+
+    if (defined($ENV{'KERNELVERSION'})) {
+	$version = $ENV{'KERNELVERSION'};
+    }
+    return $version;
+}
 
 # generate a sequence of code that will splice in highlighting information
 # using the s// operator.
@@ -601,6 +610,7 @@ sub output_function_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'function'}."</refname>\n";
@@ -677,6 +687,7 @@ sub output_struct_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
@@ -761,6 +772,7 @@ sub output_enum_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
+    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>enum ".$args{'enum'}."</refname>\n";
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

drivers-acpi-kconfig-formulation-fixpatch.patch
git-net.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kill-warnings-when-building-mandocs.patch
