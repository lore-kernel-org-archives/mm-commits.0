From: akpm@linux-foundation.org
Subject: + kernel-doc-fix-xml-output-mode.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:18:23 -0700
Message-ID: <200710250418.l9P4INei031373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455AbXJYETM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:19:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, randy.dunlap@oracle.com, rpjday@mindspring.com, sam@ravnborg.org


The patch titled
     kernel-doc: fix xml output mode
has been added to the -mm tree.  Its filename is
     kernel-doc-fix-xml-output-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: fix xml output mode
From: Johannes Berg <johannes@sipsolutions.net>

After Randy's patch fixing the HTML output in DOC: sections
(6b5b55f6c404fa730a09a8254eb19f5a038afcc2) the same bug remained in XML mode,
this fixes it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-fix-xml-output-mode scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-fix-xml-output-mode
+++ a/scripts/kernel-doc
@@ -182,10 +182,10 @@ my $blankline_html = $local_lt . "p" . $
 my %highlights_xml = ( "([^=])\\\"([^\\\"<]+)\\\"", "\$1<quote>\$2</quote>",
 			$type_constant, "<constant>\$1</constant>",
 			$type_func, "<function>\$1</function>",
-			$type_struct, "<structname>\$1</structname>",
+			$type_struct_xml, "<structname>\$1</structname>",
 			$type_env, "<envar>\$1</envar>",
 			$type_param, "<parameter>\$1</parameter>" );
-my $blankline_xml = "</para><para>\n";
+my $blankline_xml = $local_lt . "/para" . $local_gt . $local_lt . "para" . $local_gt . "\n";
 
 # gnome, docbook format
 my %highlights_gnome = ( $type_constant, "<replaceable class=\"option\">\$1</replaceable>",
@@ -394,7 +394,7 @@ sub output_highlight {
 #	confess "output_highlight got called with no args?\n";
 #   }
 
-    if ($output_mode eq "html") {
+    if ($output_mode eq "html" || $output_mode eq "xml") {
 	$contents = local_unescape($contents);
 	# convert data read & converted thru xml_escape() into &xyz; format:
 	$contents =~ s/\\\\\\/&/g;
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

fix-appletouch-geyser-1-breakage.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-wireless.patch
kernel-doc-fix-xml-output-mode.patch
kernel-doc-init-kernel-version.patch
kernel-doc-single-doc-selection.patch
kernel-doc-process-functions-not-doc.patch
kernel-doc-use-no-doc-option.patch
kernel-doc-new-p-directive-for-doc-sections.patch
