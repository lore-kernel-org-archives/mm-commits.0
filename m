From: akpm@linux-foundation.org
Subject: + codingstyle-add-information-about-editor-modelines.patch added to -mm tree
Date: Wed, 27 Jun 2007 12:31:59 -0700
Message-ID: <200706271931.l5RJVxiP004156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761555AbXF0Tcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 15:32:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josht@linux.vnet.ibm.com, josh@freedesktop.org


The patch titled
     CodingStyle: add information about editor modelines
has been added to the -mm tree.  Its filename is
     codingstyle-add-information-about-editor-modelines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CodingStyle: add information about editor modelines
From: Josh Triplett <josht@linux.vnet.ibm.com>

I recently received a patch including a file that had a vim modeline,
and I realized that nothing specifically proscribed that practice.

Signed-off-by: Josh Triplett <josh@freedesktop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+)

diff -puN Documentation/CodingStyle~codingstyle-add-information-about-editor-modelines Documentation/CodingStyle
--- a/Documentation/CodingStyle~codingstyle-add-information-about-editor-modelines
+++ a/Documentation/CodingStyle
@@ -738,6 +738,33 @@ need them.  Feel free to peruse that hea
 defined that you shouldn't reproduce in your code.
 
 
+		Chapter 18:  Editor modelines and other cruft
+
+Some editors can interpret configuration information embedded in source files,
+indicated with special markers.  For example, emacs interprets lines marked
+like this:
+
+-*- mode: c -*-
+
+Or like this:
+
+/*
+Local Variables:
+compile-command: "gcc -DMAGIC_DEBUG_FLAG foo.c"
+End:
+*/
+
+Vim interprets markers that look like this:
+
+/* vim:set sw=8 noet */
+
+Do not include any of these in source files.  People have their own personal
+editor configurations, and your source files should not override them.  This
+includes markers for indentation and mode configuration.  People may use their
+own custom mode, or may have some other magic method for making indentation
+work correctly.
+
+
 
 		Appendix I: References
 
_

Patches currently in -mm which might be from josht@linux.vnet.ibm.com are

codingstyle-add-information-about-trailing-whitespace.patch
codingstyle-add-information-about-editor-modelines.patch
