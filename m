From: akpm@linux-foundation.org
Subject: + scripts-checkpatchpl-reset-rpt_cleaners-warnings.patch added to -mm tree
Date: Tue, 01 Feb 2011 16:49:42 -0800
Message-ID: <201102020049.p120ngZs008355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971Ab1BBAuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2011 19:50:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, apw@canonical.com


The patch titled
     scripts/checkpatch.pl: reset rpt_cleaners warnings
has been added to the -mm tree.  Its filename is
     scripts-checkpatchpl-reset-rpt_cleaners-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg.patch
llist-lib-add-lock-less-null-terminated-single-list.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch
sigma-firmware-loader-for-analog-devices-sigmastudio.patch
sigma-firmware-loader-for-analog-devices-sigmastudio-v2.patch
scripts-checkpatchpl-reset-rpt_cleaners-warnings.patch

