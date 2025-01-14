Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544551C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836938; cv=none; b=K098SZIICTs+FC6HvoQN1moRQ9BuKz0eqayXWa705qpy4VfjSbYPFE81GOMG5KSJzc8fQ1mtReaTJklFoCqRLeNwHNWYyksX9PliPHO5faeanl23BLopw+0UDvirr7l/oiVvjWJ+fPz3Ot1959jQk8ZaILh4rqhkPHR0EqDAxo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836938; c=relaxed/simple;
	bh=3BCdI4/POLNFMYQYIUDy0uMy1h7AxqHbj8aR/S22Pn8=;
	h=Date:To:From:Subject:Message-Id; b=FuvX54jZ0qySsL170cu+86MCU0iSImAgkGH6P9gSBUExzt2dt8X9phM3Ia0RI02xbRNA/ai7bWObtdgnMUnmAR6n7fVRlNqVHFJ5CtuTk2nKdEsorOGKdgYM0uGB2/5nOtx+vb6aChbbMikYCQgUPEry6fz2kMyh6x0ZJUxUtr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kstb2oK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kstb2oK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28365C4CEDD;
	Tue, 14 Jan 2025 06:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836938;
	bh=3BCdI4/POLNFMYQYIUDy0uMy1h7AxqHbj8aR/S22Pn8=;
	h=Date:To:From:Subject:From;
	b=kstb2oK8lHmRTTGkXb2GIJTxsIAYr5+A3SAz/DdImH3q+Lx8bIzJZIxE+PTMLxxN8
	 mC65euvysVPQPFIISSlDW8yhm7GILunw35GR0K4KHWRiNO68z1U1dXlgM8a1v5CU6S
	 xLRKanQndCtgoZwSoFTstIS7LmpIvMtZ8BLqNLJY=
Date: Mon, 13 Jan 2025 22:42:17 -0800
To: mm-commits@vger.kernel.org,yikming2222@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-fix-a-comment-typo-in-lock_mm_and_find_vma.patch removed from -mm tree
Message-Id: <20250114064218.28365C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: fix a comment typo in lock_mm_and_find_vma()
has been removed from the -mm tree.  Its filename was
     mm-memory-fix-a-comment-typo-in-lock_mm_and_find_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chin Yik Ming <yikming2222@gmail.com>
Subject: mm/memory: fix a comment typo in lock_mm_and_find_vma()
Date: Wed, 20 Nov 2024 18:50:41 +0800

s/equivalend/equivalent/

Link: https://lkml.kernel.org/r/20241120105041.2394283-1-yikming2222@gmail.com
Signed-off-by: Chin Yik Ming <yikming2222@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-a-comment-typo-in-lock_mm_and_find_vma
+++ a/mm/memory.c
@@ -6185,7 +6185,7 @@ static inline bool upgrade_mmap_lock_car
 /*
  * Helper for page fault handling.
  *
- * This is kind of equivalend to "mmap_read_lock()" followed
+ * This is kind of equivalent to "mmap_read_lock()" followed
  * by "find_extend_vma()", except it's a lot more careful about
  * the locking (and will drop the lock on failure).
  *
_

Patches currently in -mm which might be from yikming2222@gmail.com are


