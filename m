Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF6437C112
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622974; cv=none; b=IOQthZCRH9eQohXnkAzYqu4iqjQ0obFpx+Hu4PibzKxFv+iq9KtEKNS6YbzAo1ROIFc0/C/07ScBxoH3mSS5R4xeVBxUyKIZrrgb7Vcwk1kfDsSuco1xDUL1DxemZp/fvIWAgxO8bLACOKzjTmv7WcvlHbnXcWsR3bL1k0s9wjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622974; c=relaxed/simple;
	bh=ShoWqpHPqKnl5NpkaTvOdMW7W6shFabxN6WfSfdelUc=;
	h=Date:To:From:Subject:Message-Id; b=VD90g09x0Y0o4xpofneJ+Nyi3eZkOK+Mkg4Or8vnYoR9u0cIk/p9pIAyW7Ni07eziWbE8zd43wlyD4z3Tb8+5l0thFqcoodsJksm7uEBHz03bWOEKkJh2nciicUiruynkzMesgCo0PY04+7j95nxj3EHbuhyMthcHuf+u8krfgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rkNhwOpS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rkNhwOpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16091F00A3A;
	Tue, 25 Aug 2026 01:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622972;
	bh=St8HUf6zCI3c6MPyYk8/ckz95GE6JXb2bn2CWLjk3hI=;
	h=Date:To:From:Subject;
	b=rkNhwOpSo/s8uSYayBMqNnYVBcT5UAhKUVRqJ6Oqto6BAAaWnpw/KmI2abK+ssAex
	 jlhh36DHMWqTCsfgkVJxALoXFhITqzxSnz27cClkvFm0700E5yMF/3ABR5Oihwdr9z
	 rArcoBSk+UFfj56H3mbb80gScMeoC/xEP6D8Vtzg=
Date: Mon, 24 Aug 2026 18:56:12 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-prefetched-value-in-mas_wr_store_type.patch removed from -mm tree
Message-Id: <20260825015612.A16091F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use prefetched value in mas_wr_store_type()
has been removed from the -mm tree.  Its filename was
     maple_tree-use-prefetched-value-in-mas_wr_store_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: use prefetched value in mas_wr_store_type()
Date: Fri, 21 Aug 2026 15:26:16 -0400

The slot contents exist in wr_mas->content, which has less overhead than
reading the slot again.

Link: https://lore.kernel.org/20260821192627.4085470-9-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
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

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-use-prefetched-value-in-mas_wr_store_type
+++ a/lib/maple_tree.c
@@ -3280,7 +3280,7 @@ static inline void mas_wr_slot_store(str
 	void __rcu **slots = wr_mas->slots;
 	bool gap = false;
 
-	gap |= !mt_slot_locked(mas->tree, slots, offset);
+	gap |= !wr_mas->content;
 	gap |= !mt_slot_locked(mas->tree, slots, offset + 1);
 
 	if (wr_mas->offset_end - offset == 1) {
_

Patches currently in -mm which might be from liam@infradead.org are


