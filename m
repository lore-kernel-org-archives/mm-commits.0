From: akpm@linux-foundation.org
Subject: + checkpatch-handle-c99-comments-correctly-performance-issue.patch added to -mm tree
Date: Fri, 21 Aug 2009 15:24:53 -0700
Message-ID: <200908212224.n7LMOrsd015823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932390AbZHUWY4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 18:24:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@fifo99.com, apw@canonical.com


The patch titled
     checkpatch: handle C99 comments correctly (performance issue)
has been added to the -mm tree.  Its filename is
     checkpatch-handle-c99-comments-correctly-performance-issue.patch

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
Subject: checkpatch: handle C99 comments correctly (performance issue)
From: Daniel Walker <dwalker@fifo99.com>

This fixes the sanitation process in checkpatch.pl so that it blocks out
the text after a C99 style comment the same way it does with block style
comments.  This prevents the text from getting processed as regular code.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-handle-c99-comments-correctly-performance-issue scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-handle-c99-comments-correctly-performance-issue
+++ a/scripts/checkpatch.pl
@@ -356,6 +356,13 @@ sub sanitise_line {
 			$off++;
 			next;
 		}
+		if ($sanitise_quote eq '' && substr($line, $off, 2) eq '//') {
+			$sanitise_quote = '//';
+
+			substr($res, $off, 2, $sanitise_quote);
+			$off++;
+			next;
+		}
 
 		# A \ in a string means ignore the next character.
 		if (($sanitise_quote eq "'" || $sanitise_quote eq '"') &&
@@ -379,6 +386,8 @@ sub sanitise_line {
 		#print "c<$c> SQ<$sanitise_quote>\n";
 		if ($off != 0 && $sanitise_quote eq '*/' && $c ne "\t") {
 			substr($res, $off, 1, $;);
+		} elsif ($off != 0 && $sanitise_quote eq '//' && $c ne "\t") {
+			substr($res, $off, 1, $;);
 		} elsif ($off != 0 && $sanitise_quote && $c ne "\t") {
 			substr($res, $off, 1, 'X');
 		} else {
@@ -386,6 +395,10 @@ sub sanitise_line {
 		}
 	}
 
+	if ($sanitise_quote eq '//') {
+		$sanitise_quote = '';
+	}
+
 	# The pathname on a #include may be surrounded by '<' and '>'.
 	if ($res =~ /^.\s*\#\s*include\s+\<(.*)\>/) {
 		my $clean = 'X' x length($1);
_

Patches currently in -mm which might be from dwalker@fifo99.com are

linux-next.patch
checkpatch-handle-c99-comments-correctly-performance-issue.patch

