Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224A832C85;
	Wed, 21 May 2025 05:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806612; cv=none; b=n7joiCOYYPmTJEBzqT7Cp8RsotN8lyf6bXu4CsPQQW4WAO8wmML35QZgbn6tLQAX1raPsdw7S1RnHgKRjZcfdV01nMHW/teezVcklso7Kb4tYdZtcpLlYUpQZleO7XB4Nw3zSdruKePV+yMb/1lio+Pj78+btpF+wzevMfzudgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806612; c=relaxed/simple;
	bh=WW/z5TbNGcaFzUpyWxz8Y7GXNBSfkJ3Ta8Nv81RYUWc=;
	h=Date:To:From:Subject:Message-Id; b=uxlhTRndfHcPErDnFk2BuNR8ueQhtY/39pCsBx8CyUyHzUbkmFp9OkVs7+HSi+H22URat8npTj/Tyz7+I/ZkINW52KrDBz6ORe5sM9y1oxqzOenRQxk+AwBAa5h4AQLB1KXSF5nGOMzIss7KxZOBOpGAsoZ2ox/LJi5yyE+65tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kCtrr3YO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kCtrr3YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA74C4CEE4;
	Wed, 21 May 2025 05:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806611;
	bh=WW/z5TbNGcaFzUpyWxz8Y7GXNBSfkJ3Ta8Nv81RYUWc=;
	h=Date:To:From:Subject:From;
	b=kCtrr3YOGwFBP4Vy0Qrs8R2oO0irad+Ra13OstNecet6xyb9vlkks+ARc3SxCwPNQ
	 Mytw7kH5+Lw9Q+QHhVPC56OZ8spzo+3le78ulThCAZC4mNwlptOZM/ZLQrFM/2Rp3D
	 8UdkCn9EmQkNGcCCg1cl7aiG3q6a7GGmmmUOO3PI=
Date: Tue, 20 May 2025 22:50:10 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,stable@vger.kernel.org,jiang.kun2@zte.com.cn,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15.patch removed from -mm tree
Message-Id: <20250521055011.7FA74C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: fix struct taskstats breaks backward compatibility since version 15
has been removed from the -mm tree.  Its filename was
     taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: taskstats: fix struct taskstats breaks backward compatibility since version 15
Date: Sat, 10 May 2025 15:54:13 +0800 (CST)

Problem
========
commit 658eb5ab916d ("delayacct: add delay max to record delay peak")
  - adding more fields
commit f65c64f311ee ("delayacct: add delay min to record delay peak")
  - adding more fields
commit b016d0873777 ("taskstats: modify taskstats version")
 - version bump to 15

Since version 15 (TASKSTATS_VERSION=15) the new layout of the structure
adds fields in the middle of the structure, rendering all old software
incompatible with newer kernels and software compiled against the new
kernel headers incompatible with older kernels.

Solution
=========
move delay max and delay min to the end of taskstat, and bump
the version to 16 after the change

[wang.yaxin@zte.com.cn: adjust indentation]
  Link: https://lkml.kernel.org/r/202505192131489882NSciXV4EGd8zzjLuwoOK@zte.com.cn
Link: https://lkml.kernel.org/r/20250510155413259V4JNRXxukdDgzsaL0Fo6a@zte.com.cn
Fixes: f65c64f311ee ("delayacct: add delay min to record delay peak")
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Kun Jiang <jiang.kun2@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/taskstats.h |   47 +++++++++++++++++++------------
 1 file changed, 29 insertions(+), 18 deletions(-)

--- a/include/uapi/linux/taskstats.h~taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15
+++ a/include/uapi/linux/taskstats.h
@@ -34,7 +34,7 @@
  */
 
 
-#define TASKSTATS_VERSION	15
+#define TASKSTATS_VERSION	16
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -72,8 +72,6 @@ struct taskstats {
 	 */
 	__u64	cpu_count __attribute__((aligned(8)));
 	__u64	cpu_delay_total;
-	__u64	cpu_delay_max;
-	__u64	cpu_delay_min;
 
 	/* Following four fields atomically updated using task->delays->lock */
 
@@ -82,14 +80,10 @@ struct taskstats {
 	 */
 	__u64	blkio_count;
 	__u64	blkio_delay_total;
-	__u64	blkio_delay_max;
-	__u64	blkio_delay_min;
 
 	/* Delay waiting for page fault I/O (swap in only) */
 	__u64	swapin_count;
 	__u64	swapin_delay_total;
-	__u64	swapin_delay_max;
-	__u64	swapin_delay_min;
 
 	/* cpu "wall-clock" running time
 	 * On some architectures, value will adjust for cpu time stolen
@@ -172,14 +166,11 @@ struct taskstats {
 	/* Delay waiting for memory reclaim */
 	__u64	freepages_count;
 	__u64	freepages_delay_total;
-	__u64	freepages_delay_max;
-	__u64	freepages_delay_min;
+
 
 	/* Delay waiting for thrashing page */
 	__u64	thrashing_count;
 	__u64	thrashing_delay_total;
-	__u64	thrashing_delay_max;
-	__u64	thrashing_delay_min;
 
 	/* v10: 64-bit btime to avoid overflow */
 	__u64	ac_btime64;		/* 64-bit begin time */
@@ -187,8 +178,6 @@ struct taskstats {
 	/* v11: Delay waiting for memory compact */
 	__u64	compact_count;
 	__u64	compact_delay_total;
-	__u64	compact_delay_max;
-	__u64	compact_delay_min;
 
 	/* v12 begin */
 	__u32   ac_tgid;	/* thread group ID */
@@ -210,15 +199,37 @@ struct taskstats {
 	/* v13: Delay waiting for write-protect copy */
 	__u64    wpcopy_count;
 	__u64    wpcopy_delay_total;
-	__u64    wpcopy_delay_max;
-	__u64    wpcopy_delay_min;
 
 	/* v14: Delay waiting for IRQ/SOFTIRQ */
 	__u64    irq_count;
 	__u64    irq_delay_total;
-	__u64    irq_delay_max;
-	__u64    irq_delay_min;
-	/* v15: add Delay max */
+
+	/* v15: add Delay max and Delay min */
+
+	/* v16: move Delay max and Delay min to the end of taskstat */
+	__u64	cpu_delay_max;
+	__u64	cpu_delay_min;
+
+	__u64	blkio_delay_max;
+	__u64	blkio_delay_min;
+
+	__u64	swapin_delay_max;
+	__u64	swapin_delay_min;
+
+	__u64	freepages_delay_max;
+	__u64	freepages_delay_min;
+
+	__u64	thrashing_delay_max;
+	__u64	thrashing_delay_min;
+
+	__u64	compact_delay_max;
+	__u64	compact_delay_min;
+
+	__u64	wpcopy_delay_max;
+	__u64	wpcopy_delay_min;
+
+	__u64	irq_delay_max;
+	__u64	irq_delay_min;
 };
 
 
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are


