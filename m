Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EED178367
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716928775; cv=none; b=JIVAoPQHmcoPsqbtTKYdf4TKziJpxEVFxxLbmm1Q/r6djXipu9G7Fn21NZJPNV/9kWW/I3uw0ySZfh8R9tP6TMiv4J5AIJXEybbsAdih0M/K9x5FRF8Ld3fnEN3MIkz7nt0VZikFi6pCZ9KCR+LOMRzaxBfiK4GHJ2QxuXiJdGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716928775; c=relaxed/simple;
	bh=x0X0eRnqXvxKp3kVZVFlLzPndYCp29BfrxI3XMXphq4=;
	h=Date:To:From:Subject:Message-Id; b=OxjoMJtCy9gAUhJaRJu5UGkXixGuBIStx1WlQNwk8lYxNn4rtHwoLVAl/EG1j4FDLR5GsGIGCqjz9evMYtympcU22ZReduybwzxyJqvbz5oSY8FeGPCkoUVBOGKbp8AP1pYlw/dvFnt7j4xJDfC2vkihD3nVW6YGyvy+gnk2TA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZFqAzBkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZFqAzBkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7FCC3277B;
	Tue, 28 May 2024 20:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716928775;
	bh=x0X0eRnqXvxKp3kVZVFlLzPndYCp29BfrxI3XMXphq4=;
	h=Date:To:From:Subject:From;
	b=ZFqAzBkF09NqknowP3SVbN6Buf+Kj7tMLvz4+QHZVxnAcKO/ik0pC58viG3V8i3oM
	 6p6Jnf1D5sCR4ayo+T4Dze/jsYTt5SY8+5M3A5jOvEyQSoYEOhCu1EhJ72vviAIS/4
	 MTgqGLiE6Brbv+5b7QcxGFHEjWaKwmDeE+NFYAAk=
Date: Tue, 28 May 2024 13:39:34 -0700
To: mm-commits@vger.kernel.org,yury.norov@nvidia.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-avoid-using-ilog2-in-schedh.patch added to mm-nonmm-unstable branch
Message-Id: <20240528203935.0A7FCC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched: avoid using ilog2() in sched.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sched-avoid-using-ilog2-in-schedh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-avoid-using-ilog2-in-schedh.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

gcc-disable-warray-bounds-for-gcc-9.patch
maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch
sched-avoid-using-ilog2-in-schedh.patch
sched-drop-schedh-dependency-on-cpumask.patch
cpumask-cleanup-core-headers-inclusion.patch
cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch

