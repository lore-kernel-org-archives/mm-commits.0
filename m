From: akpm@linux-foundation.org
Subject: + fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch
 added to -mm tree
Date: Mon, 10 Apr 2017 15:34:13 -0700
Message-ID: <58ec0865.ewLzJaC+1GG2CkTV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751593AbdDJWeO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:34:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, arnd@arndb.de, jaegeuk@kernel.org, yuchao0@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: f2fs: use ktime_get_real_seconds for sit_info times
has been added to the -mm tree.  Its filename is
     fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2678,7 +2678,7 @@ static int build_sit_info(struct f2fs_sb
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
@@ -692,8 +692,9 @@ static inline void set_to_next_sit(struc
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

fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch
trace-make-trace_hwlat-timestamp-y2038-safe.patch
fs-cifs-replace-current_time-by-other-appropriate-apis.patch
fs-ceph-current_time-with-ktime_get_real_ts.patch
fs-ufs-use-ktime_get_real_ts64-for-birthtime.patch
audit-use-timespec64-to-represent-audit-timestamps.patch
fs-btrfs-use-ktime_get_real_ts-for-root-ctime.patch
fs-ubifs-replace-current_time_sec-with-current_time.patch
lustre-replace-current_time-macro.patch
apparmorfs-replace-current_time-with-current_time.patch
time-delete-current_time_sec-and-current_time.patch
time-delete-current_fs_time-function.patch

