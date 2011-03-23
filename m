From: akpm@linux-foundation.org
Subject: [merged] scripts-checkpatchpl-reset-rpt_cleaners-warnings.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:22 -0700
Message-ID: <201103232043.p2NKhwot029008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933459Ab1CWUoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     scripts/checkpatch.pl: reset rpt_cleaners warnings
has been removed from the -mm tree.  Its filename was
     scripts-checkpatchpl-reset-rpt_cleaners-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/checkpatch.pl: reset rpt_cleaners warnings
From: Mike Frysinger <vapier@gentoo.org>

If you run checkpatch against multiple patches, and one of them has a
whitespace issue which can be helped via a script (rpt_cleaners), you will
see the same NOTE over and over for all subsequent patches.  It makes it
seem like those patches also have whitespace problems when in reality,
there's only one or two bad apples.

So reset rpt_cleaners back to 0 after we've issued the note so that it
only shows up near the patch with the actual problems.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-reset-rpt_cleaners-warnings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-reset-rpt_cleaners-warnings
+++ a/scripts/checkpatch.pl
@@ -2944,6 +2944,7 @@ sub process {
 		if ($rpt_cleaners) {
 			print "NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or\n";
 			print "      scripts/cleanfile\n\n";
+			$rpt_cleaners = 0;
 		}
 	}
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
linux-next.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch

