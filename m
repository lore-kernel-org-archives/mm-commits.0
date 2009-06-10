From: akpm@linux-foundation.org
Subject: [merged] scripts-allow-docproc-invocation-from-external.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:56:10 -0700
Message-ID: <200906101756.n5AHuAYj008221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbZFJR4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     scripts: allow docproc invocation from external
has been removed from the -mm tree.  Its filename was
     scripts-allow-docproc-invocation-from-external.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
icom-converting-space-to-tabs.patch
char-isicom-fix-build-warning.patch
char-moxa-prevent-opening-unavailable-ports.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

