From: akpm@linux-foundation.org
Subject: + checkpatch-fix-use-of-uninitialized-value-warnings.patch added
 to -mm tree
Date: Mon, 18 Nov 2013 14:47:38 -0800
Message-ID: <528a990a.AbBa412HbMTvfR5M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3KRWrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 17:47:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gsi@denx.de, apw@canonical.com, joe@perches.com

Subject: + checkpatch-fix-use-of-uninitialized-value-warnings.patch added to -mm tree
To: joe@perches.com,apw@canonical.com,gsi@denx.de
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 14:47:38 -0800


The patch titled
     Subject: checkpatch: fix "Use of uninitialized value" warnings
has been added to the -mm tree.  Its filename is
     checkpatch-fix-use-of-uninitialized-value-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-use-of-uninitialized-value-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-use-of-uninitialized-value-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: fix "Use of uninitialized value" warnings

checkpatch is currently confused about some complex macros and references
undefined variables $stat and $cond.

Make sure these are defined before using them.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Gerhard Sittig <gsi@denx.de>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-fix-use-of-uninitialized-value-warnings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-use-of-uninitialized-value-warnings
+++ a/scripts/checkpatch.pl
@@ -3289,6 +3289,7 @@ sub process {
 			}
 		}
 		if (!defined $suppress_whiletrailers{$linenr} &&
+		    defined($stat) && defined($cond) &&
 		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-fix-use-of-uninitialized-value-warnings.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
get_maintainerpl-incomplete-output.patch
linux-next.patch

