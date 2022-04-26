Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84B7C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 20:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355105AbiDZUr2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 16:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355122AbiDZUrY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 16:47:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C275E1A861E
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 13:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B4496158A
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3ED5C385A0;
        Tue, 26 Apr 2022 20:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651005853;
        bh=hfBlGafySDK/uspIRHxorR8L5L/wB7rLtVB5hLfMaGI=;
        h=Date:To:From:Subject:From;
        b=g2/lpVteRFIaAlFLvNSZtPzajTZIGPy7H3MZugLIWeeYPi2jS4dEaHJ6lFtSl/K9K
         vbOWFDAl8jaR9xeXDjl4Ug4lily6mKpUOgG6QAnlBOhtoJz8nZhuroTQwftt8wf2fW
         5ReCuEpEksAVcB4MHDrUIb4Zg2Zowoa48bsOiLSM=
Date:   Tue, 26 Apr 2022 13:44:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com,
        christian.brauner@ubuntu.com, ddiss@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gen_init_cpio-fix-short-read-file-handling.patch added to -mm tree
Message-Id: <20220426204413.B3ED5C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gen_init_cpio: fix short read file handling
has been added to the -mm tree.  Its filename is
     gen_init_cpio-fix-short-read-file-handling.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gen_init_cpio-fix-short-read-file-handling.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gen_init_cpio-fix-short-read-file-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

initramfs-refactor-do_header-cpio-magic-checks.patch
initramfs-make-dir_entryname-a-flexible-array-member.patch
initramfs-add-initramfs_preserve_mtime-kconfig-option.patch
gen_init_cpio-fix-short-read-file-handling.patch
gen_init_cpio-support-file-checksum-archiving.patch
initramfs-support-cpio-extraction-with-file-checksums.patch

