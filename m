From: akpm@linux-foundation.org
Subject: [to-be-updated]
 checkpatch-camelcase-ignore-si-unit-variants-like-_uv.patch removed from
 -mm tree
Date: Thu, 13 Jun 2013 14:10:19 -0700
Message-ID: <51ba353b.TlzEy+Prp1kCGnx4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677Ab3FMVKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 17:10:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, phil.carmody@partner.samsung.com, joe@perches.com

Subject: [to-be-updated] checkpatch-camelcase-ignore-si-unit-variants-like-_uv.patch removed from -mm tree
To: joe@perches.com,phil.carmody@partner.samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 14:10:19 -0700


The patch titled
     Subject: checkpatch: CamelCase - ignore SI unit variants like "_uV"
has been removed from the -mm tree.  Its filename was
     checkpatch-camelcase-ignore-si-unit-variants-like-_uv.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: CamelCase - ignore SI unit variants like "_uV"

Many existing variable names use SI like variants that should be otherwise
obvious and acceptable.

Whitelist them from the CamelCase message.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Phil Carmody <phil.carmody@partner.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-camelcase-ignore-si-unit-variants-like-_uv scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-camelcase-ignore-si-unit-variants-like-_uv
+++ a/scripts/checkpatch.pl
@@ -3195,7 +3195,10 @@ sub process {
 #CamelCase
 			if ($var !~ /^$Constant$/ &&
 			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
+#Ignore Page<foo> variants
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+#Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
+			    $var !~ /"_[a-z][A-Z](?:_\w+)?$/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				CHK("CAMELCASE",
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch
checkpatch-remove-quote-from-camelcase-test.patch
checkpatch-improve-network-block-comment-test-and-message.patch
checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch
checkpatch-warn-on-comparisons-to-jiffies.patch
checkpatch-warn-on-comparisons-to-get_jiffies_64.patch
checkpatch-reduce-false-positive-rate-of-complex-macros.patch
checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch
checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch
checkpatch-add-a-strict-test-for-comparison-to-true-false.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-create-an-experimental-fix-option-to-correct-patches.patch
checkpatch-move-test-for-space-before-semicolon-after-operator-spacing.patch

