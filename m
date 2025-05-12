Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1FD1A239D
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011344; cv=none; b=ESCzKskodTzDb3nJpUbG7X8WPvXz31OdepAmzQ0vpxfvYDVZoTtIHFb8WKRh5AlAAdBNt1bwMsKxPxyEaCJ2izDWX7Z+R6dt27ZZHziHEJBrPe08yRA40LeipjEOleDg8wpAfKtuiLR4tmne5bSW3G6BcQ1DNqg4TgUfl+aSRGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011344; c=relaxed/simple;
	bh=sAiYhgvM9nrlLc/QgZo2wPqbUW3dcKh9/uSpEavPgxE=;
	h=Date:To:From:Subject:Message-Id; b=sKATWf7voXmNqZObDTFHpHKeSU96losn3USE+mhTh2P/AMYOiASWv8wEDPzxamCH780fP+7tdf/jiV/Sb+tapaYpTyU0pVvukZYcVQ4VtWdIsFbu2D48Oh48PsrVGA87PBtbPdpcwBG9nGGV7ENl2UBkju0fHhqH7utV5t+1Wq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xNfvzTDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xNfvzTDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337D4C4CEE4;
	Mon, 12 May 2025 00:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011343;
	bh=sAiYhgvM9nrlLc/QgZo2wPqbUW3dcKh9/uSpEavPgxE=;
	h=Date:To:From:Subject:From;
	b=xNfvzTDwlj/FYO5+RRi7mUbSiVMSJLn/Qsy+xiFsNRQn/Jn0E99smv2YrjY3RYfbz
	 QayLvP2oduiYdZhrbZPlbUZAjZwNdNKVaoabn/nFLzNFkkTTLpsBYzjlfPDe1npocq
	 EbFkyqtnXQCxNSixtffEJ77KaVz8E+Kdzb9YJcEE=
Date: Sun, 11 May 2025 17:55:42 -0700
To: mm-commits@vger.kernel.org,zxcvb600870024@gmail.com,johnny1001s000602@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-rbtreec-fix-the-example-typo.patch removed from -mm tree
Message-Id: <20250512005543.337D4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/rbtree.c: fix the example typo
has been removed from the -mm tree.  Its filename was
     lib-rbtreec-fix-the-example-typo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chisheng Chen <johnny1001s000602@gmail.com>
Subject: lib/rbtree.c: fix the example typo
Date: Thu, 3 Apr 2025 19:26:14 +0800

Replace `sr` with `Sr`.  The condition `!tmp1 || rb_is_black(tmp1)`
ensures that `tmp1` (which is `sibling->rb_right`) is either NULL or a
black node.  Therefore, the right child of the sibling must be black, and
the example should use `Sr` instead of `sr`.

Link: https://lkml.kernel.org/r/20250403112614.570140-1-johnny1001s000602@gmail.com
Signed-off-by: Chisheng Chen <johnny1001s000602@gmail.com>
Cc: Hsin Chang Yu <zxcvb600870024@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/rbtree.c~lib-rbtreec-fix-the-example-typo
+++ a/lib/rbtree.c
@@ -297,9 +297,9 @@ ____rb_erase_color(struct rb_node *paren
 				 *   / \           / \
 				 *  N   S    -->  N   sl
 				 *     / \             \
-				 *    sl  sr            S
+				 *    sl  Sr            S
 				 *                       \
-				 *                        sr
+				 *                        Sr
 				 *
 				 * Note: p might be red, and then both
 				 * p and sl are red after rotation(which
@@ -312,9 +312,9 @@ ____rb_erase_color(struct rb_node *paren
 				 *   / \            /  \
 				 *  N   sl   -->   P    S
 				 *       \        /      \
-				 *        S      N        sr
+				 *        S      N        Sr
 				 *         \
-				 *          sr
+				 *          Sr
 				 */
 				tmp1 = tmp2->rb_right;
 				WRITE_ONCE(sibling->rb_left, tmp1);
_

Patches currently in -mm which might be from johnny1001s000602@gmail.com are


