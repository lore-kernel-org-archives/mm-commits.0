From: akpm@linux-foundation.org
Subject: + checkpatch-update-the-fsf-gpl-address-check.patch added to -mm
 tree
Date: Thu, 26 Dec 2013 14:16:14 -0800
Message-ID: <52bcaaae.3BMnjC5oGUgxL+Ex%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3LZWQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Dec 2013 17:16:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, josh@joshtriplett.org, apw@canonical.com, joe@perches.com

Subject: + checkpatch-update-the-fsf-gpl-address-check.patch added to -mm tree
To: joe@perches.com,apw@canonical.com,josh@joshtriplett.org,manfred@colorfullife.com
From: akpm@linux-foundation.org
Date: Thu, 26 Dec 2013 14:16:14 -0800


The patch titled
     Subject: checkpatch: update the FSF/GPL address check
has been added to the -mm tree.  Its filename is
     checkpatch-update-the-fsf-gpl-address-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-update-the-fsf-gpl-address-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-update-the-fsf-gpl-address-check.patch

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
Subject: checkpatch: update the FSF/GPL address check

The FSF address check is a bit too verbose looking for the GPL text. 
Quiet it a bit by requiring --strict for the GPL bit.

Also make the address tests match a few uses of abbreviations for street
names and make it case insensitive.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-the-fsf-gpl-address-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-the-fsf-gpl-address-check
+++ a/scripts/checkpatch.pl
@@ -1970,15 +1970,16 @@ sub process {
 		}
 
 # Check for FSF mailing addresses.
-		if ($rawline =~ /You should have received a copy/ ||
-		    $rawline =~ /write to the Free Software/ ||
-		    $rawline =~ /59 Temple Place/ ||
-		    $rawline =~ /51 Franklin Street/) {
+		if ($rawline =~ /\bYou should have received a copy/i ||
+		    $rawline =~ /\bwrite to the Free/i ||
+		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
+		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			my $msg_type = \&ERROR;
 			$msg_type = \&CHK if ($file);
+			$msg_type = \&CHK if ($rawline =~ /\bYou should have received a copy/i);
 			&{$msg_type}("FSF_MAILING_ADDRESS",
-				"Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
+				     "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
 		}
 
 # check for Kconfig help text having a real description
_

Patches currently in -mm which might be from joe@perches.com are

lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
checkpatch-attempt-to-find-missing-switch-case-break.patch
checkpatch-add-tests-for-function-pointer-style-misuses.patch
checkpatch-add-a-fix-inplace-option.patch
checkpatch-improve-space-before-tab-fix-option.patch
checkpatch-check-for-ifs-with-unnecessary-parentheses.patch
checkpatch-update-the-fsf-gpl-address-check.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

