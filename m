From: akpm@linux-foundation.org
Subject: + checkpatch-check-for-incorrect-permissions.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:29 -0700
Message-ID: <201008182025.o7IKPTCl010351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171Ab0HRUby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rabin.vincent@stericsson.com, apw@canonical.com, linus.walleij@stericsson.com


The patch titled
     checkpatch: check for incorrect permissions
has been added to the -mm tree.  Its filename is
     checkpatch-check-for-incorrect-permissions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: check for incorrect permissions
From: Rabin Vincent <rabin.vincent@stericsson.com>

Throw an error when a source file has been given execute permissions using
the mode change line present in git diffs.  Also alow the filename
matching to use the "diff" line in addition to the "+++" line, since the
mode change lines appear before any "+++" lines.

[apw@canonical.com: simplified filename logic slightly, added tests]
Cc: Andy Whitcroft <apw@canonical.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-check-for-incorrect-permissions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-for-incorrect-permissions
+++ a/scripts/checkpatch.pl
@@ -1315,7 +1315,11 @@ sub process {
 		$here = "#$realline: " if ($file);
 
 		# extract the filename as it passes
-		if ($line=~/^\+\+\+\s+(\S+)/) {
+		if ($line =~ /^diff --git.*?(\S+)$/) {
+			$realfile = $1;
+			$realfile =~ s@^([^/]*)/@@;
+
+		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
 
@@ -1339,6 +1343,14 @@ sub process {
 
 		$cnt_lines++ if ($realcnt != 0);
 
+# Check for incorrect file permissions
+		if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
+			my $permhere = $here . "FILE: $realfile\n";
+			if ($realfile =~ /(Makefile|Kconfig|\.c|\.h|\.S|\.tmpl)$/) {
+				ERROR("do not set execute permissions for source files\n" . $permhere);
+			}
+		}
+
 #check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			# This is a signoff, if ugly, so do not double report.
_

Patches currently in -mm which might be from rabin.vincent@stericsson.com are

linux-next.patch
checkpatch-check-for-incorrect-permissions.patch

