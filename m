Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C94AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 20:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352707AbiDZUr3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 16:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355027AbiDZUr1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 16:47:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264AA1A15FD
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 13:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3300B82355
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9CDC385A4;
        Tue, 26 Apr 2022 20:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651005855;
        bh=2dOKxBAZ1XMW10jdjP2mg2NwuZBQu9/glHLxUJedpfA=;
        h=Date:To:From:Subject:From;
        b=UNMAMRC7qzgVxOMyTllVMfS9nOgxrUJ7TzA/ZsSgtdHUKDl8anHuvIlsUxJT8PlEq
         Y3afGnLiPR3CoPBUE5gtaCuwy4lR7QEC9CU48j7qeTUKbvE8sHYxfXl31daqe4KUVQ
         P0YJ1CI2In4t6GnoprFsGi8oYM4RLDpkB8kyx6pQ=
Date:   Tue, 26 Apr 2022 13:44:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com,
        christian.brauner@ubuntu.com, ddiss@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gen_init_cpio-support-file-checksum-archiving.patch added to -mm tree
Message-Id: <20220426204415.8D9CDC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gen_init_cpio: support file checksum archiving
has been added to the -mm tree.  Its filename is
     gen_init_cpio-support-file-checksum-archiving.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gen_init_cpio-support-file-checksum-archiving.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gen_init_cpio-support-file-checksum-archiving.patch

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
Subject: gen_init_cpio: support file checksum archiving

Documentation/driver-api/early-userspace/buffer-format.rst includes the
specification for checksum-enabled cpio archives.  Implement support for
this format in gen_init_cpio via a new '-c' parameter.

Link: https://lkml.kernel.org/r/20220404093429.27570-6-ddiss@suse.de
Signed-off-by: David Disseldorp <ddiss@suse.de>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/gen_init_cpio.c |   54 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 9 deletions(-)

--- a/usr/gen_init_cpio.c~gen_init_cpio-support-file-checksum-archiving
+++ a/usr/gen_init_cpio.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <string.h>
@@ -25,6 +27,7 @@
 static unsigned int offset;
 static unsigned int ino = 721;
 static time_t default_mtime;
+static bool do_csum = false;
 
 struct file_handler {
 	const char *type;
@@ -78,7 +81,7 @@ static void cpio_trailer(void)
 
 	sprintf(s, "%s%08X%08X%08lX%08lX%08X%08lX"
 	       "%08X%08X%08X%08X%08X%08X%08X",
-		"070701",		/* magic */
+		do_csum ? "070702" : "070701", /* magic */
 		0,			/* ino */
 		0,			/* mode */
 		(long) 0,		/* uid */
@@ -110,7 +113,7 @@ static int cpio_mkslink(const char *name
 		name++;
 	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
 	       "%08X%08X%08X%08X%08X%08X%08X",
-		"070701",		/* magic */
+		do_csum ? "070702" : "070701", /* magic */
 		ino++,			/* ino */
 		S_IFLNK | mode,		/* mode */
 		(long) uid,		/* uid */
@@ -159,7 +162,7 @@ static int cpio_mkgeneric(const char *na
 		name++;
 	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
 	       "%08X%08X%08X%08X%08X%08X%08X",
-		"070701",		/* magic */
+		do_csum ? "070702" : "070701", /* magic */
 		ino++,			/* ino */
 		mode,			/* mode */
 		(long) uid,		/* uid */
@@ -253,7 +256,7 @@ static int cpio_mknod(const char *name,
 		name++;
 	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
 	       "%08X%08X%08X%08X%08X%08X%08X",
-		"070701",		/* magic */
+		do_csum ? "070702" : "070701", /* magic */
 		ino++,			/* ino */
 		mode,			/* mode */
 		(long) uid,		/* uid */
@@ -293,6 +296,29 @@ static int cpio_mknod_line(const char *l
 	return rc;
 }
 
+static int cpio_mkfile_csum(int fd, unsigned long size, uint32_t *csum)
+{
+	while (size) {
+		unsigned char filebuf[65536];
+		ssize_t this_read;
+		size_t i, this_size = MIN(size, sizeof(filebuf));
+
+		this_read = read(fd, filebuf, this_size);
+		if (this_read <= 0 || this_read > this_size)
+			return -1;
+
+		for (i = 0; i < this_read; i++)
+			*csum += filebuf[i];
+
+		size -= this_read;
+	}
+	/* seek back to the start for data segment I/O */
+	if (lseek(fd, 0, SEEK_SET) < 0)
+		return -1;
+
+	return 0;
+}
+
 static int cpio_mkfile(const char *name, const char *location,
 			unsigned int mode, uid_t uid, gid_t gid,
 			unsigned int nlinks)
@@ -305,6 +331,7 @@ static int cpio_mkfile(const char *name,
 	int rc = -1;
 	int namesize;
 	unsigned int i;
+	uint32_t csum = 0;
 
 	mode |= S_IFREG;
 
@@ -332,6 +359,11 @@ static int cpio_mkfile(const char *name,
 		goto error;
 	}
 
+	if (do_csum && cpio_mkfile_csum(file, buf.st_size, &csum) < 0) {
+		fprintf(stderr, "Failed to checksum file %s\n", location);
+		goto error;
+	}
+
 	size = 0;
 	for (i = 1; i <= nlinks; i++) {
 		/* data goes on last link */
@@ -343,7 +375,7 @@ static int cpio_mkfile(const char *name,
 		namesize = strlen(name) + 1;
 		sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
 		       "%08lX%08X%08X%08X%08X%08X%08X",
-			"070701",		/* magic */
+			do_csum ? "070702" : "070701", /* magic */
 			ino,			/* ino */
 			mode,			/* mode */
 			(long) uid,		/* uid */
@@ -356,7 +388,7 @@ static int cpio_mkfile(const char *name,
 			0,			/* rmajor */
 			0,			/* rminor */
 			namesize,		/* namesize */
-			0);			/* chksum */
+			size ? csum : 0);	/* chksum */
 		push_hdr(s);
 		push_string(name);
 		push_pad();
@@ -464,7 +496,7 @@ static int cpio_mkfile_line(const char *
 static void usage(const char *prog)
 {
 	fprintf(stderr, "Usage:\n"
-		"\t%s [-t <timestamp>] <cpio_list>\n"
+		"\t%s [-t <timestamp>] [-c] <cpio_list>\n"
 		"\n"
 		"<cpio_list> is a file containing newline separated entries that\n"
 		"describe the files to be included in the initramfs archive:\n"
@@ -499,7 +531,8 @@ static void usage(const char *prog)
 		"\n"
 		"<timestamp> is time in seconds since Epoch that will be used\n"
 		"as mtime for symlinks, special files and directories. The default\n"
-		"is to use the current time for these entries.\n",
+		"is to use the current time for these entries.\n"
+		"-c: calculate and store 32-bit checksums for file data.\n",
 		prog);
 }
 
@@ -541,7 +574,7 @@ int main (int argc, char *argv[])
 
 	default_mtime = time(NULL);
 	while (1) {
-		int opt = getopt(argc, argv, "t:h");
+		int opt = getopt(argc, argv, "t:ch");
 		char *invalid;
 
 		if (opt == -1)
@@ -556,6 +589,9 @@ int main (int argc, char *argv[])
 				exit(1);
 			}
 			break;
+		case 'c':
+			do_csum = true;
+			break;
 		case 'h':
 		case '?':
 			usage(argv[0]);
_

Patches currently in -mm which might be from ddiss@suse.de are

initramfs-refactor-do_header-cpio-magic-checks.patch
initramfs-make-dir_entryname-a-flexible-array-member.patch
initramfs-add-initramfs_preserve_mtime-kconfig-option.patch
gen_init_cpio-fix-short-read-file-handling.patch
gen_init_cpio-support-file-checksum-archiving.patch
initramfs-support-cpio-extraction-with-file-checksums.patch

