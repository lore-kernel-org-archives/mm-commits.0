From: akpm@linux-foundation.org
Subject: - md-fix-formatting-error-in-proc-mdstat.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:11 -0700
Message-ID: <200803110322.m2B3MB4k019792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbYCKDWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix formatting error in /proc/mdstat
has been removed from the -mm tree.  Its filename was
     md-fix-formatting-error-in-proc-mdstat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix formatting error in /proc/mdstat
From: NeilBrown <neilb@suse.de>

If an md array is "auto-read-only", then this appears in /proc/mdstat as

   /dev/md0: active(auto-read-only)

whereas if it is truely readonly, it appears as

   /dev/md0: active (read-only)

The difference being a space.

One program known to parse this file expects the space and gets badly
confused.  It will be fixed, but it would be best if what the kernel generates
is more consistent too.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-fix-formatting-error-in-proc-mdstat drivers/md/md.c
--- a/drivers/md/md.c~md-fix-formatting-error-in-proc-mdstat
+++ a/drivers/md/md.c
@@ -5149,7 +5149,7 @@ static int md_seq_show(struct seq_file *
 			if (mddev->ro==1)
 				seq_printf(seq, " (read-only)");
 			if (mddev->ro==2)
-				seq_printf(seq, "(auto-read-only)");
+				seq_printf(seq, " (auto-read-only)");
 			seq_printf(seq, " %s", mddev->pers->name);
 		}
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
git-nfsd.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch

