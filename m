Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333079;
	b=gvdM1O+TOBA5suh4wCFD4y1UZjbimsMJ2CdMbrASQxp18YSJZifh+woNs0l5Beo+8kpE
	 4B++xXJmSiUrFw3gD5mxvpPJpBQ+I2HPa7wNJ2VwxJOTMIo2IShMmHTY7YGXCE0OWfDB5
	 NxsTvcUBf5JsddlSq6iG225B9eHjM+Nd2Y4VElzK2QUAufOyKcIXjLzghO9BflgFwEzEw
	 FGY0g7wOwnFzAXYEhOgxUavy0R6FxqOi1V5XmPEqdKN4YltvpkXkPuhjl121F/bega3d5
	 JHqAxczjWzb8sPbMa8LsgF8b3ZTo6OWblV54dfNs47XKYjgvc0ESE5J9Msp7ZHphhkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333079;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=yj9RWK76RXDw0crkcP65KWYauRrQYoOoyZQzp5bU2lc=;
	b=l0/vrdqy0Sr31uiAaoeJ0UDq8qIArEjEV4Xdk6RQSH80Xq8ym9js/o3nbR3QtOtosGqK
	 ejTZJy8cJI2UAX467AHxPHap/iaZ1QmNHXviGWqkv3AqveY7oiL6PEgv+84sd5quwrvhA
	 UHAz33ku8w1GGVPDqWhS57xxyXlqLZPGlmcuL3/xvbnDCkvFWLuUpE7s5xZfP9UZdM+oT
	 h1YTugRVd3tFX1+E8Xfx2PQaFE9aeEiQoQs2V2OqEakMFI8R8i3/ED9OWywNDzdgXX9OV
	 OgDiWUBe9Wxhs6iq014gkLX/MlYfPcQ1YHlXqiDiv798uUYclsxLXryGiMcf3Ij/2mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1b+C1rk6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44B606A31C;
	Fri, 30 Oct 2026 04:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1b+C1rk6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4951F000C1;
	Fri, 30 Oct 2026 04:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793333078;
	bh=yj9RWK76RXDw0crkcP65KWYauRrQYoOoyZQzp5bU2lc=;
	h=Date:To:From:Subject;
	b=1b+C1rk6Pjxzc2Sd0ETXxCQXg6+DllARqLB3w2RvZp5FgTok5gTsIhbUtmGUjp/TB
	 QG7blNpaWjjTQnYpKtxjIL0xP8khgTbu90QrwEncLE5vglM0oB4ByO3wEyO6oIeTKo
	 /5mGInvMYNfto/fU60cHPJACqjbjnvBu3Z2BtL/g=
Date: Thu, 29 Oct 2026 21:04:37 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin@linux.dev,
	wang.yong12@zte.com.cn,wang.yaxin@zte.com.cn,stable@vger.kernel.org,
	jiang.kun2@zte.com.cn,bsingharora@gmail.com,brads@mainlining.org,
	dennylin0707@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch added to mm-nonmm-unstable branch
Message-Id: <20261030040438.3E4951F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: delayacct: preserve delay extrema when aggregating taskstats
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch

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
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: delayacct: preserve delay extrema when aggregating taskstats
Date: Thu, 22 Oct 2026 16:06:48 +0000

delayacct_add_tsk() adds each task's statistics to the accumulated TGID
statistics, but overwrites the delay maxima, minima and peak timestamps.
Consequently, the last task determines these fields, and a task with no
recorded delay can erase an earlier task's peak despite a nonzero total.

For example, a four-thread process has a worker writing copy-on-write
pages and a last-created thread with no WPCOPY events. With the group
stopped, getdelays -d -t 49 reports the following before and after the
fix (WPCOPY excerpt, spacing compacted and timestamp column omitted):

Before:
  WPCOPY count delay total delay average  delay max  delay min
          4103     5163661       0.001ms 0.000000ms 0.000000ms

