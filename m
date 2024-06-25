Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4809A33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293180; cv=none; b=kGZqL0GPrs9RRzM3Ds9jLEH967ZPzAZv8YM9uKPTiOM+kHtzwCe4Rvq2gXVbs7zpUrne9QghaAtN/ZOJ0Z1Fr7zxgo+J5U8tEfQMZ7FSYDN/VbnFGU0Th7TLeLHFlRZvlWBxkBQNofw4LpVTbAelJbh0XvQsEYUm3wrN4BeH044=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293180; c=relaxed/simple;
	bh=hXFycVFgdtQg6D2/xQQk4+LZtyp7k70NXBrbUQEhdZA=;
	h=Date:To:From:Subject:Message-Id; b=eCX7LjmW0DrNLVng6dg0bx0c1U+6U4/NBgtHM3XtXDR+N8jpdNlFDj5TqpTLQfJo1hAq0TmfT36lIUcDFn6jtONwcmMu1d/GVJ/EZVUUUO7Q/Kq+tmz23ZjaGVE8YUNfp2Fild/GEeUw1BSN0zBPxkGhgUjlkIdrnszSoxjfuNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YM+rv03p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YM+rv03p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20FFC32782;
	Tue, 25 Jun 2024 05:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293179;
	bh=hXFycVFgdtQg6D2/xQQk4+LZtyp7k70NXBrbUQEhdZA=;
	h=Date:To:From:Subject:From;
	b=YM+rv03pLkHaP5igg3nIGTXX2sz+WdYoZm2a2azlJa7kcTa23OYsOm1eyMIhMzES+
	 cK4ZIqI9ha0DGHvJJVIiAlVcm1Ta1VJzU77hTPEmhLvWwf1xKxdEaG11lYlK00yEO9
	 xgR8hHNAxxChJ0D//WcYHf6Fq2MeuIAARhddhYAU=
Date: Mon, 24 Jun 2024 22:26:19 -0700
To: mm-commits@vger.kernel.org,yury.norov@nvidia.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch removed from -mm tree
Message-Id: <20240625052619.D20FFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add linux/nodemask_types.h to BITMAP API
has been removed from the -mm tree.  Its filename was
     maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3732,6 +3732,7 @@ F:	include/linux/bits.h
 F:	include/linux/cpumask.h
 F:	include/linux/find.h
 F:	include/linux/nodemask.h
+F:	include/linux/nodemask_types.h
 F:	include/vdso/bits.h
 F:	lib/bitmap-str.c
 F:	lib/bitmap.c
_

Patches currently in -mm which might be from yury.norov@gmail.com are


