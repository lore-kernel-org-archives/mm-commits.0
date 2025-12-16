Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B001253F13
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 23:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765928484; cv=none; b=l10xYuPRrhj9++O39DerjQd4Uvh99OmPE/hTNpX8ysP7Jxzy/WFfHjN1zSvbkotYzqCh1bnkGk0HfZepI4TBJHxIbFSByNava3Nh/VJIvzSrv6PjBJ8wDTRh4iidQnTnLd4d5s2owAayCaRY1h6sFFFqSxG7ycWyuDCUwcwNP84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765928484; c=relaxed/simple;
	bh=pa5AXshgjvLC1FozOMbO8yNIw1LYQFwXHliOcG60LBM=;
	h=Date:To:From:Subject:Message-Id; b=KumU+sR3Hc43p/HqXQlSCaMNNNkD5Xhc5hWocb08hKYeuEMxGxJeJhTSizfWsn3gJwp479w0wttwopbxQ4SF+3L8bf+cJK4B7PBbGsqzMRuNF2iimPHc8fWsodkEVGaPmfi6v9z/tqXPIDhRf9bct2/GWLcQXvYQvy/QqJEk//Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KHfn87fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KHfn87fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9B2C4CEF1;
	Tue, 16 Dec 2025 23:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765928483;
	bh=pa5AXshgjvLC1FozOMbO8yNIw1LYQFwXHliOcG60LBM=;
	h=Date:To:From:Subject:From;
	b=KHfn87fcpHssW71WZApPx2xLOW2rZYGX+rg6VWrPmwm92HUga3aTahurIGQBcKyGi
	 7KDlaKmhkzYHcUYvfiIXFe12nMCDXV24xTxG/IwLOOlJV1SmiGPCxtDEoDC34nIuA0
	 Zdz716xxsAyz4jv8MgY5kLq1S3oMWXPf+m85Kltc=
Date: Tue, 16 Dec 2025 15:41:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oleg@redhat.com,david.laight.linux@gmail.com,brauner@kernel.org,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ns-pad-refcount.patch added to mm-nonmm-unstable branch
Message-Id: <20251216234123.0C9B2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ns: pad refcount
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ns-pad-refcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ns-pad-refcount.patch

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
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: ns: pad refcount
Date: Sat, 6 Dec 2025 14:19:54 +0100

Patch series "further damage-control lack of clone scalability", v3.

When spawning and killing threads in separate processes in parallel the
primary bottleneck on the stock kernel is pidmap_lock, largely because of
a back-to-back acquire in the common case.

Benchmark code at the end.

With this patchset alloc_pid() only takes the lock once and consequently
alleviates the problem.  While scalability improves, the lock remains the
primary bottleneck by a large margin.

I believe idr is a poor choice for the task at hand to begin with, but
sorting out that out beyond the scope of this patchset.  At the same time
any replacement would be best evaluated against a state where the above
relock problem is fixed.

Performance improvement varies between reboots.  When benchmarking with 20
processes creating and killing threads in a loop, the unpatched baseline
hovers around 465k ops/s, while patched is anything between ~510k ops/s
and ~560k depending on false-sharing (which I only minimally sanitized). 
So this is at least 10% if you are unlucky.

bench from will-it-scale:

#include <assert.h>
#include <pthread.h>

char *testcase_description = "Thread creation and teardown";

static void *worker(void *arg)
{
        return (NULL);
}

void testcase(unsigned long long *iterations, unsigned long nr)
{
        pthread_t thread[1];
        int error;

        while (1) {
                for (int i = 0; i < 1; i++) {
                        error = pthread_create(&thread[i], NULL, worker, NULL);
                        assert(error == 0);
                }
                for (int i = 0; i < 1; i++) {
                        error = pthread_join(thread[i], NULL);
                        assert(error == 0);
                }
                (*iterations)++;
        }
}


This patch (of 2):

Note no effort is made to make sure structs embedding the namespace are
themselves aligned, so this is not guaranteed to eliminate cacheline
bouncing due to refcount management.

Link: https://lkml.kernel.org/r/20251206131955.780557-1-mjguzik@gmail.com
Link: https://lkml.kernel.org/r/20251206131955.780557-2-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ns/ns_common_types.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/ns/ns_common_types.h~ns-pad-refcount
+++ a/include/linux/ns/ns_common_types.h
@@ -108,11 +108,13 @@ extern const struct proc_ns_operations u
  * @ns_tree: namespace tree nodes and active reference count
  */
 struct ns_common {
+	struct {
+		refcount_t __ns_ref; /* do not use directly */
+	} ____cacheline_aligned_in_smp;
 	u32 ns_type;
 	struct dentry *stashed;
 	const struct proc_ns_operations *ops;
 	unsigned int inum;
-	refcount_t __ns_ref; /* do not use directly */
 	union {
 		struct ns_tree;
 		struct rcu_head ns_rcu;
_

Patches currently in -mm which might be from mjguzik@gmail.com are

ns-pad-refcount.patch
pid-only-take-pidmap_lock-once-on-alloc.patch

