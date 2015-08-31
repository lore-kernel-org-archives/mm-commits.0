From: akpm@linux-foundation.org
Subject: + checkpatch-add-constant-comparison-on-left-side-test.patch
 added to -mm tree
Date: Mon, 31 Aug 2015 16:07:01 -0700
Message-ID: <55e4de15.fQgFFL3vztCo1Ipw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbbHaXHC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Aug 2015 19:07:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, nmorey@kalray.eu, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add constant comparison on left side test
has been added to the -mm tree.  Its filename is
     checkpatch-add-constant-comparison-on-left-side-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-constant-comparison-on-left-side-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-constant-comparison-on-left-side-test.patch

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
Subject: checkpatch: add constant comparison on left side test

"CONST <comparison> variable" checks like:

        if (NULL != foo)
and
        while (0 < bar(...))

where a constant (or what appears to be a constant like an upper case
identifier) is on the left of a comparison are generally preferred to be
written using the constant on the right side like:

        if (foo != NULL)
and
        while (bar(...) > 0)

Add a test for this.

Add a --fix option too, but only do it when the code is immediately
surrounded by parentheses to avoid misfixing things like "(0 < bar() +
constant)"

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Nicolas Morey Chaisemartin <nmorey@kalray.eu>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-constant-comparison-on-left-side-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-constant-comparison-on-left-side-test
+++ a/scripts/checkpatch.pl
@@ -4231,6 +4231,35 @@ sub process {
 			}
 		}
 
+# comparisons with a constant or upper case identifier on the left
+#	avoid cases like "foo + BAR < baz"
+#	only fix matches surrounded by parentheses to avoid incorrect
+#	conversions like "FOO < baz() + 5" being "misfixed" to "baz() > FOO + 5"
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /^\+(.*)\b($Constant|[A-Z_][A-Z0-9_]*)\s*($Compare)\s*($LvalOrFunc)/) {
+			my $lead = $1;
+			my $const = $2;
+			my $comp = $3;
+			my $to = $4;
+			my $newcomp = $comp;
+			if ($lead !~ /$Operators\s*$/ &&
+			    $to !~ /^(?:Constant|[A-Z_][A-Z0-9_]*)$/ &&
+			    WARN("CONSTANT_COMPARISON",
+				 "Comparisons should place the constant on the right side of the test\n" . $herecurr) &&
+			    $fix) {
+				if ($comp eq "<") {
+					$newcomp = ">";
+				} elsif ($comp eq "<=") {
+					$newcomp = ">=";
+				} elsif ($comp eq ">") {
+					$newcomp = "<";
+				} elsif ($comp eq ">=") {
+					$newcomp = "<=";
+				}
+				$fixed[$fixlinenr] =~ s/\(\s*\Q$const\E\s*$Compare\s*\Q$to\E\s*\)/($to $newcomp $const)/;
+			}
+		}
+
 # Return of what appears to be an errno should normally be negative
 		if ($sline =~ /\breturn(?:\s*\(+\s*|\s+)(E[A-Z]+)(?:\s*\)+\s*|\s*)[;:,]/) {
 			my $name = $1;
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
cred-remove-unnecessary-kdebug-atomic-reads.patch
maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
checkpatch-add-warning-on-bug-bug_on-use.patch
checkpatch-improve-suspect_code_indent-test.patch
checkpatch-allow-longer-declaration-macros.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch
checkpatch-report-the-right-line-when-using-emacs-and-file.patch
checkpatch-always-check-block-comment-styles.patch
checkpatch-make-strict-the-default-for-drivers-staging-files-and-patches.patch
checkpatch-emit-an-error-on-formats-with-0x%decimal.patch
checkpatch-avoid-some-commit-message-long-line-warnings.patch
checkpatch-add-__pmem-to-sparse-annotations.patch
checkpatch-add-constant-comparison-on-left-side-test.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

