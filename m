From: akpm@linux-foundation.org
Subject: [nacked] parse_integer-convert-mm.patch removed from -mm tree
Date: Thu, 10 Sep 2015 13:40:46 -0700
Message-ID: <55f1eace.MsSbP/B3FC0Bw47Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbbIJUkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 16:40:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert mm/
has been removed from the -mm tree.  Its filename was
     parse_integer-convert-mm.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: convert mm/

Convert mm/ directory away from deprecated simple_strto*() interface.

One thing to note about parse_integer() and seemingly useless casts --
range of accepted values depends on result type.

	int val;
	parse_integer(s, 0, &val);

will accept negative integers, while

	int val;
	parse_integer(s, 0, (unsigned int *)&val);

will accept only 0 and positive integers.

Cast is needed when result variable has to be of different type
for some reason.

This is very important and hopefully [knocks wood] obvious.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +++++++++++--------
 mm/memtest.c    |    6 ++----
 mm/page_alloc.c |    2 +-
 mm/shmem.c      |   14 ++++++++------
 4 files changed, 22 insertions(+), 19 deletions(-)

diff -puN mm/memcontrol.c~parse_integer-convert-mm mm/memcontrol.c
--- a/mm/memcontrol.c~parse_integer-convert-mm
+++ a/mm/memcontrol.c
@@ -3894,20 +3894,23 @@ static ssize_t memcg_write_event_control
 	struct fd efile;
 	struct fd cfile;
 	const char *name;
-	char *endp;
 	int ret;
 
 	buf = strstrip(buf);
 
-	efd = simple_strtoul(buf, &endp, 10);
-	if (*endp != ' ')
+	ret = parse_integer(buf, 10, &efd);
+	if (ret < 0)
+		return ret;
+	buf += ret;
+	if (*buf++ != ' ')
 		return -EINVAL;
-	buf = endp + 1;
-
-	cfd = simple_strtoul(buf, &endp, 10);
-	if ((*endp != ' ') && (*endp != '\0'))
+	ret = parse_integer(buf, 10, &cfd);
+	if (ret < 0)
+		return ret;
+	buf += ret;
+	if (*buf != ' ' && *buf != '\0')
 		return -EINVAL;
-	buf = endp + 1;
+	buf++;
 
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (!event)
diff -puN mm/memtest.c~parse_integer-convert-mm mm/memtest.c
--- a/mm/memtest.c~parse_integer-convert-mm
+++ a/mm/memtest.c
@@ -84,14 +84,12 @@ static unsigned int memtest_pattern __in
 
 static int __init parse_memtest(char *arg)
 {
-	int ret = 0;
-
 	if (arg)
-		ret = kstrtouint(arg, 0, &memtest_pattern);
+		parse_integer(arg, 0, (unsigned int *)&memtest_pattern);
 	else
 		memtest_pattern = ARRAY_SIZE(patterns);
 
-	return ret;
+	return 0;
 }
 
 early_param("memtest", parse_memtest);
diff -puN mm/page_alloc.c~parse_integer-convert-mm mm/page_alloc.c
--- a/mm/page_alloc.c~parse_integer-convert-mm
+++ a/mm/page_alloc.c
@@ -6446,7 +6446,7 @@ static int __init set_hashdist(char *str
 {
 	if (!str)
 		return 0;
-	hashdist = simple_strtoul(str, &str, 0);
+	parse_integer(str, 0, (unsigned int *)&hashdist);
 	return 1;
 }
 __setup("hashdist=", set_hashdist);
diff -puN mm/shmem.c~parse_integer-convert-mm mm/shmem.c
--- a/mm/shmem.c~parse_integer-convert-mm
+++ a/mm/shmem.c
@@ -2751,6 +2751,7 @@ static int shmem_parse_options(char *opt
 	struct mempolicy *mpol = NULL;
 	uid_t uid;
 	gid_t gid;
+	int rv;
 
 	while (options != NULL) {
 		this_char = options;
@@ -2804,14 +2805,15 @@ static int shmem_parse_options(char *opt
 		} else if (!strcmp(this_char,"mode")) {
 			if (remount)
 				continue;
-			sbinfo->mode = simple_strtoul(value, &rest, 8) & 07777;
-			if (*rest)
+			rv = parse_integer(value, 8, &sbinfo->mode);
+			if (rv < 0 || value[rv])
 				goto bad_val;
+			sbinfo->mode &= 07777;
 		} else if (!strcmp(this_char,"uid")) {
 			if (remount)
 				continue;
-			uid = simple_strtoul(value, &rest, 0);
-			if (*rest)
+			rv = parse_integer(value, 0, &uid);
+			if (rv < 0 || value[rv])
 				goto bad_val;
 			sbinfo->uid = make_kuid(current_user_ns(), uid);
 			if (!uid_valid(sbinfo->uid))
@@ -2819,8 +2821,8 @@ static int shmem_parse_options(char *opt
 		} else if (!strcmp(this_char,"gid")) {
 			if (remount)
 				continue;
-			gid = simple_strtoul(value, &rest, 0);
-			if (*rest)
+			rv = parse_integer(value, 0, &gid);
+			if (rv < 0 || value[rv])
 				goto bad_val;
 			sbinfo->gid = make_kgid(current_user_ns(), gid);
 			if (!gid_valid(sbinfo->gid))
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrto-accept-0-for-signed-conversion.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch
parse_integer-convert-fs-9p.patch
parse_integer-convert-fs-exofs.patch
proc-convert-to-kstrto-kstrto_from_user.patch
sound-convert-to-parse_integer.patch

