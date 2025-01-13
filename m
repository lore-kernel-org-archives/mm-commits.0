Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1F8170A30
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742258; cv=none; b=ouSlj24WrPR/KO9SlW3TIhdC7ozb1m2hTiAyGbTTE1VARNBWg0UTKcTGysYRypKIgXUR9alq6gxXIM+s2c+cUtJxhbEu/kPnTKxsb82E9HCd8Dx37TkJF4g88WeWjBmjl8LHGqZSo3ldtNB1Khl4NYOjcmXB4QhIg7o3r2cJBp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742258; c=relaxed/simple;
	bh=Fdbt0giHFJAxy1bhPgsHSeAQndRsP4Pej0pgFi9DdRY=;
	h=Date:To:From:Subject:Message-Id; b=WlhG9vX8JtV6AyLz8uBLPxahcABlXJ7tlicFL9RjUEQNz5Po3aFYYzBjGzE+d/ZfM3uZocUexH/63xMb40l6mGUu+8WAitNH9g3WOIsoGsYC3+rd5wzuL7QdsxOGSGG6VuH2EB2YZs9T/Hv8+Av1r+OaH/LEFP9+Gqn6IlrFGcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MqpZweXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MqpZweXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DA8C4CED6;
	Mon, 13 Jan 2025 04:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742258;
	bh=Fdbt0giHFJAxy1bhPgsHSeAQndRsP4Pej0pgFi9DdRY=;
	h=Date:To:From:Subject:From;
	b=MqpZweXfTpPhP4OR7QYKd2MFG/hknGRcaeJWauB6UJD0awOXcoh3c/5rviAJjMB6Z
	 e4d7CmqXTpzd+VomlpdiQVQmvAMQnpYeOkexFKECICM+E4mMjmFKOZVC8DzFtC733E
	 rDvjyfx5JzIXZgAKd33FWNz6Q7U+sztUWbz/DnLg=
Date: Sun, 12 Jan 2025 20:24:18 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,chuang@cs.nycu.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-list_sort-clarify-comparison-function-requirements-in-list_sort.patch removed from -mm tree
Message-Id: <20250113042418.A0DA8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/list_sort: clarify comparison function requirements in list_sort()
has been removed from the -mm tree.  Its filename was
     lib-list_sort-clarify-comparison-function-requirements-in-list_sort.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


