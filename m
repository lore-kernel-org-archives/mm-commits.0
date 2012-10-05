From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:03 -0700
Message-ID: <20121005201603.B10061E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62099 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2JEUQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:04 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so235203ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasi.savanainen@nixu.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check utf-8 content from a commit log when it's missing from charset
has been removed from the -mm tree.  Its filename was
     checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pasi Savanainen <pasi.savanainen@nixu.com>
Subject: checkpatch: check utf-8 content from a commit log when it's missing from charset

Check that a commit log doesn't contain UTF-8 when a mail header
explicitly defines a different charset, like

'Content-Type: text/plain; charset="us-ascii"'

Signed-off-by: Pasi Savanainen <pasi.savanainen@nixu.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset
+++ a/scripts/checkpatch.pl
@@ -1386,6 +1386,8 @@ sub process {
 	my $in_header_lines = 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
 
+	my $non_utf8_charset = 0;
+
 	our @report = ();
 	our $cnt_lines = 0;
 	our $cnt_error = 0;
@@ -1686,10 +1688,17 @@ sub process {
 			$in_commit_log = 1;
 		}
 
-# Still not yet in a patch, check for any UTF-8
-		if ($in_commit_log && $realfile =~ /^$/ &&
+# Check if there is UTF-8 in a commit log when a mail header has explicitly
+# declined it, i.e defined some charset where it is missing.
+		if ($in_header_lines &&
+		    $rawline =~ /^Content-Type:.+charset="(.+)".*$/ &&
+		    $1 !~ /utf-8/i) {
+			$non_utf8_charset = 1;
+		}
+
+		if ($in_commit_log && $non_utf8_charset && $realfile =~ /^$/ &&
 		    $rawline =~ /$NON_ASCII_UTF8/) {
-			CHK("UTF8_BEFORE_PATCH",
+			WARN("UTF8_BEFORE_PATCH",
 			    "8-bit UTF-8 used in possible commit log\n" . $herecurr);
 		}
 
_

Patches currently in -mm which might be from pasi.savanainen@nixu.com are

origin.patch

