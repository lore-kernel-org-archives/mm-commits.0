From: akpm@linux-foundation.org
Subject: + gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open.patch added to -mm tree
Date: Tue, 28 Dec 2010 13:14:33 -0800
Message-ID: <201012282114.oBSLEXct017824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab0L1VOq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Dec 2010 16:14:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, jgarzik@redhat.com


The patch titled
     gen_init_cpio: avoid risk of file changing between calls to stat() and open()
has been added to the -mm tree.  Its filename is
     gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open.patch

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

origin.patch
linux-next.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

