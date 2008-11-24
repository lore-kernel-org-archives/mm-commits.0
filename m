From: akpm@linux-foundation.org
Subject: + md-fix-compilation-warning-left-shift-count-=-width-of-type.patch added to -mm tree
Date: Mon, 24 Nov 2008 13:16:27 -0800
Message-ID: <200811242116.mAOLGSQx019789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbYKXVRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 16:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net, neilb@suse.de


The patch titled
     md: fix compilation warning: left shift count >= width of type
has been added to the -mm tree.  Its filename is
     md-fix-compilation-warning-left-shift-count-=-width-of-type.patch

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
md-fix-compilation-warning-left-shift-count-=-width-of-type.patch

