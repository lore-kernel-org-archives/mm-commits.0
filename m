Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9F8337BB5
	for <mm-commits@vger.kernel.org>; Sun,  8 Feb 2026 08:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770538444; cv=none; b=Dn/OyMOvueVimSTa9GdKh9EOH6458gc0rvO5OXt5EJDVJ4yBYj+63cRG2/nsIW6B/fpUyZMZcx4RrFEwnbtjtlrdwB1Y5kwrA86YTBa7xwLNKfEwVLpAz3WHbqVpXJiySl6Fk0oZIJgFIDT5yv6Lab2OQsZ0yNw2Ro78OzXQUXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770538444; c=relaxed/simple;
	bh=Z3uoH0MIN664rPBOlWGdom87I2HVQ0jRKYOQn76BH80=;
	h=Date:To:From:Subject:Message-Id; b=c2Pck11CH8ciB/rLi2VWu5Y/Kunc46etKyzWl1h2gIGk8TPjDy08A19RASYiuoQek3xroiOd//8WoyJ4ddkYzOf57Opij/s6SwmCXxsS1cbJCm3UBdTzHqDkclhP+hxQIp5KWNpxTTgRaj4jwny5mN73g7xycKVwb+XuIQFnJIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dl0RHIg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dl0RHIg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2CCC4CEF7;
	Sun,  8 Feb 2026 08:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770538444;
	bh=Z3uoH0MIN664rPBOlWGdom87I2HVQ0jRKYOQn76BH80=;
	h=Date:To:From:Subject:From;
	b=dl0RHIg+HmTcu0+xT2yMqNblbIydTz8geI6/ZeOZEQBabn3ldoi5kPyEO4GDC8hNl
	 nDji73QCkWHZeF05+3tyy6+QeLerLip4Apc66Xj+twDCangWlxmCvepygJM5rBF9ye
	 OY2MVVbDaRsUm2JCLBiYKwRFpJXN44eyb4GIcRuA=
Date: Sun, 08 Feb 2026 00:14:03 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,jiang.kun2@zte.com.cn,fan.yu9@zte.com.cn,corbet@lwn.net,bsingharora@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] delayacct-fix-uapi-timespec64-definition.patch removed from -mm tree
Message-Id: <20260208081404.2E2CCC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: delayacct: fix uapi timespec64 definition
has been removed from the -mm tree.  Its filename was
     delayacct-fix-uapi-timespec64-definition.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: delayacct: fix uapi timespec64 definition
Date: Mon, 2 Feb 2026 10:59:00 +0100

The custom definition of 'struct timespec64' is incompatible with both the
kernel's internal definition and the glibc type, at least on big-endian
targets that have the tv_nsec field in a different place, and the
definition clashes with any userspace that also defines a timespec64
structure.

Running the header check with -Wpadding enabled produces this output that
warns about the incorrect padding:

usr/include/linux/taskstats.h:25:1: error: padding struct size to alignment boundary with 4 bytes [-Werror=padded]

Remove the hack and instead use the regular __kernel_timespec type that is
meant to be used in uapi definitions.

Link: https://lkml.kernel.org/r/20260202095906.1344100-1-arnd@kernel.org
Fixes: 29b63f6eff0e ("delayacct: add timestamp of delay max")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Jiang Kun <jiang.kun2@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/taskstats.h |   27 +++++++++------------------
 kernel/delayacct.c             |    6 ++++--
 2 files changed, 13 insertions(+), 20 deletions(-)

--- a/include/uapi/linux/taskstats.h~delayacct-fix-uapi-timespec64-definition
+++ a/include/uapi/linux/taskstats.h
@@ -18,16 +18,7 @@
 #define _LINUX_TASKSTATS_H
 
 #include <linux/types.h>
-#ifdef __KERNEL__
-#include <linux/time64.h>
-#else
-#ifndef _LINUX_TIME64_H
-struct timespec64 {
-	__s64   tv_sec;         /* seconds */
-	long    tv_nsec;        /* nanoseconds */
-};
-#endif
-#endif
+#include <linux/time_types.h>
 
 /* Format for per-task data returned to userland when
  *	- a task exits
@@ -242,14 +233,14 @@ struct taskstats {
 	__u64	irq_delay_min;
 
 	/*v17: delay max timestamp record*/
-	struct timespec64 cpu_delay_max_ts;
-	struct timespec64 blkio_delay_max_ts;
-	struct timespec64 swapin_delay_max_ts;
-	struct timespec64 freepages_delay_max_ts;
-	struct timespec64 thrashing_delay_max_ts;
-	struct timespec64 compact_delay_max_ts;
-	struct timespec64 wpcopy_delay_max_ts;
-	struct timespec64 irq_delay_max_ts;
+	struct __kernel_timespec cpu_delay_max_ts;
+	struct __kernel_timespec blkio_delay_max_ts;
+	struct __kernel_timespec swapin_delay_max_ts;
+	struct __kernel_timespec freepages_delay_max_ts;
+	struct __kernel_timespec thrashing_delay_max_ts;
+	struct __kernel_timespec compact_delay_max_ts;
+	struct __kernel_timespec wpcopy_delay_max_ts;
+	struct __kernel_timespec irq_delay_max_ts;
 };
 
 
--- a/kernel/delayacct.c~delayacct-fix-uapi-timespec64-definition
+++ a/kernel/delayacct.c
@@ -18,7 +18,8 @@
 do { \
 	d->type##_delay_max = tsk->delays->type##_delay_max; \
 	d->type##_delay_min = tsk->delays->type##_delay_min; \
-	d->type##_delay_max_ts = tsk->delays->type##_delay_max_ts; \
+	d->type##_delay_max_ts.tv_sec = tsk->delays->type##_delay_max_ts.tv_sec; \
+	d->type##_delay_max_ts.tv_nsec = tsk->delays->type##_delay_max_ts.tv_nsec; \
 	tmp = d->type##_delay_total + tsk->delays->type##_delay; \
 	d->type##_delay_total = (tmp < d->type##_delay_total) ? 0 : tmp; \
 	d->type##_count += tsk->delays->type##_count; \
@@ -175,7 +176,8 @@ int delayacct_add_tsk(struct taskstats *
 
 	d->cpu_delay_max = tsk->sched_info.max_run_delay;
 	d->cpu_delay_min = tsk->sched_info.min_run_delay;
-	d->cpu_delay_max_ts = tsk->sched_info.max_run_delay_ts;
+	d->cpu_delay_max_ts.tv_sec = tsk->sched_info.max_run_delay_ts.tv_sec;
+	d->cpu_delay_max_ts.tv_nsec = tsk->sched_info.max_run_delay_ts.tv_nsec;
 	tmp = (s64)d->cpu_delay_total + t2;
 	d->cpu_delay_total = (tmp < (s64)d->cpu_delay_total) ? 0 : tmp;
 	tmp = (s64)d->cpu_run_virtual_total + t3;
_

Patches currently in -mm which might be from arnd@arndb.de are


