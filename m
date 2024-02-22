Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E011381
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560114; cv=none; b=poIFVlv8upGk5GB2OtqN2Rby7yuV525alBKTE08cxhTuYmN2ZOeWxa5iVipvAyS+pevXTpQA8yYma6WMRn8ki7ndQuAl+LflugpD6u8PdsExRQZzuxWmPZkUgRt3zPzEr35zuUB7SBqzqHS3WWpNfG7DEUywPEDBfz+8FIxVKdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560114; c=relaxed/simple;
	bh=JsILgPe014xdWlQZJ3dlZVJ4jf/zco+2k1HIFtxfbWA=;
	h=Date:To:From:Subject:Message-Id; b=o/g7jNjkYmYGSiINaXJ5XZp8dXT/Ksa8+7aTvrS15uw5TaufdtWSMhJqn+UWCGFBXyDqNt9pMvGj5Pv9+vKf8p52Q97g4hEKEu7dMlXt6UM4OjjwG+6Dq5fMb9/OBAtwwdPsRO1LJBrBPvCtkatFLXJpQX0e40NdkSBtoM2+/TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KC0lNSCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KC0lNSCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA128C43394;
	Thu, 22 Feb 2024 00:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560113;
	bh=JsILgPe014xdWlQZJ3dlZVJ4jf/zco+2k1HIFtxfbWA=;
	h=Date:To:From:Subject:From;
	b=KC0lNSCBcdB+cXsXDBCGaSAM3Ijnv11v8G7Cb8LTKObcv1VISd+6CX64tGchT24R+
	 agGgYyW3WVCmeyPkHmmQTJfTWfBw6gEnOoDdws+3ZLmXtAUrtzYYQC8XslWZjWqogc
	 zCSX80sJJH7UnZLcYV0ggKqoQhniK2yaQaaN8r88=
Date: Wed, 21 Feb 2024 16:01:53 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-inline-and-remove-zswap_entry_find_get.patch removed from -mm tree
Message-Id: <20240222000153.CA128C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: inline and remove zswap_entry_find_get()
has been removed from the -mm tree.  Its filename was
     mm-zswap-inline-and-remove-zswap_entry_find_get.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: inline and remove zswap_entry_find_get()
Date: Mon, 29 Jan 2024 20:36:38 -0500

There is only one caller and the function is trivial. Inline it.

Link: https://lkml.kernel.org/r/20240130014208.565554-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/mm/zswap.c~mm-zswap-inline-and-remove-zswap_entry_find_get
+++ a/mm/zswap.c
@@ -558,19 +558,6 @@ static void zswap_entry_put(struct zswap
 	}
 }
 
-/* caller must hold the tree lock */
-static struct zswap_entry *zswap_entry_find_get(struct rb_root *root,
-				pgoff_t offset)
-{
-	struct zswap_entry *entry;
-
-	entry = zswap_rb_search(root, offset);
-	if (entry)
-		zswap_entry_get(entry);
-
-	return entry;
-}
-
 /*********************************
 * shrinker functions
 **********************************/
@@ -1708,13 +1695,13 @@ bool zswap_load(struct folio *folio)
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
-	/* find */
 	spin_lock(&tree->lock);
-	entry = zswap_entry_find_get(&tree->rbroot, offset);
+	entry = zswap_rb_search(&tree->rbroot, offset);
 	if (!entry) {
 		spin_unlock(&tree->lock);
 		return false;
 	}
+	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 
 	if (entry->length)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


