From: akpm@linux-foundation.org
Subject: - update-checkpatchpl-to-version-019-fix.patch removed from -mm tree
Date: Thu, 05 Jun 2008 20:59:11 -0700
Message-ID: <200806060359.m563xCEf012208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643AbYFFD7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 23:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     update-checkpatchpl-to-version-019 fix
has been removed from the -mm tree.  Its filename was
     update-checkpatchpl-to-version-019-fix.patch

This patch was dropped because it was folded into update-checkpatchpl-to-version-019.patch

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

update-checkpatchpl-to-version-019.patch
update-checkpatchpl-to-version-019-fix.patch

