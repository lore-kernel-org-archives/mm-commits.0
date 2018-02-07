From: akpm@linux-foundation.org
Subject: [merged] checkpatch-allow-long-lines-containing-url.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:57:26 -0800
Message-ID: <20180207195726.Tg7qHki_x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59642 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754422AbeBGT51 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:57:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.brauchli@elementarea.net, andreas.brauchli@sensirion.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow long lines containing URL
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-long-lines-containing-url.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andreas Brauchli <a.brauchli@elementarea.net>
Subject: checkpatch: allow long lines containing URL

Allow lines with URL to exceed the 80 char limit for improved interaction
in adaption to ongoing but undocumented practice.

$ git grep -E '://\S{77}.*' -- '*.[ch]'

As per RFC3986 [1], the URL format allows for alphanum, +, - and . 
characters in the scheme before the separator :// as long as it starts
with a letter (e.g.  https, git, f.-+).

Recognition of URIs without more context information is prone to false
positives and thus currently left out of the heuristics.

$rawline is used in the check as comments are removed from $line.

[1] https://tools.ietf.org/html/rfc3986#section-3.1

Link: http://lkml.kernel.org/r/1511355432.12667.15.camel@elementarea.net
Signed-off-by: Andreas Brauchli <andreas.brauchli@sensirion.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-allow-long-lines-containing-url scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-long-lines-containing-url
+++ a/scripts/checkpatch.pl
@@ -2875,6 +2875,7 @@ sub process {
 #	logging functions like pr_info that end in a string
 #	lines with a single string
 #	#defines that are a single string
+#	lines with an RFC3986 like URL
 #
 # There are 3 different line length message types:
 # LONG_LINE_COMMENT	a comment starts before but extends beyond $max_line_length
@@ -2906,6 +2907,10 @@ sub process {
 				 $line =~ /^\+\s*(?:\w+)?\s*DEFINE_PER_CPU/) {
 				$msg_type = "";
 
+			# URL ($rawline is used in case the URL is in a comment)
+			} elsif ($rawline =~ /^\+.*\b[a-z][\w\.\+\-]*:\/\/\S+/i) {
+				$msg_type = "";
+
 			# Otherwise set the alternate message types
 
 			# a comment starts before $max_line_length
_

Patches currently in -mm which might be from a.brauchli@elementarea.net are


