From: akpm@linux-foundation.org
Subject: [merged] checkpatch-prefer-dev_level-to-dev_printkkern_level.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:48 -0800
Message-ID: <20130222204248.A39FF5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:45555 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab3BVUmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:49 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so103926vch.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prefer dev_<level>( to dev_printk(KERN_<LEVEL>
has been removed from the -mm tree.  Its filename was
     checkpatch-prefer-dev_level-to-dev_printkkern_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: prefer dev_<level>( to dev_printk(KERN_<LEVEL>

Add YA check to printk style.

dev_<level> uses are functions and generate smaller
object code than dev_printk(KERN_<LEVEL>.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-prefer-dev_level-to-dev_printkkern_level scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prefer-dev_level-to-dev_printkkern_level
+++ a/scripts/checkpatch.pl
@@ -2430,6 +2430,15 @@ sub process {
 			     "Prefer pr_warn(... to pr_warning(...\n" . $herecurr);
 		}
 
+		if ($line =~ /\bdev_printk\s*\(\s*KERN_([A-Z]+)/) {
+			my $orig = $1;
+			my $level = lc($orig);
+			$level = "warn" if ($level eq "warning");
+			$level = "dbg" if ($level eq "debug");
+			WARN("PREFER_DEV_LEVEL",
+			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
get_maintainer-allow-keywords-to-match-filenames.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch

