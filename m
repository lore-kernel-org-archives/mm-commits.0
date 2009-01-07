From: akpm@linux-foundation.org
Subject: - checkpatch-structure-member-assignments-are-not-complex.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:35 -0800
Message-ID: <200901072216.n07MGZBI016317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761594AbZAGWQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: structure member assignments are not complex
has been removed from the -mm tree.  Its filename was
     checkpatch-structure-member-assignments-are-not-complex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: structure member assignments are not complex
From: Andy Whitcroft <apw@shadowen.org>

Ensure we do not trigger the complex macros checks on structure member
assignment, for example:

	#define foo .bar = 10

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-structure-member-assignments-are-not-complex scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-structure-member-assignments-are-not-complex
+++ a/scripts/checkpatch.pl
@@ -2167,9 +2167,10 @@ sub process {
 				MODULE_PARAM_DESC|
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
-				__typeof__\(
+				__typeof__\(|
+				\.$Ident\s*=\s*
 			}x;
-			#print "REST<$rest>\n";
+			#print "REST<$rest> dstat<$dstat>\n";
 			if ($rest ne '') {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch

