Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCAC1C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbiEJEZQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbiEJEXq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6F31D3D59
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:18:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7A156176D
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A0DC385C2;
        Tue, 10 May 2022 04:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156284;
        bh=19oKo0WVbdYOnI77hy42IYfArT5B8SiqFkh3/l/X5WM=;
        h=Date:To:From:Subject:From;
        b=ybMs+NJVSWuwZxnKrPYN300uitmMVcJ5C42ERs3f7wLiFNgUEDb4dSvBzWi+C/Z6I
         9RyvTPMJQGL9OjzNJKnPj8qzvmWwYQ1I0gYjjs3DPuziA3RFGmo/zvArJP4gSBFLRd
         kJdDKCBX1d6Nzpiarwmk2It+VWJ007i1g+2f0/No=
Date:   Mon, 09 May 2022 21:18:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com,
        christian.brauner@ubuntu.com, ddiss@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] gen_init_cpio-fix-short-read-file-handling.patch removed from -mm tree
Message-Id: <20220510041804.19A0DC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: gen_init_cpio: fix short read file handling
has been removed from the -mm tree.  Its filename was
     gen_init_cpio-fix-short-read-file-handling.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Disseldorp <ddiss@suse.de>
Subject: gen_init_cpio: fix short read file handling

When processing a "file" entry, gen_init_cpio attempts to allocate a
buffer large enough to stage the entire contents of the source file.  It
then attempts to fill the buffer via a single read() call and subsequently
writes out the entire buffer length, without checking that read() returned
the full length, potentially writing uninitialized buffer memory.

Fix this by breaking up file I/O into 64k chunks and only writing the
length returned by the prior read() call.

Link: https://lkml.kernel.org/r/20220404093429.27570-5-ddiss@suse.de
Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/gen_init_cpio.c |   44 +++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

--- a/usr/gen_init_cpio.c~gen_init_cpio-fix-short-read-file-handling
+++ a/usr/gen_init_cpio.c
@@ -20,6 +20,7 @@
 
 #define xstr(s) #s
 #define str(s) xstr(s)
+#define MIN(a, b) ((a) < (b) ? (a) : (b))
 
 static unsigned int offset;
 static unsigned int ino = 721;
@@ -297,9 +298,8 @@ static int cpio_mkfile(const char *name,
 			unsigned int nlinks)
 {
 	char s[256];
-	char *filebuf = NULL;
 	struct stat buf;
-	long size;
+	unsigned long size;
 	int file = -1;
 	int retval;
 	int rc = -1;
@@ -326,22 +326,17 @@ static int cpio_mkfile(const char *name,
 		buf.st_mtime = 0xffffffff;
 	}
 
-	filebuf = malloc(buf.st_size);
-	if (!filebuf) {
-		fprintf (stderr, "out of memory\n");
-		goto error;
-	}
-
-	retval = read (file, filebuf, buf.st_size);
-	if (retval < 0) {
-		fprintf (stderr, "Can not read %s file\n", location);
+	if (buf.st_size > 0xffffffff) {
+		fprintf(stderr, "%s: Size exceeds maximum cpio file size\n",
+			location);
 		goto error;
 	}
 
 	size = 0;
 	for (i = 1; i <= nlinks; i++) {
 		/* data goes on last link */
-		if (i == nlinks) size = buf.st_size;
+		if (i == nlinks)
+			size = buf.st_size;
 
 		if (name[0] == '/')
 			name++;
@@ -366,23 +361,34 @@ static int cpio_mkfile(const char *name,
 		push_string(name);
 		push_pad();
 
-		if (size) {
-			if (fwrite(filebuf, size, 1, stdout) != 1) {
+		while (size) {
+			unsigned char filebuf[65536];
+			ssize_t this_read;
+			size_t this_size = MIN(size, sizeof(filebuf));
+
+			this_read = read(file, filebuf, this_size);
+			if (this_read <= 0 || this_read > this_size) {
+				fprintf(stderr, "Can not read %s file\n", location);
+				goto error;
+			}
+
+			if (fwrite(filebuf, this_read, 1, stdout) != 1) {
 				fprintf(stderr, "writing filebuf failed\n");
 				goto error;
 			}
-			offset += size;
-			push_pad();
+			offset += this_read;
+			size -= this_read;
 		}
+		push_pad();
 
 		name += namesize;
 	}
 	ino++;
 	rc = 0;
-	
+
 error:
-	if (filebuf) free(filebuf);
-	if (file >= 0) close(file);
+	if (file >= 0)
+		close(file);
 	return rc;
 }
 
_

Patches currently in -mm which might be from ddiss@suse.de are


