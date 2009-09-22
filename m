From: akpm@linux-foundation.org
Subject: [merged] checkpatch-possible-types-else-cannot-start-a-type.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:47 -0700
Message-ID: <200909222045.n8MKjlRF016419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbZIVUqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: possible types -- else cannot start a type
has been removed from the -mm tree.  Its filename was
     checkpatch-possible-types-else-cannot-start-a-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: possible types -- else cannot start a type
From: Andy Whitcroft <apw@canonical.com>

An else cannot start a type, it would have to be within a block after the
else.  This can trigger false modifier matching.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-possible-types-else-cannot-start-a-type scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-possible-types-else-cannot-start-a-type
+++ a/scripts/checkpatch.pl
@@ -1372,6 +1372,8 @@ sub process {
 			# Ignore functions being called
 			} elsif ($s =~ /^.\s*$Ident\s*\(/s) {
 
+			} elsif ($s =~ /^.\s*else\b/s) {
+
 			# declarations always start with types
 			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?((?:\s*$Ident)+?)\b(?:\s+$Sparse)?\s*\**\s*(?:$Ident|\(\*[^\)]*\))(?:\s*$Modifier)?\s*(?:;|=|,|\()/s) {
 				my $type = $1;
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

