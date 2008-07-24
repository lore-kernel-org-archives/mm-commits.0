From: akpm@linux-foundation.org
Subject: - checkpatch-trailing-statement-indent-fix-end-of-statement-location.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:24 -0700
Message-ID: <200807242326.m6ONQOYU010975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755883AbYGXX0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: trailing statement indent: fix end of statement location
has been removed from the -mm tree.  Its filename was
     checkpatch-trailing-statement-indent-fix-end-of-statement-location.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: trailing statement indent: fix end of statement location
From: Andy Whitcroft <apw@shadowen.org>

Fix end of statement location.  Where the last line of the statement is
replaced we are miss reporting the newly added replacement an incorrectly
indented trailing statement for the negative context.  We are also
incorrectly reporting negative statements generally.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-trailing-statement-indent-fix-end-of-statement-location scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-trailing-statement-indent-fix-end-of-statement-location
+++ a/scripts/checkpatch.pl
@@ -1249,17 +1249,22 @@ sub process {
 			my $pre_ctx = "$1$2";
 
 			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
-			my $ctx_ln = $linenr + $#ctx + 1;
 			my $ctx_cnt = $realcnt - $#ctx - 1;
 			my $ctx = join("\n", @ctx);
 
-			##warn "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
+			my $ctx_ln = $linenr;
+			my $ctx_skip = $realcnt;
 
-			# Skip over any removed lines in the context following statement.
-			while (defined($lines[$ctx_ln - 1]) && $lines[$ctx_ln - 1] =~ /^-/) {
+			while ($ctx_skip > $ctx_cnt || ($ctx_skip == $ctx_cnt &&
+					defined $lines[$ctx_ln - 1] &&
+					$lines[$ctx_ln - 1] =~ /^-/)) {
+				##print "SKIP<$ctx_skip> CNT<$ctx_cnt>\n";
+				$ctx_skip-- if (!defined $lines[$ctx_ln - 1] || $lines[$ctx_ln - 1] !~ /^-/);
 				$ctx_ln++;
 			}
-			##warn "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
+
+			##print "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
+			##print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
 
 			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
 				ERROR("that open brace { should be on the previous line\n" .
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

