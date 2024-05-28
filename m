Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803B3178367
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716928773; cv=none; b=pckk/sC9WoRbziWRFyQzptd682xUxppblUH/yGmOlps6op5+c8APc5wSXOGx3EtTNPNPFEC9IDDTmOYOLxBGs4kSf6YjJYa/le1CeZj/bU25KaEptaFptRTcqCtowl2jvNLgBZhm4nsoMKNyNzVv0Jax0yMRwEzg1WizWZi+5X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716928773; c=relaxed/simple;
	bh=rdXnO6z7D3+hlNzEtsSgVtjozAysrinA8fT3zNO2BuU=;
	h=Date:To:From:Subject:Message-Id; b=qJfNIUI90/1tZ8UooAORtlcsUcDpbZohHSLhqS+wi/k6xp+wBQCEfCI8XGS71ZNgeDaje72orEBTNx4Mq2RSuxBBPQiRBpOhgENojI83+nTVtFYVQZzABZ3lDrAl0mG+LBWgdpfm5ztnikF1mho+OHrsr7Uyc6rCIVeTS5EbNW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HV1Dh2E5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HV1Dh2E5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13D6C3277B;
	Tue, 28 May 2024 20:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716928773;
	bh=rdXnO6z7D3+hlNzEtsSgVtjozAysrinA8fT3zNO2BuU=;
	h=Date:To:From:Subject:From;
	b=HV1Dh2E560nUXvs9xxI4lPvSktG2xAx7JJmGtlzy3EkQXR8Dz2S8OlZIHY/y3xTYH
	 m5URbMAbaG4U0uTqzlbxwE5OEVENMQNV1bZ2twKmHK34levGoKYN4kW7lqAoZOvu2L
	 gKjlx9wvQ9WfiYCZ4GmVN5F5wDswE8i2ihK4zoyE=
Date: Tue, 28 May 2024 13:39:32 -0700
To: mm-commits@vger.kernel.org,yury.norov@nvidia.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch added to mm-nonmm-unstable branch
Message-Id: <20240528203932.E13D6C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add linux/nodemask_types.h to BITMAP API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch

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
Subject: MAINTAINERS: add linux/nodemask_types.h to BITMAP API
Date: Mon, 27 May 2024 17:56:43 -0700

Patch series "Cleanup cpumask.h inclusion in core headers".

Many core headers include linux/cpumask.h for nothing, and some others
include it just for types.  We already have nodemask_types.h, and this
series adds cpumask_types.h to optimize core headers inclusion paths.

Interestingly, it doesn't improve on build time for me, but the headers
cleanup work should keep going.


This patch (of 6):

Commit bea32141764b ("nodemask: Split out include/linux/nodemask_types.h")
added the nodemask_types.h but didn't cover it with corresponding record
in the MAINTAINERS file.

Link: https://lkml.kernel.org/r/20240528005648.182376-1-yury.norov@gmail.com
Link: https://lkml.kernel.org/r/20240528005648.182376-2-yury.norov@gmail.com
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
Cc: Rafael J. Wysocki <rafael@kernel.org> # for thermal
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Yury Norov <yury.norov@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-linux-nodemask_typesh-to-bitmap-api
+++ a/MAINTAINERS
@@ -3734,6 +3734,7 @@ F:	include/linux/bits.h
 F:	include/linux/cpumask.h
 F:	include/linux/find.h
 F:	include/linux/nodemask.h
+F:	include/linux/nodemask_types.h
 F:	include/vdso/bits.h
 F:	lib/bitmap-str.c
 F:	lib/bitmap.c
_

Patches currently in -mm which might be from yury.norov@gmail.com are

gcc-disable-warray-bounds-for-gcc-9.patch
maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch
sched-avoid-using-ilog2-in-schedh.patch
sched-drop-schedh-dependency-on-cpumask.patch
cpumask-cleanup-core-headers-inclusion.patch
cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch

