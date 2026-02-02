Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489902D028A
	for <mm-commits@vger.kernel.org>; Mon,  2 Feb 2026 20:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770064670; cv=none; b=kt1j5t7fQ06/YTNA2bBUe5RSuHVn9yMRlylc+Iz5IZjbkHSf2Qqiun2UTgIbrcHhfylFfxqbeP+JwPS8LiCp8vZl0QFiaRCwIu2ddltnB5LSkznbolw0KxIs1t4JlXUUtY+lfqw9heZsFm2mRXSHJy2yKQvYeLa7HAAKQcVjRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770064670; c=relaxed/simple;
	bh=AcxXeSd2hoJQHbzl/csuR5JuHQ9jBZSy4pDeZs1loKc=;
	h=Date:To:From:Subject:Message-Id; b=cuO5e330HVuZwTsnuQW5o5yiaB9oDM2sYCpVXZnq8MudQc0UOTD0tcksKLdBpybnP9Efq7/bQ++lIbOvcCjFpwQFkiOkkFZYdNROzw133VtZdYhH+zZ32niBVe81e/lbtDdAfjFhrlZoT4LZU8ONT/BtC2ck1iYtM2UJp2rxaug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2GcF5GEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2GcF5GEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5A8C19421;
	Mon,  2 Feb 2026 20:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770064669;
	bh=AcxXeSd2hoJQHbzl/csuR5JuHQ9jBZSy4pDeZs1loKc=;
	h=Date:To:From:Subject:From;
	b=2GcF5GEqflWXQw85GHO7WJYc++ZFoVj+RWG4K73kcp2+Y+HPTMQo+QzeYNA6uGtfd
	 r/cq4Pjdnhy4O96xtFDFKVIqrc19U9Cdlhjbp5fyfthkIzLTrr9vH0WBKdbUf9q9Wr
	 /Zd98aZlj5EPW6NtGuwplocpacVwKZ22vPlfk6mo=
Date: Mon, 02 Feb 2026 12:37:49 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,fan.yu9@zte.com.cn,corbet@lwn.net,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + delayacct-fix-uapi-timespec64-definition.patch added to mm-nonmm-unstable branch
Message-Id: <20260202203749.BC5A8C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: delayacct: fix uapi timespec64 definition
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     delayacct-fix-uapi-timespec64-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delayacct-fix-uapi-timespec64-definition.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

delayacct-fix-uapi-timespec64-definition.patch

