Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E7512D758
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736216093; cv=none; b=EdscpLSikYnBkaYXh8ZwX8gOjkMAUsf9n8RGwmDDxyLKizX+uSFTHJUlgtifrGlP0kflU7IiYmcMiCWrDg8WAxHnM3zWCIJ5B1t8iPdX0097RDclLWdxjv2NmAUUx95FShMT/zpzgwEDc0V9Asls6c20wPQD7dfM4lNIxCOCDIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736216093; c=relaxed/simple;
	bh=KJZx5TnLQhOA/jwncF6nXE5NpON82H/ig6DAHIN7GGk=;
	h=Date:To:From:Subject:Message-Id; b=XslrVACeR0TL98/UOL6qDG/MkxIV+9iznrThoDSl1mfhc2YwFpWrruBas7yZ26sWBltBrKIGSQ9hS4HAHTwtnAUcL5+7rW0Q+bqCZXNf6RgQTF4sJsmsL58gLWJvYbXiSpw8CmyBcd3+bQOTkqZbf7pbIhJ4exjokLAoMwIqAHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yyAQNSVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yyAQNSVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAC5C4CEDD;
	Tue,  7 Jan 2025 02:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736216093;
	bh=KJZx5TnLQhOA/jwncF6nXE5NpON82H/ig6DAHIN7GGk=;
	h=Date:To:From:Subject:From;
	b=yyAQNSVBnfT0A4lpr8EAMZQJu/zFPOa0NRWr2bSfbVGo5yHiGqp+sCI0QAoQFjezm
	 snjHZ82i9afsi5oPC1kvy3W9wJGKS32xHgGLzMzp9mtvEwzOj/WeAOMQMGKe1MiUB5
	 2RpgwCSH4mJYKW5iso+NWEm6qKjeC0R6gJIc+mTY=
Date: Mon, 06 Jan 2025 18:14:52 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,chuang@cs.nycu.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-list_sort-clarify-comparison-function-requirements-in-list_sort.patch added to mm-nonmm-unstable branch
Message-Id: <20250107021453.1EAC5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/list_sort: clarify comparison function requirements in list_sort()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-list_sort-clarify-comparison-function-requirements-in-list_sort.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-list_sort-clarify-comparison-function-requirements-in-list_sort.patch

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
Subject: lib/list_sort: clarify comparison function requirements in list_sort()
Date: Tue, 7 Jan 2025 01:01:04 +0800

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
Link: https://lkml.kernel.org/r/20250106170104.3137845-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: <chuang@cs.nycu.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/lib/list_sort.c~lib-list_sort-clarify-comparison-function-requirements-in-list_sort
+++ a/lib/list_sort.c
@@ -108,6 +108,13 @@ static void merge_final(void *priv, list
  * and list_sort is a stable sort, so it is not necessary to distinguish
  * the @a < @b and @a == @b cases.
  *
+ * The comparison function must adhere to specific mathematical properties
+ * to ensure correct and stable sorting:
+ * - Antisymmetry: cmp(@a, @b) must return the opposite sign of
+ * cmp(@b, @a).
+ * - Transitivity: if cmp(@a, @b) <= 0 and cmp(@b, @c) <= 0, then
+ * cmp(@a, @c) <= 0.
+ *
  * This is compatible with two styles of @cmp function:
  * - The traditional style which returns <0 / =0 / >0, or
  * - Returning a boolean 0/1.
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch
lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch
lib-min_heap-add-brief-introduction-to-min-heap-api.patch
documentation-core-api-min_heap-add-author-information.patch
lib-sort-clarify-comparison-function-requirements-in-sort_r.patch
lib-list_sort-clarify-comparison-function-requirements-in-list_sort.patch

