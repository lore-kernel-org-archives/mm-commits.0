From: akpm@linux-foundation.org
Subject: + parse_integer-convert-mm.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:26:17 -0700
Message-ID: <559ecad9.hpeVsY/hVmSHYrz/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbGIT0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:26:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert mm/
has been added to the -mm tree.  Its filename is
     parse_integer-convert-mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse_integer-convert-mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse_integer-convert-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 mm/memtest.c    |    2 +-
 mm/page_alloc.c |    2 +-
 mm/shmem.c      |   14 ++++++++------
 4 files changed, 21 insertions(+), 16 deletions(-)

diff -puN mm/memcontrol.c~parse_integer-convert-mm mm/memcontrol.c
--- a/mm/memcontrol.c~parse_integer-convert-mm
+++ a/mm/memcontrol.c
@@ -4194,20 +4194,23 @@ static ssize_t memcg_write_event_control
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
+	ret = parse_integer(buf, 10, &efd);
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
@@ -94,7 +94,7 @@ static int memtest_pattern __initdata;
 static int __init parse_memtest(char *arg)
 {
 	if (arg)
-		memtest_pattern = simple_strtoul(arg, NULL, 0);
+		parse_integer(arg, 0, (unsigned int *)&memtest_pattern);
 	else
 		memtest_pattern = ARRAY_SIZE(patterns);
 
diff -puN mm/page_alloc.c~parse_integer-convert-mm mm/page_alloc.c
--- a/mm/page_alloc.c~parse_integer-convert-mm
+++ a/mm/page_alloc.c
@@ -6400,7 +6400,7 @@ static int __init set_hashdist(char *str
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
@@ -2736,6 +2736,7 @@ static int shmem_parse_options(char *opt
 	struct mempolicy *mpol = NULL;
 	uid_t uid;
 	gid_t gid;
+	int rv;
 
 	while (options != NULL) {
 		this_char = options;
@@ -2789,14 +2790,15 @@ static int shmem_parse_options(char *opt
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
@@ -2804,8 +2806,8 @@ static int shmem_parse_options(char *opt
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
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse-integer-rewrite-kstrto.patch
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch

