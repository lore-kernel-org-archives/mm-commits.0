From: akpm@linux-foundation.org
Subject: [merged]
 fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch removed from
 -mm tree
Date: Tue, 09 May 2017 11:03:53 -0700
Message-ID: <20170509180353.6Sd_KHyQ4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753219AbdEISDy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:03:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, deepa.kernel@gmail.com, jaegeuk@kernel.org, mm-commits@vger.kernel.org, yuchao0@huawei.com


The patch titled
     Subject: fs: f2fs: use ktime_get_real_seconds for sit_info times
has been removed from the -mm tree.  Its filename was
     fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: fs: f2fs: use ktime_get_real_seconds for sit_info times

CURRENT_TIME_SEC is not y2038 safe.

Replace use of CURRENT_TIME_SEC with ktime_get_real_seconds in segment
timestamps used by GC algorithm including the segment mtime timestamps.

Link: http://lkml.kernel.org/r/1491613030-11599-2-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/segment.c |    2 +-
 fs/f2fs/segment.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/f2fs/segment.c~fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times fs/f2fs/segment.c
--- a/fs/f2fs/segment.c~fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times
+++ a/fs/f2fs/segment.c
@@ -2573,7 +2573,7 @@ static int build_sit_info(struct f2fs_sb
 	sit_i->dirty_sentries = 0;
 	sit_i->sents_per_block = SIT_ENTRY_PER_BLOCK;
 	sit_i->elapsed_time = le64_to_cpu(sbi->ckpt->elapsed_time);
-	sit_i->mounted_time = CURRENT_TIME_SEC.tv_sec;
+	sit_i->mounted_time = ktime_get_real_seconds();
 	mutex_init(&sit_i->sentry_lock);
 	return 0;
 }
diff -puN fs/f2fs/segment.h~fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times fs/f2fs/segment.h
--- a/fs/f2fs/segment.h~fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times
+++ a/fs/f2fs/segment.h
@@ -691,8 +691,9 @@ static inline void set_to_next_sit(struc
 static inline unsigned long long get_mtime(struct f2fs_sb_info *sbi)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
-	return sit_i->elapsed_time + CURRENT_TIME_SEC.tv_sec -
-						sit_i->mounted_time;
+	time64_t now = ktime_get_real_seconds();
+
+	return sit_i->elapsed_time + now - sit_i->mounted_time;
 }
 
 static inline void set_summary(struct f2fs_summary *sum, nid_t nid,
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are

time-delete-current_fs_time-function.patch

