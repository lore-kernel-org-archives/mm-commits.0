Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C245A71747;
	Tue, 13 May 2025 01:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747098545; cv=none; b=oLJeWqqNHzM2CK7ebek/95SjyzE7fr2TDgmZ00TTRXeV3lJpWSBeZm8ZArV15IfG5cutUl7d9nu4EFhnV2d4gKYOSCqjG9jpLPv0MH9m14c3PAakPHsUuuQbhdjsYBSEtcpnPK+hDn0JAXBjm6u8BwIOaoRDWM8xobrA/AVRk5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747098545; c=relaxed/simple;
	bh=exO81zqTt1mxANJDYCH82Tn0QqzQN7ysFbcIM560OfM=;
	h=Date:To:From:Subject:Message-Id; b=mkgn9iABbsCW0t+heQJBxpROLQ1Oom25shx0SYnAw+VNyPdUI0rOAlZ8/mGedjwADYzffOUouajRs/V+yoIfZPWIExAHQ3/I+QioFG7L0E+4Jxzx2kpnSAXBncVUgDTGmXqb1EM63yNqjrvuKQcjHok+mWakwgORiW47qW5Rwgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xRM/o1Hi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xRM/o1Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B02C4CEE7;
	Tue, 13 May 2025 01:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747098545;
	bh=exO81zqTt1mxANJDYCH82Tn0QqzQN7ysFbcIM560OfM=;
	h=Date:To:From:Subject:From;
	b=xRM/o1HiKAFXzDDuK0GUdZQETiyBf0B7CQ8ItCgzzXL+LtuP+LA/ZQ9Fy8MO7bjiA
	 291rIh866JGNiUYMVt5/q0WNyJYuyzerGhbaEvJj07hAQAvvGQWQIgUMZ96C396A0I
	 3/UfFN3IBJcaBV3ZuYvRMmi8Nh2dIMQ2E7eP9G7I=
Date: Mon, 12 May 2025 18:09:04 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,stable@vger.kernel.org,jiang.kun2@zte.com.cn,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15.patch added to mm-hotfixes-unstable branch
Message-Id: <20250513010905.31B02C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: fix struct taskstats breaks backward compatibility since version 15
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20250510155413259V4JNRXxukdDgzsaL0Fo6a@zte.com.cn
Fixes: f65c64f311ee ("delayacct: add delay min to record delay peak")
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Kun Jiang <jiang.kun2@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/taskstats.h |   43 +++++++++++++++++++------------
 1 file changed, 27 insertions(+), 16 deletions(-)

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
+	__u64    wpcopy_delay_max;
+	__u64    wpcopy_delay_min;
+
 	__u64    irq_delay_max;
 	__u64    irq_delay_min;
-	/* v15: add Delay max */
 };
 
 
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15.patch

