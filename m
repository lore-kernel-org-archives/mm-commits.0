From: akpm@linux-foundation.org
Subject: +
 checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch added
 to -mm tree
Date: Wed, 04 Dec 2013 14:18:59 -0800
Message-ID: <529faa53.M+Ev2A3GGW4jFqM1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3LDWTA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Dec 2013 17:19:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com, joe@perches.com

Subject: + checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch added to -mm tree
To: joe@perches.com,dan.carpenter@oracle.com
From: akpm@linux-foundation.org
Date: Wed, 04 Dec 2013 14:18:59 -0800


The patch titled
     Subject: checkpatch: warn only on "space before semicolon" at end of line
has been added to the -mm tree.  Its filename is
     checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch

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
Subject: checkpatch: warn only on "space before semicolon" at end of line

The "space before a non-naked semicolon" test has unwanted output when
used in "for ( ;; )" loops.

Make the test work only on end-of-line statement
termination semicolons.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-warn-only-on-space-before-semicolon-at-end-of-line scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-only-on-space-before-semicolon-at-end-of-line
+++ a/scripts/checkpatch.pl
@@ -3127,7 +3127,7 @@ sub process {
 		}
 
 # check for whitespace before a non-naked semicolon
-		if ($line =~ /^\+.*\S\s+;/) {
+		if ($line =~ /^\+.*\S\s+;\s*$/) {
 			if (WARN("SPACING",
 				 "space prohibited before semicolon\n" . $herecurr) &&
 			    $fix) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
linux-next.patch

