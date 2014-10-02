From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-logging-functions-with-kern_level.patch
 added to -mm tree
Date: Thu, 02 Oct 2014 14:07:02 -0700
Message-ID: <542dbe76.RDHBiruUBYyOnv36%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaJBVHC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2014 17:07:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on logging functions with KERN_<LEVEL>
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-logging-functions-with-kern_level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-logging-functions-with-kern_level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-logging-functions-with-kern_level.patch

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
Subject: checkpatch: warn on logging functions with KERN_<LEVEL>

Warn on probable misuses of logging functions with KERN_<LEVEL>
like pr_err(KERN_ERR "foo\n");

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-logging-functions-with-kern_level scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-logging-functions-with-kern_level
+++ a/scripts/checkpatch.pl
@@ -4447,6 +4447,17 @@ sub process {
 			}
 		}
 
+# check for logging functions with KERN_<LEVEL>
+		if ($line !~ /printk\s*\(/ &&
+		    $line =~ /\b$logFunctions\s*\(.*\b(KERN_[A-Z]+)\b/) {
+			my $level = $1;
+			if (WARN("UNNECESSARY_KERN_LEVEL",
+				 "Possible unnecessary $level\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\s*$level\s*//;
+			}
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;
_

Patches currently in -mm which might be from joe@perches.com are

mm-utilc-add-kstrimdup.patch
checkpatch-fix-spello.patch
checkpatch-remove-debugging-message.patch
checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch
checkpatch-enable-whitespace-checks-for-dts-files.patch
checkpatch-allow-optional-shorter-config-descriptions.patch
checkpatch-allow-optional-shorter-config-descriptions-v4.patch
checkpatch-add-strict-test-for-concatenated-string-elements.patch
checkpatch-remove-unnecessary-after-88.patch
checkpatch-warn-on-macros-with-flow-control-statements.patch
checkpatch-look-for-common-misspellings.patch
checkpatch-add-exception-to-return-then-else-test.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-max77686-use-ffs-to-calculate-tm_wday.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
ipc-always-handle-a-new-value-of-auto_msgmni.patch
linux-next.patch
lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch

