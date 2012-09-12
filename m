From: akpm@linux-foundation.org
Subject: + checkpatch-check-networking-specific-block-comment-style.patch added to -mm tree
Date: Wed, 12 Sep 2012 14:12:33 -0700
Message-ID: <20120912211233.990331E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:52366 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2ILVMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 17:12:34 -0400
Received: by yhl10 with SMTP id 10so243744yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 14:12:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, bruce.w.allan@intel.com, davem@davemloft.net


The patch titled
     Subject: checkpatch: check networking specific block comment style
has been added to the -mm tree.  Its filename is
     checkpatch-check-networking-specific-block-comment-style.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: check networking specific block comment style

In an effort to get fewer checkpatch reviewer corrections, add a
networking specific style test for the preferred networking comment style.

	/* The preferred style for block comments in
	 * drivers/net/... and net/... is like this
	 */

These tests are only used in net/ and drivers/net/

Tested with:

$ cat drivers/net/t.c

/* foo */

/*
 * foo
 */

/* foo
 */

/* foo
 * bar */
$ ./scripts/checkpatch.pl -f drivers/net/t.c
WARNING: networking block comments don't use an empty /* line, use /* Comment...
#4: FILE: net/t.c:4:
+
+/*

WARNING: networking block comments put the trailing */ on a separate line
#12: FILE: net/t.c:12:
+ * bar */

total: 0 errors, 2 warnings, 12 lines checked

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-networking-specific-block-comment-style scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-networking-specific-block-comment-style
+++ a/scripts/checkpatch.pl
@@ -1882,6 +1882,20 @@ sub process {
 			    "No space is necessary after a cast\n" . $hereprev);
 		}
 
+		if ($realfile =~ m@^(drivers/net/|net/)@ &&
+		    $rawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
+		    $prevrawline =~ /^\+[ \t]*$/) {
+			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
+			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
+		}
+
+		if ($realfile =~ m@^(drivers/net/|net/)@ &&
+		    $rawline !~ m@^\+[ \t]*(\/\*|\*\/)@ &&
+		    $rawline =~ m@^\+[ \t]*.+\*\/[ \t]*$@) {
+			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
+			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-gianfar_ptp-after-renaming.patch
checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset.patch
checkpatch-update-suggested-printk-conversions.patch
checkpatch-check-networking-specific-block-comment-style.patch
codingstyle-add-networking-specific-block-comment-style.patch

