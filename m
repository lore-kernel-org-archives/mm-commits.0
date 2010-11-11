From: akpm@linux-foundation.org
Subject: [merged] scripts-kernel-doc-escape-special-characters-for-xml-struct-output.patch removed from -mm tree
Date: Thu, 11 Nov 2010 11:10:56 -0800
Message-ID: <201011111913.oABJDREG029785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601Ab0KKTNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Nov 2010 14:13:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dmitry.torokhov@gmail.com, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     scripts/kernel-doc: escape special characters for xml struct output
has been removed from the -mm tree.  Its filename was
     scripts-kernel-doc-escape-special-characters-for-xml-struct-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/kernel-doc: escape special characters for xml struct output
From: Randy Dunlap <randy.dunlap@oracle.com>

scripts/kernel-doc was leaving unescaped '<', '>', and '&' in generated
xml output for structs.  This causes xml parser errors.  Convert these
characters to "&lt;", "&gt;", and "&amp;" as needed to prevent errors.

Most of the conversion was already done; complete it just before
output.

Documentation/DocBook/device-drivers.xml:41883: parser error : StartTag: invalid element name
#define INPUT_KEYMAP_BY_INDEX	(1 << 0)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN scripts/kernel-doc~scripts-kernel-doc-escape-special-characters-for-xml-struct-output scripts/kernel-doc
--- a/scripts/kernel-doc~scripts-kernel-doc-escape-special-characters-for-xml-struct-output
+++ a/scripts/kernel-doc
@@ -5,7 +5,7 @@ use strict;
 ## Copyright (c) 1998 Michael Zucchi, All Rights Reserved        ##
 ## Copyright (C) 2000, 1  Tim Waugh <twaugh@redhat.com>          ##
 ## Copyright (C) 2001  Simon Huggins                             ##
-## Copyright (C) 2005-2009  Randy Dunlap                         ##
+## Copyright (C) 2005-2010  Randy Dunlap                         ##
 ## 								 ##
 ## #define enhancements by Armin Kuster <akuster@mvista.com>	 ##
 ## Copyright (c) 2000 MontaVista Software, Inc.			 ##
@@ -453,7 +453,7 @@ sub output_highlight {
     if ($output_mode eq "html" || $output_mode eq "xml") {
 	$contents = local_unescape($contents);
 	# convert data read & converted thru xml_escape() into &xyz; format:
-	$contents =~ s/\\\\\\/&/g;
+	$contents =~ s/\\\\\\/\&/g;
     }
 #   print STDERR "contents b4:$contents\n";
     eval $dohighlight;
@@ -770,7 +770,11 @@ sub output_struct_xml(%) {
     print $args{'type'} . " " . $args{'struct'} . " {\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
 	if ($parameter =~ /^#/) {
-	    print "$parameter\n";
+	    my $prm = $parameter;
+	    # convert data read & converted thru xml_escape() into &xyz; format:
+	    # This allows us to have #define macros interspersed in a struct.
+	    $prm =~ s/\\\\\\/\&/g;
+	    print "$prm\n";
 	    next;
 	}
 
@@ -1701,6 +1705,8 @@ sub push_parameter($$$) {
 	}
 	}
 
+	$param = xml_escape($param);
+
 	# strip spaces from $param so that it is one continous string
 	# on @parameterlist;
 	# this fixes a problem where check_sections() cannot find
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
ibm_rtl-fix-printk-format-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-add-generic-exponentially-weighted-moving-average-ewma-function.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

