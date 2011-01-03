From: akpm@linux-foundation.org
Subject: [merged] gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open.patch removed from -mm tree
Date: Mon, 03 Jan 2011 10:52:25 -0800
Message-ID: <201101031853.p03IrhLw023079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab1ACSx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 13:53:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     gen_init_cpio: avoid risk of file changing between calls to stat() and open()
has been removed from the -mm tree.  Its filename was
     gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gen_init_cpio: avoid risk of file changing between calls to stat() and open()
From: Jesper Juhl <jj@chaosbits.net>

In usr/gen_init_cpio.c::cpio_mkfile() a call to stat() is made based on
pathname, subsequently the file is open()'ed and then the value of the
initial stat() call is used to allocate a buffer.  This is not safe since
the file may change between the call to stat() and the call to open(). 
Safer to just open() the file and then do fstat() using the filedescriptor
returned by open.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/gen_init_cpio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN usr/gen_init_cpio.c~gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open usr/gen_init_cpio.c
--- a/usr/gen_init_cpio.c~gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open
+++ a/usr/gen_init_cpio.c
@@ -309,18 +309,18 @@ static int cpio_mkfile(const char *name,
 
 	mode |= S_IFREG;
 
-	retval = stat (location, &buf);
-	if (retval) {
-		fprintf (stderr, "File %s could not be located\n", location);
-		goto error;
-	}
-
 	file = open (location, O_RDONLY);
 	if (file < 0) {
 		fprintf (stderr, "File %s could not be opened for reading\n", location);
 		goto error;
 	}
 
+	retval = fstat (file, &buf);
+	if (retval) {
+		fprintf (stderr, "File %s could not be stat()'ed\n", location);
+		goto error;
+	}
+
 	filebuf = malloc(buf.st_size);
 	if (!filebuf) {
 		fprintf (stderr, "out of memory\n");
_

Patches currently in -mm which might be from jj@chaosbits.net are

linux-next.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

