From: akpm@linux-foundation.org
Subject: +
 checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen.patch added to
 -mm tree
Date: Tue, 21 Jan 2014 13:53:55 -0800
Message-ID: <52deec73.k29OI5WHffwvuF6U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbaAUVx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 16:53:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davem@davemloft.net, apw@canonical.com, joe@perches.com

Subject: + checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen.patch added to -mm tree
To: joe@perches.com,apw@canonical.com,davem@davemloft.net
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 13:53:55 -0800


The patch titled
     Subject: checkpatch: prefer ether_addr_copy to memcpy(foo, bar, ETH_ALEN)
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen.patch

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
Subject: checkpatch: prefer ether_addr_copy to memcpy(foo, bar, ETH_ALEN)

ether_addr_copy was added for kernel version 3.14.  It's slightly
smaller/faster for some arches.  Encourage its use.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen
+++ a/scripts/checkpatch.pl
@@ -4084,6 +4084,16 @@ sub process {
 			}
 		}
 
+# Check for memcpy(foo, bar, ETH_ALEN) that could be ether_addr_copy(foo, bar)
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /^\+(?:.*?)\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/s) {
+			if (WARN("PREFER_ETHER_ADDR_COPY",
+				 "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/ether_addr_copy($2, $7)/;
+			}
+		}
+
 # typecasts on min/max could be min_t/max_t
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
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
printk-flush-conflicting-continuation-line.patch
printk-flush-conflicting-continuation-line-fix.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
maintainers-describe-differences-between-f-and-n-patterns.patch
test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
checkpatch-attempt-to-find-missing-switch-case-break.patch
checkpatch-add-a-fix-inplace-option.patch
checkpatch-improve-space-before-tab-fix-option.patch
checkpatch-check-for-ifs-with-unnecessary-parentheses.patch
checkpatch-update-the-fsf-gpl-address-check.patch
checkpatch-add-tests-for-function-pointer-style-misuses.patch
checkpatch-only-flag-fsf-address-not-gnuorg-url.patch
checkpatch-add-dt-compatible-string-documentation-checks.patch
checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

