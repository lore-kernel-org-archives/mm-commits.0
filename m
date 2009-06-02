From: akpm@linux-foundation.org
Subject: + scripts-allow-docproc-invocation-from-external.patch added to -mm tree
Date: Mon, 01 Jun 2009 20:35:29 -0700
Message-ID: <200906020335.n523ZTaW030626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbZFBDfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 23:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     scripts: allow docproc invocation from external
has been added to the -mm tree.  Its filename is
     scripts-allow-docproc-invocation-from-external.patch

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
Subject: scripts: allow docproc invocation from external
From: Jiri Slaby <jirislaby@gmail.com>

- getcwd returns path without a slash at the end, add the slash
- add KBUILD_SRC env support, so that we can specify path for
  kernel (to know where scripts/kernel-doc resides) and SRCTREE
  (for searching files referenced in .tmpl) separately
- use KBUILD_SRC instead of a newly introduced environment variable

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/basic/docproc.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN scripts/basic/docproc.c~scripts-allow-docproc-invocation-from-external scripts/basic/docproc.c
--- a/scripts/basic/docproc.c~scripts-allow-docproc-invocation-from-external
+++ a/scripts/basic/docproc.c
@@ -69,7 +69,7 @@ FILELINE * docsection;
 #define NOFUNCTION    "-nofunction"
 #define NODOCSECTIONS "-no-doc-sections"
 
-char *srctree;
+static char *srctree, *kernsrctree;
 
 void usage (void)
 {
@@ -77,7 +77,8 @@ void usage (void)
 	fprintf(stderr, "Input is read from file.tmpl. Output is sent to stdout\n");
 	fprintf(stderr, "doc: frontend when generating kernel documentation\n");
 	fprintf(stderr, "depend: generate list of files referenced within file\n");
-	fprintf(stderr, "Environment variable SRCTREE: absolute path to kernel source tree.\n");
+	fprintf(stderr, "Environment variable SRCTREE: absolute path to sources.\n");
+	fprintf(stderr, "                     KBUILD_SRC: absolute path to kernel source tree.\n");
 }
 
 /*
@@ -96,8 +97,8 @@ void exec_kernel_doc(char **svec)
 			exit(1);
 		case  0:
 			memset(real_filename, 0, sizeof(real_filename));
-			strncat(real_filename, srctree, PATH_MAX);
-			strncat(real_filename, KERNELDOCPATH KERNELDOC,
+			strncat(real_filename, kernsrctree, PATH_MAX);
+			strncat(real_filename, "/" KERNELDOCPATH KERNELDOC,
 					PATH_MAX - strlen(real_filename));
 			execvp(real_filename, svec);
 			fprintf(stderr, "exec ");
@@ -178,6 +179,7 @@ void find_export_symbols(char * filename
 		char real_filename[PATH_MAX + 1];
 		memset(real_filename, 0, sizeof(real_filename));
 		strncat(real_filename, srctree, PATH_MAX);
+		strncat(real_filename, "/", PATH_MAX - strlen(real_filename));
 		strncat(real_filename, filename,
 				PATH_MAX - strlen(real_filename));
 		sym = add_new_file(filename);
@@ -382,6 +384,9 @@ int main(int argc, char *argv[])
 	srctree = getenv("SRCTREE");
 	if (!srctree)
 		srctree = getcwd(NULL, 0);
+	kernsrctree = getenv("KBUILD_SRC");
+	if (!kernsrctree)
+		kernsrctree = srctree;
 	if (argc != 3) {
 		usage();
 		exit(1);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-mxser-fix-isa-board-lookup.patch
linux-next.patch
scripts-allow-docproc-invocation-from-external.patch
fs-fix-lock-imbalance-in-do_remount_sb.patch
icom-converting-space-to-tabs.patch
icom-fix-compile-errors-when-defining-icom_trace.patch
char-isicom-fix-build-warning.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

