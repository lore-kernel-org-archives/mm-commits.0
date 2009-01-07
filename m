From: akpm@linux-foundation.org
Subject: - checkpatch-loosen-spacing-on-typedef-function-checks.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:56 -0800
Message-ID: <200901072216.n07MGupH016605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762001AbZAGWQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: loosen spacing on typedef function checks
has been removed from the -mm tree.  Its filename was
     checkpatch-loosen-spacing-on-typedef-function-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: loosen spacing on typedef function checks
From: Andy Whitcroft <apw@canonical.com>

Loosen spacing checks to correctly detect this valid use of a typedef:

	typedef struct rcu_data *(*get_data_func)(int);

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-loosen-spacing-on-typedef-function-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-loosen-spacing-on-typedef-function-checks
+++ a/scripts/checkpatch.pl
@@ -1618,7 +1618,7 @@ sub process {
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&
-		    $line !~ /\btypedef\s+$Type\s+\(\s*\*?$Ident\s*\)\s*\(/ &&
+		    $line !~ /\btypedef\s+$Type\s*\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
 		    $line !~ /\b$typeTypedefs\b/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch

