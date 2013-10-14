From: akpm@linux-foundation.org
Subject: + kernel-doc-improve-no-structured-comments-found-error.patch
 added to -mm tree
Date: Mon, 14 Oct 2013 15:47:50 -0700
Message-ID: <525c7496.MsOwYW+3XywNohUi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab3JNWrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Oct 2013 18:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org, johannes.berg@intel.com

Subject: + kernel-doc-improve-no-structured-comments-found-error.patch added to -mm tree
To: johannes.berg@intel.com,rdunlap@infradead.org,rob@landley.net
From: akpm@linux-foundation.org
Date: Mon, 14 Oct 2013 15:47:50 -0700


The patch titled
     Subject: kernel-doc: improve "no structured comments found" error
has been added to the -mm tree.  Its filename is
     kernel-doc-improve-no-structured-comments-found-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-doc-improve-no-structured-comments-found-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-doc-improve-no-structured-comments-found-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: kernel-doc: improve "no structured comments found" error

When using '!Ffile function' in a docbook template, and the function no
longer exists, you get a "no structured comments found" error from the
kernel-doc processing script.  It's useful to know which functions it was
looking for, so print them out in this case.  Also do the same for '!Pfile
doc-section'

The same error also happens when using '!Efile' when some exported
functions aren't documented (in the same file.) There's a very large
number of such functions though, so don't print the message in this case
-- right now it would give ~850 messages.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/docproc.c  |   14 +++++++++-----
 scripts/kernel-doc |    6 ++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff -puN scripts/docproc.c~kernel-doc-improve-no-structured-comments-found-error scripts/docproc.c
--- a/scripts/docproc.c~kernel-doc-improve-no-structured-comments-found-error
+++ a/scripts/docproc.c
@@ -72,6 +72,7 @@ FILELINE * docsection;
 #define FUNCTION      "-function"
 #define NOFUNCTION    "-nofunction"
 #define NODOCSECTIONS "-no-doc-sections"
+#define SHOWNOTFOUND  "-show-not-found"
 
 static char *srctree, *kernsrctree;
 
@@ -294,6 +295,7 @@ static void singfunc(char * filename, ch
         int startofsym = 1;
 	vec[idx++] = KERNELDOC;
 	vec[idx++] = DOCBOOK;
+	vec[idx++] = SHOWNOTFOUND;
 
         /* Split line up in individual parameters preceded by FUNCTION */
         for (i=0; line[i]; i++) {
@@ -325,7 +327,8 @@ static void singfunc(char * filename, ch
  */
 static void docsect(char *filename, char *line)
 {
-	char *vec[6]; /* kerneldoc -docbook -function "section" file NULL */
+	/* kerneldoc -docbook -show-not-found -function "section" file NULL */
+	char *vec[7];
 	char *s;
 
 	for (s = line; *s; s++)
@@ -341,10 +344,11 @@ static void docsect(char *filename, char
 
 	vec[0] = KERNELDOC;
 	vec[1] = DOCBOOK;
-	vec[2] = FUNCTION;
-	vec[3] = line;
-	vec[4] = filename;
-	vec[5] = NULL;
+	vec[2] = SHOWNOTFOUND;
+	vec[3] = FUNCTION;
+	vec[4] = line;
+	vec[5] = filename;
+	vec[6] = NULL;
 	exec_kernel_doc(vec);
 }
 
diff -puN scripts/kernel-doc~kernel-doc-improve-no-structured-comments-found-error scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-improve-no-structured-comments-found-error
+++ a/scripts/kernel-doc
@@ -257,6 +257,7 @@ my $man_date = ('January', 'February', '
 		'July', 'August', 'September', 'October',
 		'November', 'December')[(localtime)[4]] .
   " " . ((localtime)[5]+1900);
+my $show_not_found = 0;
 
 # Essentially these are globals.
 # They probably want to be tidied up, made more localised or something.
@@ -369,6 +370,8 @@ while ($ARGV[0] =~ m/^-(.*)/) {
 	usage();
     } elsif ($cmd eq '-no-doc-sections') {
 	    $no_doc_sections = 1;
+    } elsif ($cmd eq '-show-not-found') {
+	$show_not_found = 1;
     }
 }
 
@@ -2536,6 +2539,9 @@ sub process_file($) {
     }
     if ($initial_section_counter == $section_counter) {
 	print STDERR "Warning(${file}): no structured comments found\n";
+	if (($function_only == 1) && ($show_not_found == 1)) {
+	    print STDERR "    Was looking for '$_'.\n" for keys %function_table;
+	}
 	if ($output_mode eq "xml") {
 	    # The template wants at least one RefEntry here; make one.
 	    print "<refentry>\n";
_

Patches currently in -mm which might be from johannes.berg@intel.com are

kernel-doc-improve-no-structured-comments-found-error.patch

