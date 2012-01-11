From: akpm@linux-foundation.org
Subject: [merged] checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:18 -0800
Message-ID: <20120111213119.14EBB200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:44200 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051Ab2AKVbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:20 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so32631eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: only apply kconfig help checks for options which prompt
has been removed from the -mm tree.  Its filename was
     checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: only apply kconfig help checks for options which prompt

The intent of this check is to catch the options which the user will see
and ensure they are properly described.  It is also common for internal
only options to have a brief description.  Allow this form.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt
+++ a/scripts/checkpatch.pl
@@ -1674,19 +1674,26 @@ sub process {
 # Only applies when adding the entry originally, after that we do not have
 # sufficient context to determine whether it is indeed long enough.
 		if ($realfile =~ /Kconfig/ &&
-		    $line =~ /\+\s*(?:---)?help(?:---)?$/) {
+		    $line =~ /.\s*config\s+/) {
 			my $length = 0;
 			my $cnt = $realcnt;
 			my $ln = $linenr + 1;
 			my $f;
+			my $is_start = 0;
 			my $is_end = 0;
-			while ($cnt > 0 && defined $lines[$ln - 1]) {
+			for (; $cnt > 0 && defined $lines[$ln - 1]; $ln++) {
 				$f = $lines[$ln - 1];
 				$cnt-- if ($lines[$ln - 1] !~ /^-/);
 				$is_end = $lines[$ln - 1] =~ /^\+/;
-				$ln++;
 
 				next if ($f =~ /^-/);
+
+				if ($lines[$ln - 1] =~ /.\s*(?:bool|tristate)\s*\"/) {
+					$is_start = 1;
+				} elsif ($lines[$ln - 1] =~ /.\s*(?:---)?help(?:---)?$/) {
+					$length = -1;
+				}
+
 				$f =~ s/^.//;
 				$f =~ s/#.*//;
 				$f =~ s/^\s+//;
@@ -1698,8 +1705,8 @@ sub process {
 				$length++;
 			}
 			WARN("CONFIG_DESCRIPTION",
-			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_end && $length < 4);
-			#print "is_end<$is_end> length<$length>\n";
+			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);
+			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
 		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

