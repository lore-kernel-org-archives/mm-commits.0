From: akpm@linux-foundation.org
Subject: - checkpatch-toughen-trailing-if-statement-checks-and-extend-them-to-while-and-for.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:30 -0700
Message-ID: <200807242326.m6ONQUjU010984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832AbYGXX0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: toughen trailing if statement checks and extend them to while and for
has been removed from the -mm tree.  Its filename was
     checkpatch-toughen-trailing-if-statement-checks-and-extend-them-to-while-and-for.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: toughen trailing if statement checks and extend them to while and for
From: Andy Whitcroft <apw@shadowen.org>

Extend the trailing statement checks to report a trailing semi-colon ';'
as we really want it on the next line and indented so it is really really
obvious.  Also extend the tests to include while and for.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-toughen-trailing-if-statement-checks-and-extend-them-to-while-and-for scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-toughen-trailing-if-statement-checks-and-extend-them-to-while-and-for
+++ a/scripts/checkpatch.pl
@@ -1269,8 +1269,8 @@ sub process {
 				$ctx_ln++;
 			}
 
-			##print "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
-			##print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
+			#print "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
+			#print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
 
 			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
 				ERROR("that open brace { should be on the previous line\n" .
@@ -1713,7 +1713,7 @@ sub process {
 		}
 
 # Check for illegal assignment in if conditional.
-		if ($line =~ /\bif\s*\(/) {
+		if ($line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/) {
@@ -1725,8 +1725,8 @@ sub process {
 			substr($s, 0, length($c), '');
 			$s =~ s/\n.*//g;
 			$s =~ s/$;//g; 	# Remove any comments
-			if (length($c) && $s !~ /^\s*({|;|)\s*\\*\s*$/ &&
-			    $c !~ /^.\s*\#\s*if/)
+			if (length($c) && $s !~ /^\s*{?\s*\\*\s*$/ &&
+			    $c !~ /}\s*while\s*/)
 			{
 				ERROR("trailing statements should be on next line\n" . $herecurr);
 			}
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

