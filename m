From: akpm@linux-foundation.org
Subject: + checkpatch-suggest-pr_level-over-printkkern_level.patch added to -mm tree
Date: Tue, 13 Mar 2012 14:55:39 -0700
Message-ID: <20120313215539.F373DA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51826 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2CMVzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Mar 2012 17:55:42 -0400
Received: by wibhj13 with SMTP id hj13so54075wib.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Mar 2012 14:55:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@shadowen.org, tytso@mit.edu


The patch titled
     Subject: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>
has been added to the -mm tree.  Its filename is
     checkpatch-suggest-pr_level-over-printkkern_level.patch

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
Subject: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>

Suggest the shorter pr_<level> instead of printk(KERN_<LEVEL>.

Prefer to use pr_<level> over bare printks.
Prefer to use pr_warn over pr_warning.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-suggest-pr_level-over-printkkern_level scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suggest-pr_level-over-printkkern_level
+++ a/scripts/checkpatch.pl
@@ -2379,6 +2379,19 @@ sub process {
 			}
 		}
 
+		if ($line =~ /\bprintk\s*\(\s*KERN_([A-Z]+)/) {
+			my $orig = $1;
+			my $level = lc($orig);
+			$level = "warn" if ($level eq "warning");
+			WARN("PREFER_PR_LEVEL",
+			     "Prefer pr_$level(... to printk(KERN_$1, ...\n" . $herecurr);
+		}
+
+		if ($line =~ /\bpr_warning\s*\(/) {
+			WARN("PREFER_PR_LEVEL",
+			     "Prefer pr_warn(... to pr_warning(...\n" . $herecurr);
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
_
Subject: Subject: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
get_maintainerpl-add-support-for-moderated-lists.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatch-add-some-strict-coding-style-checks-v3.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch
checkpatch-add-strict-tests-for-braces-comments-and-casts.patch
checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch
checkpatch-warn-on-use-of-yield.patch
checkpatch-whitespace-add-remove-blank-lines.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

