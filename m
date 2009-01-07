From: akpm@linux-foundation.org
Subject: - checkpatch-fix-continuation-detection-when-handling-spacing-on-operators.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:00 -0800
Message-ID: <200901072217.n07MH0Bx016659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762068AbZAGWRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: fix continuation detection when handling spacing on operators
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-continuation-detection-when-handling-spacing-on-operators.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: fix continuation detection when handling spacing on operators
From: Andy Whitcroft <apw@canonical.com>

We are miscategorising a continuation fragment following an operator
which may lead to us thinking that there is a space after it when there is
not.  Fix this up.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-continuation-detection-when-handling-spacing-on-operators scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-continuation-detection-when-handling-spacing-on-operators
+++ a/scripts/checkpatch.pl
@@ -1793,7 +1793,7 @@ sub process {
 					$c = 'C' if ($elements[$n + 2] =~ /^$;/);
 					$c = 'B' if ($elements[$n + 2] =~ /^(\)|\]|;)/);
 					$c = 'O' if ($elements[$n + 2] eq '');
-					$c = 'E' if ($elements[$n + 2] =~ /\s*\\$/);
+					$c = 'E' if ($elements[$n + 2] =~ /^\s*\\$/);
 				} else {
 					$c = 'E';
 				}
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch

