From: akpm@osdl.org
Subject: + usr-gen_init_cpioc-support-for-hard-links.patch added to -mm tree
Date: Thu, 14 Dec 2006 17:01:08 -0800
Message-ID: <200612150101.kBF118IF002235@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47515 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbWLOBBT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 20:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: strange@nsk.no-ip.org, viro@zeniv.linux.org.uk


The patch titled
     usr/gen_init_cpio.c: support for hard links
has been added to the -mm tree.  Its filename is
     usr-gen_init_cpioc-support-for-hard-links.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usr/gen_init_cpio.c: support for hard links
From: Luciano Rocha <strange@nsk.no-ip.org>

Extend usr/gen_init_cpio.c "file" entry, adding support for hard links.

Previous format:
file <name> <location> <mode> <uid> <gid>

New format:
file <name> <location> <mode> <uid> <gid> [<hard links>]

The hard links specification is optional, keeping the previous
behaviour.

All hard links are defined sequentially in the resulting cpio and the
file data is present only in the last link. This is the behaviour of
GNU's cpio and is supported by the kernel initramfs extractor.

Signed-off-by: Luciano Rocha <strange@nsk.no-ip.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 usr/gen_init_cpio.c |  122 +++++++++++++++++++++++++++++-------------
 1 files changed, 86 insertions(+), 36 deletions(-)

diff -puN usr/gen_init_cpio.c~usr-gen_init_cpioc-support-for-hard-links usr/gen_init_cpio.c
--- a/usr/gen_init_cpio.c~usr-gen_init_cpioc-support-for-hard-links
+++ a/usr/gen_init_cpio.c
@@ -14,6 +14,7 @@
  * Original work by Jeff Garzik
  *
  * External file lists, symlink, pipe and fifo support by Thayne Harbaugh
+ * Hard link support by Luciano Rocha
  */
 
 #define xstr(s) #s
@@ -286,16 +287,19 @@ static int cpio_mknod_line(const char *l
 	return rc;
 }
 
-/* Not marked static to keep the compiler quiet, as no one uses this yet... */
 static int cpio_mkfile(const char *name, const char *location,
-			unsigned int mode, uid_t uid, gid_t gid)
+			unsigned int mode, uid_t uid, gid_t gid,
+			unsigned int nlinks)
 {
 	char s[256];
 	char *filebuf = NULL;
 	struct stat buf;
+	long size;
 	int file = -1;
 	int retval;
 	int rc = -1;
+	int namesize;
+	int i;
 
 	mode |= S_IFREG;
 
@@ -323,29 +327,41 @@ static int cpio_mkfile(const char *name,
 		goto error;
 	}
 
-	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
-	       "%08X%08X%08X%08X%08X%08X%08X",
-		"070701",		/* magic */
-		ino++,			/* ino */
-		mode,			/* mode */
-		(long) uid,		/* uid */
-		(long) gid,		/* gid */
-		1,			/* nlink */
-		(long) buf.st_mtime,	/* mtime */
-		(int) buf.st_size,	/* filesize */
-		3,			/* major */
-		1,			/* minor */
-		0,			/* rmajor */
-		0,			/* rminor */
-		(unsigned)strlen(name) + 1,/* namesize */
-		0);			/* chksum */
-	push_hdr(s);
-	push_string(name);
-	push_pad();
+	size = 0;
+	for (i = 1; i <= nlinks; i++) {
+		/* data goes on last link */
+		if (i == nlinks) size = buf.st_size;
+
+		namesize = strlen(name) + 1;
+		sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
+		       "%08lX%08X%08X%08X%08X%08X%08X",
+			"070701",		/* magic */
+			ino,			/* ino */
+			mode,			/* mode */
+			(long) uid,		/* uid */
+			(long) gid,		/* gid */
+			nlinks,			/* nlink */
+			(long) buf.st_mtime,	/* mtime */
+			size,			/* filesize */
+			3,			/* major */
+			1,			/* minor */
+			0,			/* rmajor */
+			0,			/* rminor */
+			namesize,		/* namesize */
+			0);			/* chksum */
+		push_hdr(s);
+		push_string(name);
+		push_pad();
+
+		if (size) {
+			fwrite(filebuf, size, 1, stdout);
+			offset += size;
+			push_pad();
+		}
 
-	fwrite(filebuf, buf.st_size, 1, stdout);
-	offset += buf.st_size;
-	push_pad();
+		name += namesize;
+	}
+	ino++;
 	rc = 0;
 	
 error:
@@ -357,18 +373,51 @@ error:
 static int cpio_mkfile_line(const char *line)
 {
 	char name[PATH_MAX + 1];
+	char *dname = NULL; /* malloc'ed buffer for hard links */
 	char location[PATH_MAX + 1];
 	unsigned int mode;
 	int uid;
 	int gid;
+	int nlinks = 1;
+	int end = 0, dname_len = 0;
 	int rc = -1;
 
-	if (5 != sscanf(line, "%" str(PATH_MAX) "s %" str(PATH_MAX) "s %o %d %d", name, location, &mode, &uid, &gid)) {
+	if (5 > sscanf(line, "%" str(PATH_MAX) "s %" str(PATH_MAX)
+				"s %o %d %d %n",
+				name, location, &mode, &uid, &gid, &end)) {
 		fprintf(stderr, "Unrecognized file format '%s'", line);
 		goto fail;
 	}
-	rc = cpio_mkfile(name, location, mode, uid, gid);
+	if (end && isgraph(line[end])) {
+		int len;
+		int nend;
+
+		dname = malloc(strlen(line));
+		if (!dname) {
+			fprintf (stderr, "out of memory (%d)\n", dname_len);
+			goto fail;
+		}
+
+		dname_len = strlen(name) + 1;
+		memcpy(dname, name, dname_len);
+
+		do {
+			nend = 0;
+			if (sscanf(line + end, "%" str(PATH_MAX) "s %n",
+					name, &nend) < 1)
+				break;
+			len = strlen(name) + 1;
+			memcpy(dname + dname_len, name, len);
+			dname_len += len;
+			nlinks++;
+			end += nend;
+		} while (isgraph(line[end]));
+	} else {
+		dname = name;
+	}
+	rc = cpio_mkfile(dname, location, mode, uid, gid, nlinks);
  fail:
+	if (dname_len) free(dname);
 	return rc;
 }
 
@@ -381,22 +430,23 @@ void usage(const char *prog)
 		"describe the files to be included in the initramfs archive:\n"
 		"\n"
 		"# a comment\n"
-		"file <name> <location> <mode> <uid> <gid>\n"
+		"file <name> <location> <mode> <uid> <gid> [<hard links>]\n"
 		"dir <name> <mode> <uid> <gid>\n"
 		"nod <name> <mode> <uid> <gid> <dev_type> <maj> <min>\n"
 		"slink <name> <target> <mode> <uid> <gid>\n"
 		"pipe <name> <mode> <uid> <gid>\n"
 		"sock <name> <mode> <uid> <gid>\n"
 		"\n"
-		"<name>      name of the file/dir/nod/etc in the archive\n"
-		"<location>  location of the file in the current filesystem\n"
-		"<target>    link target\n"
-		"<mode>      mode/permissions of the file\n"
-		"<uid>       user id (0=root)\n"
-		"<gid>       group id (0=root)\n"
-		"<dev_type>  device type (b=block, c=character)\n"
-		"<maj>       major number of nod\n"
-		"<min>       minor number of nod\n"
+		"<name>       name of the file/dir/nod/etc in the archive\n"
+		"<location>   location of the file in the current filesystem\n"
+		"<target>     link target\n"
+		"<mode>       mode/permissions of the file\n"
+		"<uid>        user id (0=root)\n"
+		"<gid>        group id (0=root)\n"
+		"<dev_type>   device type (b=block, c=character)\n"
+		"<maj>        major number of nod\n"
+		"<min>        minor number of nod\n"
+		"<hard links> space separated list of other links to file\n"
 		"\n"
 		"example:\n"
 		"# A simple initramfs\n"
_

Patches currently in -mm which might be from strange@nsk.no-ip.org are

usr-gen_init_cpioc-support-for-hard-links.patch

