From: akpm@linux-foundation.org
Subject: + kernel-doc-use-no-doc-option.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:18:32 -0700
Message-ID: <200710250418.l9P4IWfF031385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004AbXJYETS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, randy.dunlap@oracle.com, rpjday@mindspring.com, sam@ravnborg.org


The patch titled
     kernel-doc: use no-doc option
has been added to the -mm tree.  Its filename is
     kernel-doc-use-no-doc-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: use no-doc option
From: Johannes Berg <johannes@sipsolutions.net>

When asked by a template to include all functions from a file, it will also
include DOC: sections wreaking havoc in the generated docbook file.  This
patch makes it use the new -no-doc-sections flag for kernel-doc to avoid this.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/basic/docproc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/basic/docproc.c~kernel-doc-use-no-doc-option scripts/basic/docproc.c
--- a/scripts/basic/docproc.c~kernel-doc-use-no-doc-option
+++ a/scripts/basic/docproc.c
@@ -65,6 +65,7 @@ FILELINE * entity_system;
 #define DOCBOOK       "-docbook"
 #define FUNCTION      "-function"
 #define NOFUNCTION    "-nofunction"
+#define NODOCSECTIONS "-no-doc-sections"
 
 char *srctree;
 
@@ -231,13 +232,14 @@ void docfunctions(char * filename, char 
 
 	for (i=0; i <= symfilecnt; i++)
 		symcnt += symfilelist[i].symbolcnt;
-	vec = malloc((2 + 2 * symcnt + 2) * sizeof(char*));
+	vec = malloc((2 + 2 * symcnt + 3) * sizeof(char*));
 	if (vec == NULL) {
 		perror("docproc: ");
 		exit(1);
 	}
 	vec[idx++] = KERNELDOC;
 	vec[idx++] = DOCBOOK;
+	vec[idx++] = NODOCSECTIONS;
 	for (i=0; i < symfilecnt; i++) {
 		struct symfile * sym = &symfilelist[i];
 		for (j=0; j < sym->symbolcnt; j++) {
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
