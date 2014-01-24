From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-attempt-to-find-missing-switch-case-break.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:51 -0800
Message-ID: <52e2b89f.sLRW+Do1hZzcPxDu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaAXTBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perche.com, jkosina@suse.cz, davej@redhat.com, benjamin.tissoires@redhat.com, apw@shadowen.org, joe@perches.com

Subject: [merged] checkpatch-attempt-to-find-missing-switch-case-break.patch removed from -mm tree
To: joe@perches.com,apw@shadowen.org,benjamin.tissoires@redhat.com,davej@redhat.com,jkosina@suse.cz,joe@perche.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:51 -0800


The patch titled
     Subject: checkpatch: attempt to find missing switch/case break;
has been removed from the -mm tree.  Its filename was
     checkpatch-attempt-to-find-missing-switch-case-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: attempt to find missing switch/case break;

switch case statements missing a break statement are an unfortunately
common error.

e.g.:
commit 4a2c94c9b6c0 ("HID: kye: Add report fixup for Genius Manticore Keyboard")

case blocks should end in a break/return/goto/continue.

If a fall-through is used, it should have a comment showing that it is
intentional.  Ideally that comment should be something like:
"/* fall-through */"

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
@@ -4128,6 +4128,31 @@ sub process {
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

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

