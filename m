Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965D0423E9C
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816318; cv=none; b=e+chOuh79E0lW0T8B0Cv8m7KKCtAPtr18BpXH/xlcSZ8kpkGOndfexIGC7hBC9cT+fcWRsNekqiVUAVAuvjy+4IoavXCpqV6wRdwRD0vNWynDylGZ6bXa8QK41tPDgv/t846UKFH3+Ds0Rn+6m/46OvDXgTvYtIeBBINE2uOCcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816318; c=relaxed/simple;
	bh=pfUKkTN7IKT/jLrovpYLAja/+qB+pjPGUFaQozfH73k=;
	h=Date:To:From:Subject:Message-Id; b=MYswYjGnANSp2NFQtEO9NsIjaVHVg+YSgMnhFbv5K8VwF2puLqGuOmLqUy6tydG2eEdmjmzDYeDjwMURXCF47+6jH/sbYSxWNhwUa9YiYNgC4DW138Y6yaXwlRwO/FRFOp8F7ueAhn2c4dam00lRlAy2T5fCyojgsTj7tR98AxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PJPSfJS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PJPSfJS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6D41F00A3A;
	Tue,  4 Aug 2026 04:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816316;
	bh=VZ7EZZEhgtBHMvlhCy+4TinmWAlqUnQUxVWPPaLiuMk=;
	h=Date:To:From:Subject;
	b=PJPSfJS2E1H8gvRHB2r6WXvYdwc6jz9TaKAQ1OzTTUxlUP+GhAUtCEe977TMfgcuj
	 kWD+iAi60x+pxK54Ocv14U7LCjm2z8q8qzGiU1oR4XGF1WAgtzrJoQUdczioEFKNcm
	 g2ZHX1rWsUVlBetx4eqE7j8aQLzT65d6LFLS91Qc=
Date: Mon, 03 Aug 2026 21:05:16 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,ljs@kernel.org,liam@infradead.org,kees@kernel.org,dietmar.eggemann@arm.com,jansef.jian@hj-micro.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-fork-declare-max_threads-__read_mostly.patch removed from -mm tree
Message-Id: <20260804040516.6D6D41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/fork: declare max_threads __read_mostly
has been removed from the -mm tree.  Its filename was
     kernel-fork-declare-max_threads-__read_mostly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: JianChunfu <jansef.jian@hj-micro.com>
Subject: kernel/fork: declare max_threads __read_mostly
Date: Tue, 7 Jul 2026 17:23:54 +0800

max_threads is initialized once by fork_init()->set_max_threads(), and
thereafter is mostly read in hot path, such as copy_process().

The fact that it is mostly read and not written to makes it candidates for
__read_mostly declarations.

I have already tested on my machine(arm64,256core,kernel-7.1.3) with
'hackbench -P -l 500 -g 100/500/1000/2000' and the results show that there
is an average of 13% improvement in performance.

before patch:
	hackbench -g    100      500      1000      2000
                    1.094    4.651    13.305    36.322

after patch:
	hackbench -g    100      500      1000      2000
                    0.823    4.487    11.107    32.987

Above data are the average values obtained from multiple tests, and there
was indeed some fluctuation in the data during the tests.

Link: https://lore.kernel.org/20260707092354.465847-1-jansef.jian@hj-micro.com
Signed-off-by: JianChunfu <jansef.jian@hj-micro.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~kernel-fork-declare-max_threads-__read_mostly
+++ a/kernel/fork.c
@@ -143,7 +143,7 @@
 unsigned long total_forks;	/* Handle normal Linux uptimes. */
 int nr_threads;			/* The idle threads do not count.. */
 
-static int max_threads;		/* tunable limit on nr_threads */
+static int max_threads __read_mostly;		/* tunable limit on nr_threads */
 
 #define NAMED_ARRAY_INDEX(x)	[x] = __stringify(x)
 
_

Patches currently in -mm which might be from jansef.jian@hj-micro.com are


