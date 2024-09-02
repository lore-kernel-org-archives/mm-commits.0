Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862726F2FE
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247831; cv=none; b=ISZAVbprIw3U9Ik8mUB27oyakVqWomPbIkwFA5pxIf2HsSQTWznDgVWyQSvW+rJnMAyqpsEZK/c3ruzb9WXzXo1AVzxXU073YuKuJwUeIboYJs/B43B3KIoV5j4VgrLtfFJAjYv4E9IflWGCD2owNmQ3x90qAKXrBMh/fm283u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247831; c=relaxed/simple;
	bh=ZuGilMaocCzsFsWMUv1yIFJlK6bI/3Xcip17jpSgLZU=;
	h=Date:To:From:Subject:Message-Id; b=E0TcPHBD0QXPGLdkYEXjWoSr7v7lSrG5aH3LoKJ9bb4yfm8N27Tl2eLDLelR+xbkbV7ht4B7ecWRKxcF4nHMDfITMbiBdEm5ol1GiK25A7wWgWEf27l5WH31mHPPeEWFVxNu+c98X/48Ppqr22jabx0u1jrBXfBGuMHYMm7KAhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mMIqKmkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mMIqKmkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59275C4CEC2;
	Mon,  2 Sep 2024 03:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247831;
	bh=ZuGilMaocCzsFsWMUv1yIFJlK6bI/3Xcip17jpSgLZU=;
	h=Date:To:From:Subject:From;
	b=mMIqKmkJ8zHZgHDshJoJKFhZi/jZSOX38Fw2JvsMWvhGflXfNbEJEmtPO7GszDz6V
	 B49U4jTvJzycnZbCrenc99puhZFEZ8mK1godfgAWdndYD70Y5HqaZukmPBILiMbaiJ
	 yvx7CYTSkM9Wu0+cf5t1JHD81AtZTunCzPNCuQu0=
Date: Sun, 01 Sep 2024 20:30:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-mas_store_gfp-in-mtree_store_range.patch removed from -mm tree
Message-Id: <20240902033031.59275C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use mas_store_gfp() in mtree_store_range()
has been removed from the -mm tree.  Its filename was
     maple_tree-use-mas_store_gfp-in-mtree_store_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: use mas_store_gfp() in mtree_store_range()
Date: Wed, 14 Aug 2024 12:19:34 -0400

Refactor mtree_store_range() to use mas_store_gfp() which will abstract
the store, memory allocation, and error handling.

Link: https://lkml.kernel.org/r/20240814161944.55347-8-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_store_gfp-in-mtree_store_range
+++ a/lib/maple_tree.c
@@ -6476,7 +6476,6 @@ int mtree_store_range(struct maple_tree
 		unsigned long last, void *entry, gfp_t gfp)
 {
 	MA_STATE(mas, mt, index, last);
-	MA_WR_STATE(wr_mas, &mas, entry);
 	int ret = 0;
 
 	trace_ma_write(__func__, &mas, 0, entry);
@@ -6487,17 +6486,9 @@ int mtree_store_range(struct maple_tree
 		return -EINVAL;
 
 	mtree_lock(mt);
-retry:
-	mas_wr_store_entry(&wr_mas);
-	if (mas_nomem(&mas, gfp))
-		goto retry;
-
+	ret = mas_store_gfp(&mas, entry, gfp);
 	mtree_unlock(mt);
 
-	if (mas_is_err(&mas))
-		ret = xa_err(mas.node);
-
-	mas_destroy(&mas);
 	return ret;
 }
 EXPORT_SYMBOL(mtree_store_range);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


