From: akpm@linux-foundation.org
Subject: + checkpatch-type-cast-spacing-should-not-check-prefix-spacing.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:24:05 -0800
Message-ID: <200901132224.n0DMO5pc027698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154AbZAMWYj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:24:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: type/cast spacing should not check prefix spacing
has been added to the -mm tree.  Its filename is
     checkpatch-type-cast-spacing-should-not-check-prefix-spacing.patch

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

sysrq-documentation-remove-the-redundant-updated-date.patch
sysrq-documentation-document-why-the-command-header-only-is-shown.patch
sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch
checkpatch-handle-missing-if-open-in-context.patch
checkpatch-type-cast-spacing-should-not-check-prefix-spacing.patch
checkpatch-allow-parentheses-on-return-handle-array-values.patch
checkpatch-if-should-not-continue-a-preceeding-brace.patch
checkpatch-struct-seq_operations-should-normally-be-const.patch
checkpatch-version-027.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

