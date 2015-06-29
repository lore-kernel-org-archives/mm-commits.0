From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-processing-of-memset-issues.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:51 -0700
Message-ID: <5591af33.4FQ4YyfSR4MYx+qh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbbF2Usw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusz.kulikowski@gmail.com, davem@davemloft.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix processing of MEMSET issues
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-processing-of-memset-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Subject: checkpatch: fix processing of MEMSET issues

Remove 's' modifier to avoid reporting the same warning several times.

Signed-off-by: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-processing-of-memset-issues scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-processing-of-memset-issues
+++ a/scripts/checkpatch.pl
@@ -5132,7 +5132,7 @@ sub process {
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
-		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*$FuncArg\s*\)/s) {
+		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*$FuncArg\s*\)/) {
 
 			my $ms_addr = $2;
 			my $ms_val = $7;
_

Patches currently in -mm which might be from mateusz.kulikowski@gmail.com are

origin.patch

