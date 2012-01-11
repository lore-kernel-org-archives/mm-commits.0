From: akpm@linux-foundation.org
Subject: [merged] checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:25 -0800
Message-ID: <20120111213126.13CE520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59532 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051Ab2AKVb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:27 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44333eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: complex macro should allow the empty do while loop
has been removed from the -mm tree.  Its filename was
     checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: complex macro should allow the empty do while loop

It is common to stub out a function as below, this is triggering a complex
macro format incorrectly.  Sort this out:

    #define cma_early_regions_reserve(reserve)   do { } while (0)

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-complex-macro-should-allow-the-empty-do-while-loop scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-complex-macro-should-allow-the-empty-do-while-loop
+++ a/scripts/checkpatch.pl
@@ -2838,7 +2838,7 @@ sub process {
 			    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&			# 10 // foo()
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
-			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;$/ &&	# do {...} while (...);
+			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&	# do {...} while (...); // do {...} while (...)
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
 			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()
 			    $dstat !~ /^do\s*{/ &&					# do {...
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

