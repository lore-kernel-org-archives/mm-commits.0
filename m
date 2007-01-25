From: akpm@osdl.org
Subject: + docbook-html-correction-of-recursive-a-tags-in-html-output.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:28:19 -0800
Message-ID: <200701250428.l0P4SJ74005775@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46193 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933205AbXAYE22 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:28:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pisa@cmp.felk.cvut.cz, randy.dunlap@oracle.com


The patch titled
     DocBook/HTML: correction of recursive A tags in HTML output
has been added to the -mm tree.  Its filename is
     docbook-html-correction-of-recursive-a-tags-in-html-output.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: DocBook/HTML: correction of recursive A tags in HTML output
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

The malformed HTML was generated after switch to XSLTPROC
from SGML tools. The reference title

  <refentrytitle><phrase id="API-struct-x">struct x</phrase></refentrytitle>

is converted into two recursive <a> tags

  <a href="re02.html"><span><a id="API-struct-x"></a>struct x</span></a>

There is more possible solutions for this problem.
One can be found at

  http://darkk.livejournal.com/

The proposed solution is based on suggestion provided by Jiri Kosek.

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kernel-doc |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN scripts/kernel-doc~docbook-html-correction-of-recursive-a-tags-in-html-output scripts/kernel-doc
--- a/scripts/kernel-doc~docbook-html-correction-of-recursive-a-tags-in-html-output
+++ a/scripts/kernel-doc
@@ -583,14 +583,14 @@ sub output_function_xml(%) {
     $id = "API-".$args{'function'};
     $id =~ s/[^A-Za-z0-9]/-/g;
 
-    print "<refentry>\n";
+    print "<refentry id=\"$id\">\n";
     print "<refentryinfo>\n";
     print " <title>LINUX</title>\n";
     print " <productname>Kernel Hackers Manual</productname>\n";
     print " <date>$man_date</date>\n";
     print "</refentryinfo>\n";
     print "<refmeta>\n";
-    print " <refentrytitle><phrase id=\"$id\">".$args{'function'}."</phrase></refentrytitle>\n";
+    print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
@@ -659,14 +659,14 @@ sub output_struct_xml(%) {
     $id = "API-struct-".$args{'struct'};
     $id =~ s/[^A-Za-z0-9]/-/g;
 
-    print "<refentry>\n";
+    print "<refentry id=\"$id\">\n";
     print "<refentryinfo>\n";
     print " <title>LINUX</title>\n";
     print " <productname>Kernel Hackers Manual</productname>\n";
     print " <date>$man_date</date>\n";
     print "</refentryinfo>\n";
     print "<refmeta>\n";
-    print " <refentrytitle><phrase id=\"$id\">".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
+    print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
@@ -743,14 +743,14 @@ sub output_enum_xml(%) {
     $id = "API-enum-".$args{'enum'};
     $id =~ s/[^A-Za-z0-9]/-/g;
 
-    print "<refentry>\n";
+    print "<refentry id=\"$id\">\n";
     print "<refentryinfo>\n";
     print " <title>LINUX</title>\n";
     print " <productname>Kernel Hackers Manual</productname>\n";
     print " <date>$man_date</date>\n";
     print "</refentryinfo>\n";
     print "<refmeta>\n";
-    print " <refentrytitle><phrase id=\"$id\">enum ".$args{'enum'}."</phrase></refentrytitle>\n";
+    print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
@@ -809,14 +809,14 @@ sub output_typedef_xml(%) {
     $id = "API-typedef-".$args{'typedef'};
     $id =~ s/[^A-Za-z0-9]/-/g;
 
-    print "<refentry>\n";
+    print "<refentry id=\"$id\">\n";
     print "<refentryinfo>\n";
     print " <title>LINUX</title>\n";
     print " <productname>Kernel Hackers Manual</productname>\n";
     print " <date>$man_date</date>\n";
     print "</refentryinfo>\n";
     print "<refmeta>\n";
-    print " <refentrytitle><phrase id=\"$id\">typedef ".$args{'typedef'}."</phrase></refentrytitle>\n";
+    print " <refentrytitle><phrase>typedef ".$args{'typedef'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
_

Patches currently in -mm which might be from pisa@cmp.felk.cvut.cz are

git-arm.patch
arm-imx-serial-fix-tx-buffer-overflows.patch
docbook-html-generate-chapter-section-level-tocs-for-functions.patch
docbook-html-correction-of-recursive-a-tags-in-html-output.patch