After:
  WPCOPY count delay total delay average  delay max  delay min
          4101     4680983       0.001ms 0.049292ms 0.000208ms

The timings vary between runs. Before the fix, the zero extrema disagree
with the individual worker's nonzero values. After the fix, the group
extrema match the largest maximum and smallest nonzero minimum across
the individual threads.

Keep the largest maximum and its associated timestamp, and combine the
minima with min_not_zero() since zero denotes an unrecorded delay. Apply
this to CPU delay and the seven delay types handled by UPDATE_DELAY().
Single-task queries still start with zeroed statistics and retain the
task's values.

Link: https://lore.kernel.org/20261022160648.37411-1-dennylin0707@gmail.com
Fixes: 658eb5ab916d ("delayacct: add delay max to record delay peak")
Fixes: f65c64f311ee ("delayacct: add delay min to record delay peak")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: <bsingharora@gmail.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: <wang.yong12@zte.com.cn>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Jiang Kun <jiang.kun2@zte.com.cn>
Cc: <stable@vger.kernel.org>
---

 kernel/delayacct.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/kernel/delayacct.c~delayacct-preserve-delay-extrema-when-aggregating-taskstats
+++ a/kernel/delayacct.c
@@ -12,14 +12,18 @@
 #include <linux/taskstats.h>
 #include <linux/sysctl.h>
 #include <linux/delayacct.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 
 #define UPDATE_DELAY(type) \
 do { \
-	d->type##_delay_max = tsk->delays->type##_delay_max; \
-	d->type##_delay_min = tsk->delays->type##_delay_min; \
-	d->type##_delay_max_ts.tv_sec = tsk->delays->type##_delay_max_ts.tv_sec; \
-	d->type##_delay_max_ts.tv_nsec = tsk->delays->type##_delay_max_ts.tv_nsec; \
+	if (tsk->delays->type##_delay_max > d->type##_delay_max) { \
+		d->type##_delay_max = tsk->delays->type##_delay_max; \
+		d->type##_delay_max_ts.tv_sec = tsk->delays->type##_delay_max_ts.tv_sec; \
+		d->type##_delay_max_ts.tv_nsec = tsk->delays->type##_delay_max_ts.tv_nsec; \
+	} \
+	d->type##_delay_min = min_not_zero(d->type##_delay_min, \
+					 tsk->delays->type##_delay_min); \
 	tmp = d->type##_delay_total + tsk->delays->type##_delay; \
 	d->type##_delay_total = (tmp < d->type##_delay_total) ? 0 : tmp; \
 	d->type##_count += tsk->delays->type##_count; \
@@ -174,10 +178,13 @@ int delayacct_add_tsk(struct taskstats *
 
 	d->cpu_count += t1;
 
-	d->cpu_delay_max = tsk->sched_info.max_run_delay;
-	d->cpu_delay_min = tsk->sched_info.min_run_delay;
-	d->cpu_delay_max_ts.tv_sec = tsk->sched_info.max_run_delay_ts.tv_sec;
-	d->cpu_delay_max_ts.tv_nsec = tsk->sched_info.max_run_delay_ts.tv_nsec;
+	if (tsk->sched_info.max_run_delay > d->cpu_delay_max) {
+		d->cpu_delay_max = tsk->sched_info.max_run_delay;
+		d->cpu_delay_max_ts.tv_sec = tsk->sched_info.max_run_delay_ts.tv_sec;
+		d->cpu_delay_max_ts.tv_nsec = tsk->sched_info.max_run_delay_ts.tv_nsec;
+	}
+	d->cpu_delay_min = min_not_zero(d->cpu_delay_min,
+					tsk->sched_info.min_run_delay);
 	tmp = (s64)d->cpu_delay_total + t2;
 	d->cpu_delay_total = (tmp < (s64)d->cpu_delay_total) ? 0 : tmp;
 	tmp = (s64)d->cpu_run_virtual_total + t3;
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch
mm-migrate-untag-addresses-when-querying-page-nodes.patch
fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch
delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch

