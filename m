From: akpm@linux-foundation.org
Subject: + checkpatch-add-exception-to-return-then-else-test.patch added
 to -mm tree
Date: Thu, 25 Sep 2014 13:36:28 -0700
Message-ID: <54247ccc.wsCBHh/ZxasWXHc6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaIYUg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 16:36:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, elshadimo@gmail.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add exception to return then else test
has been added to the -mm tree.  Its filename is
     checkpatch-add-exception-to-return-then-else-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-exception-to-return-then-else-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-exception-to-return-then-else-test.patch

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
Subject: checkpatch: add exception to return then else test

Add an exception to the return before else warning
when the line following it is also a return like:

	if (foo)
		return bar;
	else
		return baz;

This form of a test then return is at least as readable as

	if (foo)
		return bar;
	return baz;

so don't emit a warning on the first form.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Elshad Mustafayev <elshadimo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-exception-to-return-then-else-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-exception-to-return-then-else-test
+++ a/scripts/checkpatch.pl
@@ -2641,10 +2641,14 @@ sub process {
 		next if ($realfile !~ /\.(h|c)$/);
 
 # check indentation of any line with a bare else
+# (but not if it is a multiple line "if (foo) return bar; else return baz;")
 # if the previous line is a break or return and is indented 1 tab more...
 		if ($sline =~ /^\+([\t]+)(?:}[ \t]*)?else(?:[ \t]*{)?\s*$/) {
 			my $tabs = length($1) + 1;
-			if ($prevline =~ /^\+\t{$tabs,$tabs}(?:break|return)\b/) {
+			if ($prevline =~ /^\+\t{$tabs,$tabs}break\b/ ||
+			    ($prevline =~ /^\+\t{$tabs,$tabs}return\b/ &&
+			     defined $lines[$linenr] &&
+			     $lines[$linenr] !~ /^[ \+]\t{$tabs,$tabs}return/)) {
 				WARN("UNNECESSARY_ELSE",
 				     "else is not generally useful after a break or return\n" . $hereprev);
 			}
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

