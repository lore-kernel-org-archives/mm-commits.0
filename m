From: akpm@linux-foundation.org
Subject: + parse_integer-convert-fs-exofs.patch added to -mm tree
Date: Mon, 20 Jul 2015 15:17:35 -0700
Message-ID: <55ad737f.Z8QJBePygHLvtzpJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbbGTWRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 18:17:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, bhalevy@primarydata.com, ooo@electrozaur.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert fs/exofs/
has been added to the -mm tree.  Its filename is
     parse_integer-convert-fs-exofs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse_integer-convert-fs-exofs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse_integer-convert-fs-exofs.patch

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
Subject: parse_integer: convert fs/exofs/

Convert deprecated simple_strtoull() usage.

Copying option string is unnecessary as you can parse directly
from the original string.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Boaz Harrosh <ooo@electrozaur.com>
Cc: Benny Halevy <bhalevy@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exofs/super.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/exofs/super.c~parse_integer-convert-fs-exofs fs/exofs/super.c
--- a/fs/exofs/super.c~parse_integer-convert-fs-exofs
+++ a/fs/exofs/super.c
@@ -84,6 +84,7 @@ static int parse_options(char *options,
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 	bool s_pid = false;
+	int rv;
 
 	EXOFS_DBGMSG("parse_options %s\n", options);
 	/* defaults */
@@ -92,7 +93,6 @@ static int parse_options(char *options,
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
-		char str[32];
 
 		if (!*p)
 			continue;
@@ -108,9 +108,11 @@ static int parse_options(char *options,
 			opts->is_osdname = true;
 			break;
 		case Opt_pid:
-			if (0 == match_strlcpy(str, &args[0], sizeof(str)))
+			rv = parse_integer(args[0].from, 0, &opts->pid);
+			if (rv < 0)
+				return rv;
+			if (args[0].from[rv] != '\0')
 				return -EINVAL;
-			opts->pid = simple_strtoull(str, NULL, 0);
 			if (opts->pid < EXOFS_MIN_PID) {
 				EXOFS_ERR("Partition ID must be >= %u",
 					  EXOFS_MIN_PID);
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
parse_integer-convert-fs-exofs.patch
parse_integer-add-checkpatchpl-notice.patch

