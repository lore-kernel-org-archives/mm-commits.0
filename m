Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538C93B8948
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786047540; cv=none; b=CbfrSYRQtepvA0yfyPK1bqO+q1MWyDpUI9j7j6tV8Yhxm+iONR85YjdNFyDAzo4HB/ewukiFxJm++t+8UMiVK7pIAadYzSrqcrIRP+PodpyLeud06SUGm050kOYNRf8TDUifXs4uslXQ/zupN0iRDe9tMLT6Y5ZTvWXXIKYqQbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786047540; c=relaxed/simple;
	bh=QPQo4F/WNZnXNLysytNfwLNBak/leIuMpRnA9gZqMfA=;
	h=Date:To:From:Subject:Message-Id; b=DRS9khcW8VWaTFA81vfnulshwsMvNWiMteMq899VWsKCmzBYp1HJ02s1Ae4QevqS9qNmxYpbe4nJwrL9Ua7Sranbs8DB0CTk1Od8fUKqRZkcPG+6Lf27iqRrcUulsA6jVSKvE9EdvFbLCC+ZdexexxGgL570evClsBenPXToGOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zpn9kIZQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zpn9kIZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E031F000E9;
	Thu,  6 Aug 2026 20:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786047538;
	bh=urTIb664DhECiSFBeD8QSsDxpom4/IP21NIVG8GzrrM=;
	h=Date:To:From:Subject;
	b=Zpn9kIZQk0DEKk7Ti+1uaJwTSi1WG8nb+F9gqf8PcPYVN2ekF4ZK8hAlcGtWtvA8q
	 fHvQQOqZal2EcWZNr+Wesx4Oguk0XLzxbcNc4mXs21Zv92QCYHlc1GCRHg5WG81R34
	 fTknU9bKGZ1dFwabNOMQyzQjypK6haLo2iPAOCzw=
Date: Thu, 06 Aug 2026 13:18:58 -0700
To: mm-commits@vger.kernel.org,zhanxusheng@xiaomi.com,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,zhanxusheng1024@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-unused-mas_is_root_limits.patch added to mm-new branch
Message-Id: <20260806201858.B6E031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove unused mas_is_root_limits()
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-remove-unused-mas_is_root_limits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-unused-mas_is_root_limits.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: maple_tree: remove unused mas_is_root_limits()
Date: Wed, 5 Aug 2026 15:05:29 +0800

The last callers of mas_is_root_limits() were removed by commit
b8852ef30c67 ("maple_tree: remove maple big node and subtree structs"),
together with the maple subtree state (mast_*) code that used it.  As a
static inline it does not trigger -Wunused-function, so it went unnoticed.

Remove it. No functional change.

Link: https://lore.kernel.org/20260805070529.4118794-1-zhanxusheng@xiaomi.com
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-unused-mas_is_root_limits
+++ a/lib/maple_tree.c
@@ -362,11 +362,6 @@ static __always_inline bool mte_is_root(
 	return ma_is_root(mte_to_node(node));
 }
 
-static inline bool mas_is_root_limits(const struct ma_state *mas)
-{
-	return !mas->min && mas->max == ULONG_MAX;
-}
-
 static __always_inline bool mt_is_alloc(struct maple_tree *mt)
 {
 	return (mt->ma_flags & MT_FLAGS_ALLOC_RANGE);
_

Patches currently in -mm which might be from zhanxusheng1024@gmail.com are

maple_tree-remove-unused-mas_is_root_limits.patch
ocfs2-fix-readdir-position-truncation-on-32-bit-kernels.patch

