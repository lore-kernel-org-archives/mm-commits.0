From: akpm@linux-foundation.org
Subject: + checkpatch-check-camelcase-by-word-not-by-lval.patch added to
 -mm tree
Date: Wed, 24 Jul 2013 14:53:12 -0700
Message-ID: <51f04cc8.amX16oi6LwaqwLOw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3GXVxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 17:53:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-check-camelcase-by-word-not-by-lval.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 14:53:12 -0700


The patch titled
     Subject: checkpatch: check CamelCase by word, not by $Lval
has been added to the -mm tree.  Its filename is
     checkpatch-check-camelcase-by-word-not-by-lval.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-check-camelcase-by-word-not-by-lval.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-check-camelcase-by-word-not-by-lval.patch

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
Subject: checkpatch: check CamelCase by word, not by $Lval

$Lval is a test for complete name (ie: foo->bar.Baz[1])

If any of this is CamelCase, then the current test uses the entire $Lval. 
This isn't optimal because it can emit messages with foo->bar.Baz and
bar.Baz when Baz is a variable specified in an include file.

So instead, break the $Lval into words and check each word for CamelCase
uses.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-check-camelcase-by-word-not-by-lval scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-camelcase-by-word-not-by-lval
+++ a/scripts/checkpatch.pl
@@ -3302,11 +3302,15 @@ sub process {
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 #Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
 			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/) {
-				seed_camelcase_includes() if ($check);
-				if (!defined $camelcase{$var}) {
-					$camelcase{$var} = 1;
-					CHK("CAMELCASE",
-					    "Avoid CamelCase: <$var>\n" . $herecurr);
+				while ($var =~ m{($Ident)}g) {
+					my $word = $1;
+					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);
+					seed_camelcase_includes() if ($check);
+					if (!defined $camelcase{$word}) {
+						$camelcase{$word} = 1;
+						CHK("CAMELCASE",
+						    "Avoid CamelCase: <$word>\n" . $herecurr);
+					}
 				}
 			}
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-dynamic-debug-jasons-not-there.patch
printk-move-to-separate-directory-for-easier-modification.patch
printk-move-to-separate-directory-for-easier-modification-fix.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-gpio-vt8500-remove-file-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
linux-next.patch

