From: akpm@linux-foundation.org
Subject: [patch 021/114] checkpatch: remove obsolete
 CONFIG_EXPERIMENTAL checks
Date: Mon, 08 May 2017 15:55:33 -0700
Message-ID: <20170508225533.h5Fp7CAc5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbdEHWze (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org, mm-commits@vger.kernel.org, ruslan.bilovol@gmail.com, torvalds@linux-foundation.org

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
