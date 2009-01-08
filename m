From: akpm@linux-foundation.org
Subject: - quota-dont-set-grace-time-when-user-isnt-above-softlimit.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:14 -0800
Message-ID: <200901082247.n08MlEt1026694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763430AbZAHWru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:47:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: don't set grace time when user isn't above softlimit
has been removed from the -mm tree.  Its filename was
     quota-dont-set-grace-time-when-user-isnt-above-softlimit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: don't set grace time when user isn't above softlimit
From: Jan Kara <jack@suse.cz>

do_set_dqblk() allowed SETDQBLK quotactl to set user's grace time even if
user was not above his softlimit.  This does not make much sence and by
coincidence causes quota code to omit softlimit warning when user really
exceeds softlimit.  This patch makes do_set_dqblk() reset user's grace
time if he has not exceeded softlimit.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/dquot.c~quota-dont-set-grace-time-when-user-isnt-above-softlimit fs/dquot.c
--- a/fs/dquot.c~quota-dont-set-grace-time-when-user-isnt-above-softlimit
+++ a/fs/dquot.c
@@ -2090,10 +2090,12 @@ static int do_set_dqblk(struct dquot *dq
 	}
 	if (di->dqb_valid & QIF_BTIME) {
 		dm->dqb_btime = di->dqb_btime;
+		check_blim = 1;
 		__set_bit(DQ_LASTSET_B + QIF_BTIME_B, &dquot->dq_flags);
 	}
 	if (di->dqb_valid & QIF_ITIME) {
 		dm->dqb_itime = di->dqb_itime;
+		check_ilim = 1;
 		__set_bit(DQ_LASTSET_B + QIF_ITIME_B, &dquot->dq_flags);
 	}
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch

