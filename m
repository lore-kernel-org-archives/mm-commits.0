Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DE210785
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 20:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783456533; cv=none; b=Vwy0+ZGT9W9XCiQTCyuQxGFFz5bjkjTfaKpdXCaPCrXYmhiTRCad9SdyAZdGhs4FZ3mGKBA5+FzaKsRpYHZHO7GfvBFZGD0ZZkIx0XZG3BRC/EQ7lgAaTyxy5J/n98Cewqcfwb/AUmA+rF88lXyx6zX6dWGqEdBnaMvODnxZD88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783456533; c=relaxed/simple;
	bh=D9+LsjXmwSq3SDKQd/AsRaaF7jTLj+Y1sl2aSRvrBL0=;
	h=Date:To:From:Subject:Message-Id; b=E/lNQ+gWTdZIas2pM6OVF6f8MCiP9wP+4Pa14ytjO3U4nQ73dRc1ehiOaaboTbNIW5aP+/gEbv3Nr4RI7RHdhZL5sYG1QU6E9uTEKanBJjgdlYygD2xz+LyhQ0ZxODfLL24yk+xUbL38mk1qJGyGKqmvEBUCGuVUsWmyycB4EJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZmA4IwSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZmA4IwSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CDA1F000E9;
	Tue,  7 Jul 2026 20:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783456532;
	bh=GRBMBMrDCu3WqMXbG/CH7WAXv/YPLXXuU/ONB1Jnh/Q=;
	h=Date:To:From:Subject;
	b=ZmA4IwSnrKB396d4WeYOX354x9yXXRNgUJQ2b3yj5rEjU47eIa6g5btb9sy4lDWiF
	 Ka8k+RN27zFQw/ImGuFQlvcurK9fs+4Q8ZTF9Tlf0kt9WEq3gZHMs3eMGfpvE6yM2e
	 nJQ/gEsfpWNsp0slREP5HbizHc30tArqwktGYjCs=
Date: Tue, 07 Jul 2026 13:35:31 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,ljs@kernel.org,liam@infradead.org,kees@kernel.org,dietmar.eggemann@arm.com,jansef.jian@hj-micro.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-declare-max_threads-__read_mostly.patch added to mm-nonmm-unstable branch
Message-Id: <20260707203532.46CDA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/fork: declare max_threads __read_mostly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-fork-declare-max_threads-__read_mostly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-declare-max_threads-__read_mostly.patch

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
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

kernel-fork-declare-max_threads-__read_mostly.patch

