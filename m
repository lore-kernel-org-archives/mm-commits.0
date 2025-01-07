Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B942E7346F
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736216091; cv=none; b=STcTrpmlwIKdmhV3zfxqwhdYBPJKgJzCs8zN+Qf95+9t59Qzu5fvjEQgNgEmppAqe7WnkC65DPMPjuCcyDqOIx5DPVuVQXNG8VoNnedh35v1TIyd0kQsytR48Y9Zji76Tk9uww+T2XBfsMnA9sR3H8qrBRAL02NtFUs0CnSt8iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736216091; c=relaxed/simple;
	bh=yPoi5Y6REp3HSM12cGiI3SuOpX9guSJIbbrKnnLs3so=;
	h=Date:To:From:Subject:Message-Id; b=C4aa+3+qbPO/sWDEr3cFZIFp8Cm+vS5uxFh4crXgUK2jXPo7vw48oVxym6HMFGOmPIPjW7dekn7twPojpaCPEoLikKRLHtGMKGkAjSzJ72AJJIExUw5iynds30EtJSBqI2/Nhsdhzu/d4VCWrt0LzZGZFCt3D/Z0WtMfCEzRkQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YRkXRF23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YRkXRF23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFCCC4CED2;
	Tue,  7 Jan 2025 02:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736216091;
	bh=yPoi5Y6REp3HSM12cGiI3SuOpX9guSJIbbrKnnLs3so=;
	h=Date:To:From:Subject:From;
	b=YRkXRF23BP8oo8e1AFY6DA3vSATYA1CJpSmqOvJrIU2xxtDKAjB+6sFvH+tJfy2qy
	 mDAk/Dxll6LbyJxG+yKp9QDvNKTb5XpgJ1LOMELcspa7OdDns4PfwuU1tQ6e2YeqPl
	 Vwk0NdDNMvdsJdB6oE2FHeso8dIutEfmLnhDyE9U=
Date: Mon, 06 Jan 2025 18:14:50 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,chuang@cs.nycu.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sort-clarify-comparison-function-requirements-in-sort_r.patch added to mm-nonmm-unstable branch
Message-Id: <20250107021451.3DFCCC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/sort: clarify comparison function requirements in sort_r()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sort-clarify-comparison-function-requirements-in-sort_r.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sort-clarify-comparison-function-requirements-in-sort_r.patch

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
Subject: lib/sort: clarify comparison function requirements in sort_r()
Date: Tue, 7 Jan 2025 01:01:03 +0800

Patch series "lib: clarify comparison function requirements", v2.

Add a detailed explanation in the sort_r/list_sort kernel doc comment
specifying that the comparison function must satisfy antisymmetry and
transitivity.  These properties are essential for the sorting algorithm to
produce correct results.

Issues have arisen in the past [1][2][3][4] where comparison functions
violated the transitivity property, causing sorting algorithms to fail to
correctly order elements.  While these requirements may seem
straightforward, they are commonly misunderstood or overlooked, leading to
bugs.  Highlighting these properties in the documentation will help
prevent such mistakes in the future.

Link: https://lore.kernel.org/lkml/20240701205639.117194-1-visitorckw@gmail.com [1]
Link: https://lore.kernel.org/lkml/20241203202228.1274403-1-visitorckw@gmail.com [2]
Link: https://lore.kernel.org/lkml/20241209134226.1939163-1-visitorckw@gmail.com [3]
Link: https://lore.kernel.org/lkml/20241209145728.1975311-1-visitorckw@gmail.com [4]


This patch (of 2):

Add a detailed explanation in the sort_r() kernel doc comment specifying
that the comparison function must satisfy antisymmetry and transitivity. 
These properties are essential for the sorting algorithm to produce
correct results.

Issues have arisen in the past [1][2][3][4] where comparison functions
violated the transitivity property, causing sorting algorithms to fail to
correctly order elements.  While these requirements may seem
straightforward, they are commonly misunderstood or overlooked, leading to
bugs.  Highlighting these properties in the documentation will help
prevent such mistakes in the future.

Link: https://lkml.kernel.org/r/20250106170104.3137845-1-visitorckw@gmail.com
Link: https://lore.kernel.org/lkml/20240701205639.117194-1-visitorckw@gmail.com [1]
Link: https://lore.kernel.org/lkml/20241203202228.1274403-1-visitorckw@gmail.com [2]
Link: https://lore.kernel.org/lkml/20241209134226.1939163-1-visitorckw@gmail.com [3]
Link: https://lore.kernel.org/lkml/20241209145728.1975311-1-visitorckw@gmail.com [4]
Link: https://lkml.kernel.org/r/20250106170104.3137845-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: <chuang@cs.nycu.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/lib/sort.c~lib-sort-clarify-comparison-function-requirements-in-sort_r
+++ a/lib/sort.c
@@ -200,6 +200,13 @@ static size_t parent(size_t i, unsigned
  * copy (e.g. fix up pointers or auxiliary data), but the built-in swap
  * avoids a slow retpoline and so is significantly faster.
  *
+ * The comparison function must adhere to specific mathematical
+ * properties to ensure correct and stable sorting:
+ * - Antisymmetry: cmp_func(a, b) must return the opposite sign of
+ * cmp_func(b, a).
+ * - Transitivity: if cmp_func(a, b) <= 0 and cmp_func(b, c) <= 0, then
+ * cmp_func(a, c) <= 0.
+ *
  * Sorting time is O(n log n) both on average and worst-case. While
  * quicksort is slightly faster on average, it suffers from exploitable
  * O(n*n) worst-case behavior and extra memory requirements that make
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch
lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch
lib-min_heap-add-brief-introduction-to-min-heap-api.patch
documentation-core-api-min_heap-add-author-information.patch
lib-sort-clarify-comparison-function-requirements-in-sort_r.patch
lib-list_sort-clarify-comparison-function-requirements-in-list_sort.patch

