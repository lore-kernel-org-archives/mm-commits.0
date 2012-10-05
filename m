From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-networking-specific-block-comment-style.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:10 -0700
Message-ID: <20121005201610.7897F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64934 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2JEUQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:11 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so93875qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, bruce.w.allan@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check networking specific block comment style
has been removed from the -mm tree.  Its filename was
     checkpatch-check-networking-specific-block-comment-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

