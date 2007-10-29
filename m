From: akpm@linux-foundation.org
Subject: - kernel-doc-new-p-directive-for-doc-sections.patch removed from -mm tree
Date: Mon, 29 Oct 2007 13:31:44 -0700
Message-ID: <200710292031.l9TKViqm021875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbXJ2Ui5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:38:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, randy.dunlap@oracle.com, rpjday@mindspring.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: new P directive for DOC: sections
has been removed from the -mm tree.  Its filename was
     kernel-doc-new-p-directive-for-doc-sections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: new P directive for DOC: sections
From: Johannes Berg <johannes@sipsolutions.net>

The !P directive includes the contents of a DOC: section given by title, e.g. 
!Pfilename Title of the section

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/basic/docproc.c |   40 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff -puN scripts/basic/docproc.c~kernel-doc-new-p-directive-for-doc-sections scripts/basic/docproc.c
--- a/scripts/basic/docproc.c~kernel-doc-new-p-directive-for-doc-sections
+++ a/scripts/basic/docproc.c
@@ -30,6 +30,7 @@
  *		!Ifilename
  *		!Dfilename
  *		!Ffilename
+ *		!Pfilename
  *
  */
 
@@ -57,6 +58,7 @@ FILEONLY *symbolsonly;
 typedef void FILELINE(char * file, char * line);
 FILELINE * singlefunctions;
 FILELINE * entity_system;
+FILELINE * docsection;
 
 #define MAXLINESZ     2048
 #define MAXFILES      250
@@ -289,12 +291,36 @@ void singfunc(char * filename, char * li
 }
 
 /*
+ * Insert specific documentation section from a file.
+ * Call kernel-doc with the following parameters:
+ * kernel-doc -docbook -function "doc section" filename
+ */
+void docsect(char *filename, char *line)
+{
+	char *vec[6]; /* kerneldoc -docbook -function "section" file NULL */
+	char *s;
+
+	for (s = line; *s; s++)
+		if (*s == '\n')
+			*s = '\0';
+
+	vec[0] = KERNELDOC;
+	vec[1] = DOCBOOK;
+	vec[2] = FUNCTION;
+	vec[3] = line;
+	vec[4] = filename;
+	vec[5] = NULL;
+	exec_kernel_doc(vec);
+}
+
+/*
  * Parse file, calling action specific functions for:
  * 1) Lines containing !E
  * 2) Lines containing !I
  * 3) Lines containing !D
  * 4) Lines containing !F
- * 5) Default lines - lines not matching the above
+ * 5) Lines containing !P
+ * 6) Default lines - lines not matching the above
  */
 void parse_file(FILE *infile)
 {
@@ -328,6 +354,15 @@ void parse_file(FILE *infile)
 						s++;
 					singlefunctions(line +2, s);
 					break;
+				case 'P':
+					/* filename */
+					while (*s && !isspace(*s)) s++;
+					*s++ = '\0';
+					/* DOC: section name */
+					while (isspace(*s))
+						s++;
+					docsection(line +2, s);
+					break;
 				default:
 					defaultline(line);
 			}
@@ -374,6 +409,7 @@ int main(int argc, char *argv[])
 		externalfunctions = find_export_symbols;
 		symbolsonly       = find_export_symbols;
 		singlefunctions   = noaction2;
+		docsection        = noaction2;
 		parse_file(infile);
 
 		/* Rewind to start from beginning of file again */
@@ -383,6 +419,7 @@ int main(int argc, char *argv[])
 		externalfunctions = extfunc;
 		symbolsonly       = printline;
 		singlefunctions   = singfunc;
+		docsection        = docsect;
 
 		parse_file(infile);
 	}
@@ -396,6 +433,7 @@ int main(int argc, char *argv[])
 		externalfunctions = adddep;
 		symbolsonly       = adddep;
 		singlefunctions   = adddep2;
+		docsection        = adddep2;
 		parse_file(infile);
 		printf("\n");
 	}
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-input.patch
fix-appletouch-geyser-1-breakage.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kbuild.patch
git-wireless.patch
