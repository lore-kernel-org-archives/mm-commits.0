From: akpm@linux-foundation.org
Subject: - md-fix-compilation-warning-left-shift-count-=-width-of-type.patch removed from -mm tree
Date: Tue, 25 Nov 2008 11:57:56 -0800
Message-ID: <200811251957.mAPJvuUS029387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbYKYT6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 14:58:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@hanneseder.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix compilation warning: left shift count >= width of type
has been removed from the -mm tree.  Its filename was
     md-fix-compilation-warning-left-shift-count-=-width-of-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix compilation warning: left shift count >= width of type
From: "Hannes Eder" <hannes@hanneseder.net>

Fix the following warnings:

drivers/md/md.c:1678: warning: left shift count >= width of type
drivers/md/md.c:1702: warning: left shift count >= width of type

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/raid/md_p.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/raid/md_p.h~md-fix-compilation-warning-left-shift-count-=-width-of-type include/linux/raid/md_p.h
--- a/include/linux/raid/md_p.h~md-fix-compilation-warning-left-shift-count-=-width-of-type
+++ a/include/linux/raid/md_p.h
@@ -194,7 +194,7 @@ static inline __u64 md_event(mdp_super_t
 	return (ev<<32)| sb->events_lo;
 }
 
-#define MD_SUPERBLOCK_1_TIME_SEC_MASK ((1UL<<40) - 1)
+#define MD_SUPERBLOCK_1_TIME_SEC_MASK ((1ULL<<40) - 1)
 
 /*
  * The version-1 superblock :
_

Patches currently in -mm which might be from hannes@hanneseder.net are

linux-next.patch

