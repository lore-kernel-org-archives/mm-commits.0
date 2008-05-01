From: akpm@linux-foundation.org
Subject: + update-checkpatchpl-to-version-019-fix.patch added to -mm tree
Date: Thu, 01 May 2008 15:48:08 -0700
Message-ID: <200805012248.m41Mm8fa029411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbYEAWsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 18:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     update-checkpatchpl-to-version-019 fix
has been added to the -mm tree.  Its filename is
     update-checkpatchpl-to-version-019-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: update-checkpatchpl-to-version-019 fix
From: Andy Whitcroft <apw@shadowen.org>

return is not a function -- tighten test

Tighten the return is not a function test so that we only report it on
the line it occurs.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-019-fix scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-019-fix
+++ a/scripts/checkpatch.pl
@@ -1665,7 +1665,7 @@ sub process {
 		}
 
 # Return is not a function.
-		if (defined($stat) && $stat =~ /\breturn(\s*)(\(.*);/s) {
+		if (defined($stat) && $stat =~ /^.\s*return(\s*)(\(.*);/s) {
 			my $spacing = $1;
 			my $value = $2;
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
update-checkpatchpl-to-version-019.patch
update-checkpatchpl-to-version-019-fix.patch
page-owner-tracking-leak-detector.patch

