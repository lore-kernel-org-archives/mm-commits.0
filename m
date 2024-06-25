Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F68333C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293181; cv=none; b=m+k08HY/Hy42m7R8t/UugHE9Fmww7GgVjm3ErqHCKAspYq27oVTGdrl+JfWp7MH/hLXfECNg6jhFMlUGzK2nztYUjmiQ8St+8yxHJXiCv4rw7ka4/AN4go6m7KFrsbcA45z8flfGhNI73wuPOwg56/Hm9+1owBDe5dEXzieYyZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293181; c=relaxed/simple;
	bh=yv2VKIqVnsILSUxOJVsRJu3agkaAxLMQLTp3bHjWiJg=;
	h=Date:To:From:Subject:Message-Id; b=rWE4HOQcDtrsXjkgM8Kq3hAsBRmGd/TPb/b63ATaC0kTMw6rmiZ2UNMAiLu4USnZCq5/F37Cju7+qOboSK56Zeo6Iikjmbr6NQLtP9CqQiP8W6sfa+WAztZdsD4w+wOn3KfjW7gnrupMvepmoOwQwozBM1/uoeTRqWB7XTMrNHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hKNQkC/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hKNQkC/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136E1C32782;
	Tue, 25 Jun 2024 05:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293181;
	bh=yv2VKIqVnsILSUxOJVsRJu3agkaAxLMQLTp3bHjWiJg=;
	h=Date:To:From:Subject:From;
	b=hKNQkC/Wwm2hxZWpnsm2tyAqPdqzuSOubjFx8uJ6DOTvSr13tYimm6qWpQgnKNEFy
	 B8MINS9OJI4G2aaw/QrcUVy6i/qiX+DWNO3sQnl71exIk8R0lF2fzYuFY/mkOOU4x9
	 FLZm5CMcBc1ldWEDzNR/XjXngMx2r3vhIh8UI7+U=
Date: Mon, 24 Jun 2024 22:26:20 -0700
To: mm-commits@vger.kernel.org,yury.norov@nvidia.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] sched-avoid-using-ilog2-in-schedh.patch removed from -mm tree
Message-Id: <20240625052621.136E1C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched: avoid using ilog2() in sched.h
has been removed from the -mm tree.  Its filename was
     sched-avoid-using-ilog2-in-schedh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: sched: avoid using ilog2() in sched.h
Date: Mon, 27 May 2024 17:56:44 -0700

<linux/sched.h> indirectly via cpumask.h path includes the ilog2.h header
to calculate ilog2(TASK_REPORT_MAX).  The following patches drops sched.h
dependency on cpumask.h, and to have a successful build, the header has to
be included explicitly.

sched.h is a frequently included header, and it's better to keep the
dependency list as small as possible.  So, instead of including ilog2.h
for a single BUILD_BUG_ON() check, the same check may be implemented by
taking exponent of the other part of equation.

Link: https://lkml.kernel.org/r/20240528005648.182376-3-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Amit Daniel Kachhap <amit.kachhap@gmail.com>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Yury Norov <yury.norov@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/sched.h~sched-avoid-using-ilog2-in-schedh
+++ a/include/linux/sched.h
@@ -1604,7 +1604,7 @@ static inline char task_index_to_char(un
 {
 	static const char state_char[] = "RSDTtXZPI";
 
-	BUILD_BUG_ON(1 + ilog2(TASK_REPORT_MAX) != sizeof(state_char) - 1);
+	BUILD_BUG_ON(TASK_REPORT_MAX * 2 != 1 << (sizeof(state_char) - 1));
 
 	return state_char[state];
 }
_

Patches currently in -mm which might be from yury.norov@gmail.com are


