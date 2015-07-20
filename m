From: akpm@linux-foundation.org
Subject: + parse_integer-convert-fs-9p.patch added to -mm tree
Date: Mon, 20 Jul 2015 15:12:53 -0700
Message-ID: <55ad7265.goJi22jxliOBvL11%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbbGTWMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 18:12:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ericvh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert fs/9p/
has been added to the -mm tree.  Its filename is
     parse_integer-convert-fs-9p.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse_integer-convert-fs-9p.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse_integer-convert-fs-9p.patch

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
Subject: parse_integer: convert fs/9p/

Convert deprecated simple_strtoul() usage.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/v9fs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/9p/v9fs.c~parse_integer-convert-fs-9p fs/9p/v9fs.c
--- a/fs/9p/v9fs.c~parse_integer-convert-fs-9p
+++ a/fs/9p/v9fs.c
@@ -116,7 +116,7 @@ static int v9fs_parse_options(struct v9f
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
 	int option = 0;
-	char *s, *e;
+	char *s;
 	int ret = 0;
 
 	/* setup defaults */
@@ -269,8 +269,10 @@ static int v9fs_parse_options(struct v9f
 			} else {
 				uid_t uid;
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
-				uid = simple_strtoul(s, &e, 10);
-				if (*e != '\0') {
+				ret = parse_integer(s, 10, &uid);
+				if (ret < 0)
+					return ret;
+				if (s[ret] != '\0') {
 					ret = -EINVAL;
 					pr_info("Unknown access argument %s\n",
 						s);
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
parse_integer-convert-mm-fix.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch
parse_integer-convert-fs-9p.patch
parse_integer-add-checkpatchpl-notice.patch

