From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-use-of-uninitialized-value-warnings.patch removed from -mm tree
Date: Fri, 22 Nov 2013 13:21:46 -0800
Message-ID: <528fcaea.Pj9PCgfQSwq6GL/3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab3KVVVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:21:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gsi@denx.de, apw@canonical.com, joe@perches.com

Subject: [merged] checkpatch-fix-use-of-uninitialized-value-warnings.patch removed from -mm tree
To: joe@perches.com,apw@canonical.com,gsi@denx.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:21:46 -0800


The patch titled
     Subject: checkpatch: fix "Use of uninitialized value" warnings
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-use-of-uninitialized-value-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch
linux-next.patch

