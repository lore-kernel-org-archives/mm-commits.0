Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2D1165EED
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313722; cv=none; b=E6i9V3bgQQwQ5H3HOZUhLUE/r/5OgWwGVO8GccAnb+Zmoo3IZy7g6Iwl6hMj3MDl9j12c0jAv0YyPdCu9BfPfKT2YwRSOQsnhMUkiflhSVKUMlUIbChCjqCIdnYQ1fveLFgU4mRObJgTwjfbOWsvOY4HgBoHihLvRoajBvYBgWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313722; c=relaxed/simple;
	bh=GE/L8bsU2N1Lq6b5dj+mXwKsordMvtsgvWOqx1RfMyw=;
	h=Date:To:From:Subject:Message-Id; b=cQNKaMTtyaWsJz9fDeM6JVgRx/+u0lEHUAzZD5Z0Egqf/dz5CmbSP3g2A+pvPc+jeJLhFDGCWpLIwGcqPQ7IwImKLzhmtp4mU6kishShUG6ys+AV/CH1wkRSBA5r/pHFMjCLuotwjw+1ORLIx3IIHg2P47SPccjGJZrklOLH0ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tj4nCtCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tj4nCtCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3059C4CED4;
	Mon, 11 Nov 2024 08:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313721;
	bh=GE/L8bsU2N1Lq6b5dj+mXwKsordMvtsgvWOqx1RfMyw=;
	h=Date:To:From:Subject:From;
	b=tj4nCtCryS6/9qo6Ws5WmFk0HSMjfbap+3t3i5YFM8FWxW0XKWYcRjdgs5dH1P5TI
	 AYAMD2yU29liZEZ6UmHjozfTp/ivPCoMBb/e5g2Q1evlRb96VBUdRK3DdmaUII8Dwv
	 ZsgXZ0oPfhqTRu+gvwdO20bNx2mxUY01vaV7/jZA=
Date: Mon, 11 Nov 2024 00:28:41 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-not-necessary-to-check-index-last-again.patch removed from -mm tree
Message-Id: <20241111082841.D3059C4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: not necessary to check index/last again
has been removed from the -mm tree.  Its filename was
     maple_tree-not-necessary-to-check-index-last-again.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: not necessary to check index/last again
Date: Thu, 31 Oct 2024 23:16:25 +0000

Before calling mas_new_root(), the range has been checked.

Link: https://lkml.kernel.org/r/20241031231627.14316-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-not-necessary-to-check-index-last-again
+++ a/lib/maple_tree.c
@@ -3670,7 +3670,9 @@ static inline void mas_new_root(struct m
 	void __rcu **slots;
 	unsigned long *pivots;
 
-	if (!entry && !mas->index && mas->last == ULONG_MAX) {
+	WARN_ON_ONCE(mas->index || mas->last != ULONG_MAX);
+
+	if (!entry) {
 		mas->depth = 0;
 		mas_set_height(mas);
 		rcu_assign_pointer(mas->tree->ma_root, entry);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


