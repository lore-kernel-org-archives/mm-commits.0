From: akpm@linux-foundation.org
Subject: [nacked] parse_integer-convert-fs-9p.patch removed from -mm tree
Date: Thu, 10 Sep 2015 13:40:56 -0700
Message-ID: <55f1ead8.mL6OTuW5S4bpOM2d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbIJUk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 16:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ericvh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert fs/9p/
has been removed from the -mm tree.  Its filename was
     parse_integer-convert-fs-9p.patch

This patch was dropped because it was nacked

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
parse_integer-convert-fs-exofs.patch
proc-convert-to-kstrto-kstrto_from_user.patch
sound-convert-to-parse_integer.patch

