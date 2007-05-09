From: akpm@linux-foundation.org
Subject: - generate-main-index-page-when-building-htmldocs.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:45 -0700
Message-ID: <200705090249.l492nj3U009259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969752AbXEICty (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: generate main index page when building 'htmldocs'
has been removed from the -mm tree.  Its filename was
     generate-main-index-page-when-building-htmldocs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: generate main index page when building 'htmldocs'
From: Borislav Petkov <bbpetkov@yahoo.de>

A patch for kernel-doc that enables the generation of a global, TOC-like
index.html page after building 'htmldocs'

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN Documentation/DocBook/Makefile~generate-main-index-page-when-building-htmldocs Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~generate-main-index-page-when-building-htmldocs
+++ a/Documentation/DocBook/Makefile
@@ -43,6 +43,7 @@ pdfdocs: $(PDF)
 
 HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
 htmldocs: $(HTML)
+	$(call build_main_index)
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
 mandocs: $(MAN)
@@ -132,10 +133,17 @@ quiet_cmd_db2pdf = PDF      $@
 %.pdf : %.xml
 	$(call cmd,db2pdf)
 
+
+main_idx = Documentation/DocBook/index.html
+build_main_index = rm -rf $(main_idx) && \
+		   echo '<h1>Linux Kernel HTML Documentation</h1>' >> $(main_idx) && \
+		   echo '<h2>Kernel Version: $(KERNELVERSION)</h2>' >> $(main_idx) && \
+		   cat $(HTML) >> $(main_idx)
+
 quiet_cmd_db2html = HTML   $@
       cmd_db2html = xmlto xhtml $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
 		echo '<a HREF="$(patsubst %.html,%,$(notdir $@))/index.html"> \
-         Goto $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
+        $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
 
 %.html:	%.xml
 	@(which xmlto > /dev/null 2>&1) || \
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
kernel-doc-small-kernel-doc-optimization.patch
