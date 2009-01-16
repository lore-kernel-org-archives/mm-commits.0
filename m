From: akpm@linux-foundation.org
Subject: [merged] checkpatch-type-cast-spacing-should-not-check-prefix-spacing.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:10 -0800
Message-ID: <200901161917.n0GJHAq8025735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756520AbZAPTS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: type/cast spacing should not check prefix spacing
has been removed from the -mm tree.  Its filename was
     checkpatch-type-cast-spacing-should-not-check-prefix-spacing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: type/cast spacing should not check prefix spacing
From: Andy Whitcroft <apw@canonical.com>

We should not be complaining about the prefix spacing for types and casts.
 We are triggering here because the check for spacing between '*'s is
overly loose.  Tighten this up.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-type-cast-spacing-should-not-check-prefix-spacing scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-type-cast-spacing-should-not-check-prefix-spacing
+++ a/scripts/checkpatch.pl
@@ -1665,7 +1665,7 @@ sub process {
 			# Should not end with a space.
 			$to =~ s/\s+$//;
 			# '*'s should not have spaces between.
-			while ($to =~ s/(.)\s\*/$1\*/) {
+			while ($to =~ s/\*\s+\*/\*\*/) {
 			}
 
 			#print "from<$from> to<$to>\n";
@@ -1680,7 +1680,7 @@ sub process {
 			# Should not end with a space.
 			$to =~ s/\s+$//;
 			# '*'s should not have spaces between.
-			while ($to =~ s/(.)\s\*/$1\*/) {
+			while ($to =~ s/\*\s+\*/\*\*/) {
 			}
 			# Modifiers should have spaces.
 			$to =~ s/(\b$Modifier$)/$1 /;
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

