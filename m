Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE33335083
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025872; cv=none; b=Hch2vYf8iP9jdQnGiZTxgIHYFxQFFWszMVc+sjtwM9uIg8pWYD4GGZadJjNm750A9aRSIOLkRmrLy3TK4/XfPkXq1ILDfCJejKo5gZtJv0Vv6qwV9lf//VGFxmZrLbuMIhYy/CO7NXCc4WRnYWdKBKFmWb91Sc+y1zTAnGno6HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025872; c=relaxed/simple;
	bh=+GsXr1bTcXYMG1yvstjhQUA0Wja9xah/yXiXswiM548=;
	h=Date:To:From:Subject:Message-Id; b=n3hqiWzPJbAXS/mXvyFgB/q2uY/3FUysXfpfvM9fckPXO23o4HatIX71qUJI/AiYRBU+sDHUOgbE70DAmzEfZE3Q0XJCxwNiS0ceBU3nJzFETVS0CqoO0EFc5muJ9BaeB5zk3D7piZPo2RQ1RONWVzrY3yyC6AhU48P2nperDl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dZepwhdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dZepwhdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5DBC4CEF1;
	Mon, 24 Nov 2025 23:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025872;
	bh=+GsXr1bTcXYMG1yvstjhQUA0Wja9xah/yXiXswiM548=;
	h=Date:To:From:Subject:From;
	b=dZepwhdw55Ubum/sMmqfVI4D4oBpQO+c7FT/GLwjR1zXHqC1VNKaz/wG6EwHKtdXf
	 +cey2VNKWZsWtZItB8OTev+6eUm3dKTRJ+Td/ERwWb/5adNbNYEB94N0gvLwoIQ5zC
	 5z749EDOkU7seeMIaCx2U+VJPm6kymLYsagKSGm4=
Date: Mon, 24 Nov 2025 15:11:11 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lorenzo.stoakes@oracle.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-tweak-__vma_enter_locked.patch removed from -mm tree
Message-Id: <20251124231111.DC5DBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: tweak __vma_enter_locked()
has been removed from the -mm tree.  Its filename was
     mm-tweak-__vma_enter_locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: tweak __vma_enter_locked()
Date: Wed, 19 Nov 2025 04:26:35 +0000

Move the commentary on how __vma_enter_locked() behaves from the body of
__vma_start_write() to the head of __vma_enter_locked() and merge it with
the existing documentation.  Also add a call to
mmap_assert_write_locked().

Link: https://lkml.kernel.org/r/20251119042639.3937024-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap_lock.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/mmap_lock.c~mm-tweak-__vma_enter_locked
+++ a/mm/mmap_lock.c
@@ -46,9 +46,9 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_relea
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 /*
- * Return value: 0 if vma detached,
- * 1 if vma attached with no readers,
- * -EINTR if signal received,
+ * __vma_enter_locked() returns 0 immediately if the vma is not
+ * attached, otherwise it waits for any current readers to finish and
+ * returns 1.  Returns -EINTR if a signal is received while waiting.
  */
 static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		bool detaching, int state)
@@ -56,6 +56,8 @@ static inline int __vma_enter_locked(str
 	int err;
 	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
 
+	mmap_assert_write_locked(vma->vm_mm);
+
 	/* Additional refcnt if the vma is attached. */
 	if (!detaching)
 		tgt_refcnt++;
@@ -91,11 +93,6 @@ int __vma_start_write(struct vm_area_str
 {
 	int locked;
 
-	/*
-	 * __vma_enter_locked() returns false immediately if the vma is not
-	 * attached, otherwise it waits until refcnt is indicating that vma
-	 * is attached with no readers.
-	 */
 	locked = __vma_enter_locked(vma, false, state);
 	if (locked < 0)
 		return locked;
_

Patches currently in -mm which might be from willy@infradead.org are


