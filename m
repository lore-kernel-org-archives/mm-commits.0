From: akpm@linux-foundation.org
Subject: [merged] checkpatch-suggest-pr_level-over-printkkern_level.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:12 -0700
Message-ID: <20120601193312.59AF2A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41125 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab2FATdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:13 -0400
Received: by mail-vc0-f202.google.com with SMTP id fl13so245417vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>
has been removed from the -mm tree.  Its filename was
     checkpatch-suggest-pr_level-over-printkkern_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -2382,6 +2382,19 @@ sub process {
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

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

