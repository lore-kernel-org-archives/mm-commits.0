From: akpm@linux-foundation.org
Subject: [merged] checkpatch-warn-on-unnecessary-__devfoo-section-markings.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:45 -0800
Message-ID: <20130222204245.A53A531C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:46864 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:46 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so103899qcs.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on unnecessary __dev<foo> section markings
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-unnecessary-__devfoo-section-markings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn on unnecessary __dev<foo> section markings

Get people to stop adding __devinit and __devexit section markings.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-unnecessary-__devfoo-section-markings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-unnecessary-__devfoo-section-markings
+++ a/scripts/checkpatch.pl
@@ -1931,6 +1931,12 @@ sub process {
 			      "use the SSYNC() macro in asm/blackfin.h\n" . $herevet);
 		}
 
+# check for old HOTPLUG __dev<foo> section markings
+		if ($line =~ /\b(__dev(init|exit)(data|const|))\b/) {
+			WARN("HOTPLUG_SECTION",
+			     "Using $1 is unnecessary\n" . $herecurr);
+		}
+
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
get_maintainer-allow-keywords-to-match-filenames.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch

