Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9607917966D
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716928923; cv=none; b=HimxTLi1zmlX+cAmGebyG+chvVlcHuF29dXRGPTweQ+SuqyxiH2boRpfcCV0FvZYcAq8GEgLlqEwSBe3KKudBr8Ssr2lmL+DFsgDqbqAu0/GQRMdLgs6h1RZkB+XuRnKqDXyIbg8EOHFTp/inF5i0LlIueWNq/5+MIbZ1CkXbNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716928923; c=relaxed/simple;
	bh=0NkN/KGXcEcefCfle6MbgDX9uaIWU+F7pah6sfxbiqM=;
	h=Date:To:From:Subject:Message-Id; b=AuK7rGFkj7TD61xmNjs5aGDt8QNTQezJXs2cbaRy5Pe3Ml1E126AOP3OdUsYwJiyNTbEi0c3qTApDVVBHggXR6bXA4X6LnVrwXZe5NmcIXmKHpTSd5QlpyqDxwlpYx2bVpyTcX0ldHZEcTPh5h4fWEZKLTuyCJhGA4h//F4KVV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mq48ivHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mq48ivHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6F7C32781;
	Tue, 28 May 2024 20:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716928923;
	bh=0NkN/KGXcEcefCfle6MbgDX9uaIWU+F7pah6sfxbiqM=;
	h=Date:To:From:Subject:From;
	b=mq48ivHX0N6QHVlhFlvr6zdG4jGAZO3dgNwMJbwnkM11yhbzAqBz1zvqILELizDBc
	 T6JX/Yqhl4pYdz1hsfSmTADf2PzebOZ87NmOxF739a0EpxeV7x4zDMX7zoJ0uf6PGM
	 aRNrsCTlKx94HHqCdjkXRrYSKaGQJNkkPAP68pGU=
Date: Tue, 28 May 2024 13:42:02 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch added to mm-nonmm-unstable branch
Message-Id: <20240528204203.5E6F7C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/sort: optimize heapsort for handling final 2 or 3 elements
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/sort: optimize heapsort for handling final 2 or 3 elements
Date: Tue, 28 May 2024 04:30:10 +0800

After building the heap, the code continuously pops two elements from the
heap until only 2 or 3 elements remain, at which point it switches back to
a regular heapsort with one element popped at a time.  However, to handle
the final 2 or 3 elements, an additional else-if statement in the while
loop was introduced, potentially increasing branch misses.  Moreover, when
there are only 2 or 3 elements left, continuing with regular heapify
operations is unnecessary as these cases are simple enough to be handled
with a single comparison and 1 or 2 swaps outside the while loop.

Eliminating the additional else-if statement and directly managing cases
involving 2 or 3 elements outside the loop reduces unnecessary conditional
branches resulting from the numerous loops and conditionals in heapify.

This optimization maintains consistent numbers of comparisons and swaps
for arrays with even lengths while reducing swaps and comparisons for
arrays with odd lengths from 2.5 swaps and 1 comparison to 1.5 swaps and 1
comparison.

Link: https://lkml.kernel.org/r/20240527203011.1644280-4-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/lib/sort.c~lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements
+++ a/lib/sort.c
@@ -250,10 +250,7 @@ void sort_r(void *base, size_t num, size
 			a = size << shift;
 			n -= size;
 			do_swap(base + a, base + n, size, swap_func, priv);
-		} else if (n > size) {	/* Sorting: Extract root */
-			n -= size;
-			do_swap(base, base + n, size, swap_func, priv);
-		} else	{		/* Sort complete */
+		} else {		/* Sort complete */
 			break;
 		}
 
@@ -283,6 +280,11 @@ void sort_r(void *base, size_t num, size
 			do_swap(base + b, base + c, size, swap_func, priv);
 		}
 	}
+
+	n -= size;
+	do_swap(base, base + n, size, swap_func, priv);
+	if (n == size * 2 && do_cmp(base, base + size, cmp_func, priv) > 0)
+		do_swap(base, base + size, size, swap_func, priv);
 }
 EXPORT_SYMBOL(sort_r);
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

perf-core-fix-several-typos.patch
bcache-fix-typo.patch
bcachefs-fix-typo.patch
lib-min_heap-add-type-safe-interface.patch
lib-min_heap-add-min_heap_init.patch
lib-min_heap-add-min_heap_peek.patch
lib-min_heap-add-min_heap_full.patch
lib-min_heap-add-args-for-min_heap_callbacks.patch
lib-min_heap-add-min_heap_sift_up.patch
lib-min_heap-add-min_heap_del.patch
lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch
lib-min_heap-rename-min_heapify-to-min_heap_sift_down.patch
lib-min_heap-update-min_heap_push-to-use-min_heap_sift_up.patch
lib-test_min_heap-add-test-for-heap_del.patch
bcache-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
lib-sort-remove-unused-pr_fmt-macro.patch
lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch
lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch
lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch

