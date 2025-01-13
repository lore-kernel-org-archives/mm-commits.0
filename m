Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807F325761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742257; cv=none; b=DNI2x0D2Xvz5hJ7LXEsf2cXSmsY99F3ZHGYUWF3utJ+Pf9mw6dXkEK10iJtBrE2jIvlpNEfSYSs+NxhO/gSXBMiH0imulG3Tq1vIIdILf6a2uqpNg0KlFiiyoFw15ly1srjKaFhEn7KuTgJUJkLiQRTsJTf7OW1Tr/J2fKC/vqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742257; c=relaxed/simple;
	bh=kX/Crp0DrIpsyzhL5D/9DC2Uzr9DmiBtEeIFWtaOhow=;
	h=Date:To:From:Subject:Message-Id; b=rR1xjNhqnKiq+4zK/QUoaTjj9/FXYRyRMqcMJkBoE3lCo+yEVRznpQn/YzUGtoB1cZUlJ69DAjQDAqiaoa3bSvtU/il3O97b11HYVUPTKkO90J1hNVrbUtai0C++lojDTFa0SFHkEjx5UAD0ylokCobxgnQMReIrnbQWvt9fNso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FQyCgwLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FQyCgwLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E59CC4CED6;
	Mon, 13 Jan 2025 04:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742257;
	bh=kX/Crp0DrIpsyzhL5D/9DC2Uzr9DmiBtEeIFWtaOhow=;
	h=Date:To:From:Subject:From;
	b=FQyCgwLn6JMehX8Hyrhmf7TKHuTtpHPhYI9RKwR+Jlfoilfh1tEULllf2TZgjp71S
	 FZ5RUr7PzTIWCrWyiF7IDkyiPp6qFWXjuqbP5CdZVUWOCJTVQbHlY9RtKu3/huPSXK
	 UlW7bNpqwcgNf/vP5RCSbBU7QzRPq0I9dGdcHKKw=
Date: Sun, 12 Jan 2025 20:24:16 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,chuang@cs.nycu.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-sort-clarify-comparison-function-requirements-in-sort_r.patch removed from -mm tree
Message-Id: <20250113042417.4E59CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/sort: clarify comparison function requirements in sort_r()
has been removed from the -mm tree.  Its filename was
     lib-sort-clarify-comparison-function-requirements-in-sort_r.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


