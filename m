From: akpm@linux-foundation.org
Subject: + scripts-kernel-doc-escape-special-characters-for-xml-struct-output.patch added to -mm tree
Date: Fri, 29 Oct 2010 14:17:15 -0700
Message-ID: <201010292117.o9TLHFr5017664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab0J2VR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 17:17:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dmitry.torokhov@gmail.com, mchehab@redhat.com


The patch titled
     scripts/kernel-doc: escape special characters for xml struct output
has been added to the -mm tree.  Its filename is
     scripts-kernel-doc-escape-special-characters-for-xml-struct-output.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
scripts-kernel-doc-escape-special-characters-for-xml-struct-output.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
ibm_rtl-fix-printk-format-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

