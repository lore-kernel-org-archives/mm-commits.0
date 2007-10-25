From: akpm@linux-foundation.org
Subject: + kernel-doc-new-p-directive-for-doc-sections.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:18:34 -0700
Message-ID: <200710250418.l9P4IYZk031388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825AbXJYET3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, randy.dunlap@oracle.com, rpjday@mindspring.com, sam@ravnborg.org


The patch titled
     kernel-doc: new P directive for DOC: sections
has been added to the -mm tree.  Its filename is
     kernel-doc-new-p-directive-for-doc-sections.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-appletouch-geyser-1-breakage.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-wireless.patch
kernel-doc-fix-xml-output-mode.patch
kernel-doc-init-kernel-version.patch
kernel-doc-single-doc-selection.patch
kernel-doc-process-functions-not-doc.patch
kernel-doc-use-no-doc-option.patch
kernel-doc-new-p-directive-for-doc-sections.patch
