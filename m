From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-macros-with-flow-control-statements.patch
 added to -mm tree
Date: Tue, 09 Sep 2014 16:22:17 -0700
Message-ID: <540f8ba9.4CI/8GXdgmQfbMF8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaIIXWS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Sep 2014 19:22:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on macros with flow control statements
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-macros-with-flow-control-statements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-macros-with-flow-control-statements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-macros-with-flow-control-statements.patch

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
Subject: checkpatch: warn on macros with flow control statements

Macros with flow control statements (goto and return) are not very nice to
read as any flow movement is unexpected.

Try to highlight them and emit a warning on their definition.

Avoid warning on macros that use argument concatenation as those macros
commonly create another function where the concatenation is used in the
function name definition like:

	#define FOO_FUNC(name, rtn_type)	\
	rtn_type func##name(arg1, ...)		\
	{					\
		rtn_type rtn;			\
		[code...]			\
		return rtn;			\
	}

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-macros-with-flow-control-statements scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-macros-with-flow-control-statements
+++ a/scripts/checkpatch.pl
@@ -4066,12 +4066,17 @@ sub process {
 			my $cnt = $realcnt;
 			my ($off, $dstat, $dcond, $rest);
 			my $ctx = '';
+			my $has_flow_statement = 0;
+			my $has_arg_concat = 0;
 			($dstat, $dcond, $ln, $cnt, $off) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$ctx = $dstat;
 			#print "dstat<$dstat> dcond<$dcond> cnt<$cnt> off<$off>\n";
 			#print "LINE<$lines[$ln-1]> len<" . length($lines[$ln-1]) . "\n";
 
+			$has_flow_statement = 1 if ($ctx =~ /\b(goto|return)\b/);
+			$has_arg_concat = 1 if ($ctx =~ /\#\#/);
+
 			$dstat =~ s/^.\s*\#\s*define\s+$Ident(?:\([^\)]*\))?\s*//;
 			$dstat =~ s/$;//g;
 			$dstat =~ s/\\\n.//g;
@@ -4136,6 +4141,19 @@ sub process {
 				}
 			}
 
+# check for macros with flow control, but without ## concatenation
+# ## concatenation is commonly a macro that defines a function so ignore those
+			if ($has_flow_statement && !$has_arg_concat) {
+				my $herectx = $here . "\n";
+				my $cnt = statement_rawlines($ctx);
+
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";
+				}
+				WARN("MACRO_WITH_FLOW_CONTROL",
+				     "Macros with flow control statements should be avoided\n" . "$herectx");
+			}
+
 # check for line continuations outside of #defines, preprocessor #, and asm
 
 		} else {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch
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
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch

