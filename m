From: akpm@linux-foundation.org
Subject: + checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset.patch added to -mm tree
Date: Tue, 11 Sep 2012 14:50:14 -0700
Message-ID: <20120911215014.A7673100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43957 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2IKVuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 17:50:16 -0400
Received: by qafl39 with SMTP id l39so125052qaf.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 14:50:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pasi.savanainen@nixu.com, apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: check utf-8 content from a commit log when it's missing from charset
has been added to the -mm tree.  Its filename is
     checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset.patch

