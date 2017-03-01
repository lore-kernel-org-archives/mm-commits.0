From: akpm@linux-foundation.org
Subject: + checkpatch-remove-obsolete-config_experimental-checks.patch
 added to -mm tree
Date: Tue, 28 Feb 2017 16:01:28 -0800
Message-ID: <58b60f58.eXTEG1FzS1R1eMV5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40936 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdCAA6b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 19:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ruslan.bilovol@gmail.com, joe@perches.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove obsolete CONFIG_EXPERIMENTAL checks
has been added to the -mm tree.  Its filename is
     checkpatch-remove-obsolete-config_experimental-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-remove-obsolete-config_experimental-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-remove-obsolete-config_experimental-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
