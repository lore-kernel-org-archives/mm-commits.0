Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C39A3AAF47
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350920; cv=none; b=ZH8t64e4p0weOUAzECgP4uhnyYCbLJD4/B7w/MDEazBYBGYem2KCatX3xVR6C9aydPj1vNGGPDQ7/E4CE7WKx/JcUEGfW1KzFDvChDmbDnLMKwufgggbiUQPOn2lfT3wA7jDm3bOKkSGRV+uk5etzF+HjEwC68InzQ1XqutaU1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350920; c=relaxed/simple;
	bh=Unty8sdAv8IX9iRo489nq5PlUSpnRUNX3TAp8fVB0x8=;
	h=Date:To:From:Subject:Message-Id; b=cc5krMLpcYFOAvFrYaMWFRhXbguSphar3l/ZqtKEwsvwFjhxzPY9wwtDxcRls7mEEItHMtlXOIZm4RXM3WiHGwubaQaDay/6LcdfxTjbaQ3OcWldBZXIAx5Fjy8KcblJULjeNxDIb6tMAxZlApuwtycr4oR2fr8pGGrlzmboJ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P4y9CDiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P4y9CDiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AF81F00A3A;
	Fri, 21 Aug 2026 22:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350919;
	bh=98spyM26d8+7CIsdhAuFoU3Emd3b77O8A3q2giyr05A=;
	h=Date:To:From:Subject;
	b=P4y9CDiPxOPSst1dLsbnzgvxUaciTQ+hVOnr6USYWj/6FBEMKgTtXvubKDUvNEGQ8
	 IIvlJDLzNICCBbbkYvnCm+GI1tWRQeKf9beeMXKgrTeAxYN2rkg+lqimMh4LavYIsK
	 psevDfGRBBWPzqZcUZVqkPB9UcT+mTqGvwiP0BSg=
Date: Fri, 21 Aug 2026 15:21:58 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-fix-argument-name-in-header.patch removed from -mm tree
Message-Id: <20260821222159.49AF81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix argument name in header
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-argument-name-in-header.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: fix argument name in header
Date: Tue, 30 Jun 2026 15:08:41 -0400

The mas_prev_range() function takes a min and not a max.

Link: https://lore.kernel.org/20260630190843.3563858-18-liam@infradead.org
Fixes: 6b9e93e01020 ("maple_tree: add mas_prev_range() and mas_find_range_rev interface")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/maple_tree.h~maple_tree-fix-argument-name-in-header
+++ a/include/linux/maple_tree.h
@@ -575,7 +575,7 @@ void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
-void *mas_prev_range(struct ma_state *mas, unsigned long max);
+void *mas_prev_range(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

