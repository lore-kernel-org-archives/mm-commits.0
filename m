From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-exception-to-return-then-else-test.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:51 -0700
Message-ID: <543d6947.Sv2+viySM7yoZXQc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaJNSTu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, elshadimo@gmail.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add exception to return then else test
has been removed from the -mm tree.  Its filename was
     checkpatch-add-exception-to-return-then-else-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add exception to return then else test

Add an exception to the return before else warning
when the line following it is also a return like:

	if (foo)
		return bar;
	else
		return baz;

This form of a test then return is at least as readable as

	if (foo)
		return bar;
	return baz;

so don't emit a warning on the first form.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Elshad Mustafayev <elshadimo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-exception-to-return-then-else-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-exception-to-return-then-else-test
+++ a/scripts/checkpatch.pl
@@ -2641,10 +2641,14 @@ sub process {
 		next if ($realfile !~ /\.(h|c)$/);
 
 # check indentation of any line with a bare else
+# (but not if it is a multiple line "if (foo) return bar; else return baz;")
 # if the previous line is a break or return and is indented 1 tab more...
 		if ($sline =~ /^\+([\t]+)(?:}[ \t]*)?else(?:[ \t]*{)?\s*$/) {
 			my $tabs = length($1) + 1;
-			if ($prevline =~ /^\+\t{$tabs,$tabs}(?:break|return)\b/) {
+			if ($prevline =~ /^\+\t{$tabs,$tabs}break\b/ ||
+			    ($prevline =~ /^\+\t{$tabs,$tabs}return\b/ &&
+			     defined $lines[$linenr] &&
+			     $lines[$linenr] !~ /^[ \+]\t{$tabs,$tabs}return/)) {
 				WARN("UNNECESSARY_ELSE",
 				     "else is not generally useful after a break or return\n" . $hereprev);
 			}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

