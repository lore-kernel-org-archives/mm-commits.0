Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0A918870C
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 22:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735251264; cv=none; b=uwCXNVuWiVjHwslCmBXz6kIwQkQaORJrZpv9oG1/XM423z9hpbAazvaxH81idhf6HivYEk4YFtsEBupEbsfYZ8yGO3V/p+jqPXWnQHCMhzAl3uwcwtNtRXeLjaq68ZePDrahPYwfILzLBnqrlVunCvnvU/bk5AYOZ1Grl2kFBus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735251264; c=relaxed/simple;
	bh=dsvZdnXVDuW8zY3QUftHQ7pv90N6K5BkhfRkjvF6ouY=;
	h=Date:To:From:Subject:Message-Id; b=JQSGqY/p2gHkx9KuX6njGvuRafJHG1LLPdL2RnFvw4EE+wrxR6eeKmjB+zXfqvY1sjZV5FdNvb4E2tB5iVl6GEuiwO4EeLSQotK8jrHkWN9dhnsBJ/l3t6Scae/xxAj368K+u93maDkj7vHdHFAmesWtRIb/XBLZqOf940k9+GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rOU3kpCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rOU3kpCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3ACEC4CED1;
	Thu, 26 Dec 2024 22:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735251263;
	bh=dsvZdnXVDuW8zY3QUftHQ7pv90N6K5BkhfRkjvF6ouY=;
	h=Date:To:From:Subject:From;
	b=rOU3kpCvDS5hzCTvhwBKGEOwIY6b+No1bz6sb+XEsAd6U3CK26MFpXyfgkEa12rfB
	 zOMb38HoBUCiG4q967aVlFDRiIDPClpF5fGH/5fhHlrF5pped2eNwhLZViCIXzBwgC
	 fH5oO25qs7shBUDHtbPZeMyUsUQ4IzFrRqHqfB9A=
Date: Thu, 26 Dec 2024 14:14:23 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,chuang@cs.nycu.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-list_sort-clarify-comparison-function-requirements-in-sort_r.patch added to mm-nonmm-unstable branch
Message-Id: <20241226221423.A3ACEC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/list_sort: clarify comparison function requirements in sort_r()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-list_sort-clarify-comparison-function-requirements-in-sort_r.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-list_sort-clarify-comparison-function-requirements-in-sort_r.patch

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
Subject: lib/list_sort: clarify comparison function requirements in sort_r()
Date: Wed, 25 Dec 2024 00:39:27 +0800

Add a detailed explanation in the list_sort() kernel doc comment
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
Link: https://lkml.kernel.org/r/20241224163927.2558195-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: <chuang@cs.nycu.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/lib/list_sort.c~lib-list_sort-clarify-comparison-function-requirements-in-sort_r
+++ a/lib/list_sort.c
@@ -108,6 +108,13 @@ static void merge_final(void *priv, list
  * and list_sort is a stable sort, so it is not necessary to distinguish
  * the @a < @b and @a == @b cases.
  *
+ * The comparison function must adhere to specific mathematical properties
+ * to ensure correct and stable sorting:
+ * - Antisymmetry: cmp(@a, @b) must return the opposite sign of
+ *   cmp(@b, @a).
+ * - Transitivity: if cmp(@a, @b) <= 0 and cmp(@b, @c) <= 0, then
+ *   cmp(@a, @c) <= 0.
+ *
  * This is compatible with two styles of @cmp function:
  * - The traditional style which returns <0 / =0 / >0, or
  * - Returning a boolean 0/1.
_

Patches currently in -mm which might be from visitorckw@gmail.com are

scripts-sorttable-fix-orc_sort_cmp-to-maintain-symmetry-and-transitivity.patch
lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch
lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch
lib-min_heap-add-brief-introduction-to-min-heap-api.patch
documentation-core-api-min_heap-add-author-information.patch
lib-sort-clarify-comparison-function-requirements-in-sort_r.patch
lib-list_sort-clarify-comparison-function-requirements-in-sort_r.patch

