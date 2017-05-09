From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-remove-obsolete-config_experimental-checks.patch removed from
 -mm tree
Date: Tue, 09 May 2017 11:01:04 -0700
Message-ID: <20170509180104.l90EgFm36%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753901AbdEISBF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:01:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, keescook@chromium.org, mm-commits@vger.kernel.org, ruslan.bilovol@gmail.com


The patch titled
     Subject: checkpatch: remove obsolete CONFIG_EXPERIMENTAL checks
has been removed from the -mm tree.  Its filename was
     checkpatch-remove-obsolete-config_experimental-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Subject: checkpatch: remove obsolete CONFIG_EXPERIMENTAL checks

Config EXPERIMENTAL has been removed from kernel in 2013 (see 3d374d0:
"final removal of CONFIG_EXPERIMENTAL"), there is no any reason to do
these checks now.

Link: http://lkml.kernel.org/r/1488234097-20119-1-git-send-email-ruslan.bilovol@gmail.com
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-remove-obsolete-config_experimental-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-remove-obsolete-config_experimental-checks
+++ a/scripts/checkpatch.pl
@@ -2757,13 +2757,6 @@ sub process {
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
-# discourage the addition of CONFIG_EXPERIMENTAL in Kconfig.
-		if ($realfile =~ /Kconfig/ &&
-		    $line =~ /.\s*depends on\s+.*\bEXPERIMENTAL\b/) {
-			WARN("CONFIG_EXPERIMENTAL",
-			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
-		}
-
 # discourage the use of boolean for type definition attributes of Kconfig options
 		if ($realfile =~ /Kconfig/ &&
 		    $line =~ /^\+\s*\bboolean\b/) {
@@ -3157,12 +3150,6 @@ sub process {
 			}
 		}
 
-# discourage the addition of CONFIG_EXPERIMENTAL in #if(def).
-		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_EXPERIMENTAL\b/) {
-			WARN("CONFIG_EXPERIMENTAL",
-			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
-		}
