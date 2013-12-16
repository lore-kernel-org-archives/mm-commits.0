From: akpm@linux-foundation.org
Subject: + checkpatch-attempt-to-find-missing-switch-case-break.patch
 added to -mm tree
Date: Mon, 16 Dec 2013 11:55:56 -0800
Message-ID: <52af5acc.0KXm+HW7wqomzToS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3LPT4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:56:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perche.com, jkosina@suse.cz, davej@redhat.com, benjamin.tissoires@redhat.com, apw@shadowen.org, joe@perches.com

Subject: + checkpatch-attempt-to-find-missing-switch-case-break.patch added to -mm tree
To: joe@perches.com,apw@shadowen.org,benjamin.tissoires@redhat.com,davej@redhat.com,jkosina@suse.cz,joe@perche.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:56 -0800


The patch titled
     Subject: checkpatch: attempt to find missing switch/case break;
has been added to the -mm tree.  Its filename is
     checkpatch-attempt-to-find-missing-switch-case-break.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-attempt-to-find-missing-switch-case-break.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-attempt-to-find-missing-switch-case-break.patch

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
Subject: checkpatch: attempt to find missing switch/case break;

switch case statements missing a break statement are an unfortunately
common error.

e.g.:
commit 4a2c94c9b6c0 ("HID: kye: Add report fixup for Genius Manticore Keyboard")

case blocks should end in a break/return/goto/continue.

If a fall-through is used, it should have a comment showing that it is
intentional.  Ideally that comment should be something like: "/*
fall-through */"

Add a test to look for missing break statements.

This looks only at the context lines before an inserted case so it's
possible to have false positives when the context contains a close brace
and the break is before the brace and not part of the patch context.

Looking at recent patches, this is a pretty rare occurrence.  The normal
kernel style uses a break as the last line of the previous block.

Signed-off-by: Joe Perches <joe@perche.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-attempt-to-find-missing-switch-case-break scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-attempt-to-find-missing-switch-case-break
+++ a/scripts/checkpatch.pl
@@ -4134,6 +4134,31 @@ sub process {
 			}
 		}
 
+# check for case / default statements not preceeded by break/fallthrough/switch
+		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
+			my $has_break = 0;
+			my $has_statement = 0;
+			my $count = 0;
+			my $prevline = $linenr;
+			while ($prevline > 1 && $count < 3 && !$has_break) {
+				$prevline--;
+				my $rline = $rawlines[$prevline - 1];
+				my $fline = $lines[$prevline - 1];
+				last if ($fline =~ /^\@\@/);
+				next if ($fline =~ /^\-/);
+				next if ($fline =~ /^.(?:\s*(?:case\s+(?:$Ident|$Constant)[\s$;]*|default):[\s$;]*)*$/);
+				$has_break = 1 if ($rline =~ /fall[\s_-]*(through|thru)/i);
+				next if ($fline =~ /^.[\s$;]*$/);
+				$has_statement = 1;
+				$count++;
+				$has_break = 1 if ($fline =~ /\bswitch\b|\b(?:break\s*;[\s$;]*$|return\b|goto\b|continue\b)/);
+			}
+			if (!$has_break && $has_statement) {
+				WARN("MISSING_BREAK",
+				     "Possible switch case/default not preceeded by break or fallthrough comment\n" . $herecurr);
+			}
+		}
+
 # check for switch/default statements without a break;
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
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
checkpatchpl-check-for-function-declarations-without-arguments.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
checkpatch-attempt-to-find-missing-switch-case-break.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch

