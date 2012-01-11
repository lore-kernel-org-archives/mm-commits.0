From: akpm@linux-foundation.org
Subject: [merged] checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:44 -0800
Message-ID: <20120111213144.A6F9D100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61363 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKVbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:45 -0500
Received: by ggnk3 with SMTP id k3so134903ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: catch all occurences of type and cast spacing errors per line
has been removed from the -mm tree.  Its filename was
     checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: catch all occurences of type and cast spacing errors per line

Fix up type and cast spacing checks such that all occurences on a line are
examined and reported.  For example the line below has a valid cast and a
bad type, but currently we check the cast first which is good and stop:

    u16* bar = (u16 *)baz;

We will also only report one of the errors in this example:

    u16* bar = (u16*)bad;

Move to iterating across all casts and all types, reporting any failure.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line
+++ a/scripts/checkpatch.pl
@@ -2209,8 +2209,9 @@ sub process {
 
 # * goes on variable not on type
 		# (char*[ const])
-		if ($line =~ m{\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\)}) {
-			my ($from, $to) = ($1, $1);
+		while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {
+			#print "AA<$1>\n";
+			my ($from, $to) = ($2, $2);
 
 			# Should start with a space.
 			$to =~ s/^(\S)/ $1/;
@@ -2225,8 +2226,10 @@ sub process {
 				ERROR("POINTER_LOCATION",
 				      "\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
 			}
-		} elsif ($line =~ m{\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident)}) {
-			my ($from, $to, $ident) = ($1, $1, $2);
+		}
+		while ($line =~ m{(\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident))}g) {
+			#print "BB<$1>\n";
+			my ($from, $to, $ident) = ($2, $2, $3);
 
 			# Should start with a space.
 			$to =~ s/^(\S)/ $1/;
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

