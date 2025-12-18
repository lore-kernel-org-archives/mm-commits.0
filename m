Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9DC3128DF
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 23:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766100812; cv=none; b=bBlRxcJgXjanDvUa6BLwag0cF5R3PjM7uMteHDxKqTp8xnZLJSJIMi5Sb2p5TQoIf3/Grpggq5ox3LBAgI2TPsoMKsrKr91lQP89meIDsiC+rAdxn8KuLxetxNI6CnRFDbGfNRU+cHX3rGAndPjN362OMNNHjhX04lhGWvslgVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766100812; c=relaxed/simple;
	bh=QIFxIm8ZhFYPGdUBkocPIhWO8gtkjLQSb95n2LXOWmg=;
	h=Date:To:From:Subject:Message-Id; b=ICdUyABIGKYmMX2iaRhu1FSdzxmNGIIH8F3cj+6SmfWLP4IMPbxSSW7Gt7fx2XPYJNBx2C0TeyI5wjnWn/nQiWOyWfyuWj0VqIS9dr3zZAmstu57q995c01VqVDI5/CUU0DSORh/JKlmVQ3+lYU6uzZ0a4PVtG1GQmqJG1+STwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w9SRuM22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w9SRuM22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D612C4CEFB;
	Thu, 18 Dec 2025 23:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766100811;
	bh=QIFxIm8ZhFYPGdUBkocPIhWO8gtkjLQSb95n2LXOWmg=;
	h=Date:To:From:Subject:From;
	b=w9SRuM22o1tQgniII/qohSAJO+2gobqkUFPMtRx00WU5XV61FCmaPN38g8BVHfBRi
	 i0qYzrxxb3EjZTFVle4sIchvBvvYKJrp0Nc+uJA8kekvnd5/gwtPAF35pCMQ0bmFoL
	 ccEkT0m2jpe8oF8YSO/xKZojX3Xj5EUtyFeJ2TPo=
Date: Thu, 18 Dec 2025 15:33:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tycho@kernel.org,oleg@redhat.com,david.laight.linux@gmail.com,brauner@kernel.org,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] ns-pad-refcount.patch removed from -mm tree
Message-Id: <20251218233331.5D612C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ns: pad refcount
has been removed from the -mm tree.  Its filename was
     ns-pad-refcount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Bench from will-it-scale:

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
Tested-by: Tycho Andersen (AMD) <tycho@kernel.org>
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

pid-only-take-pidmap_lock-once-on-alloc.patch

