Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1634538911B
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622991; cv=none; b=SmDGGQ+LNk6cHYEvE+cHRyAhnDIhF+ukInYpzl5gmBNfnTlvEyCYmAqPqWu48QNeRTCa6i9cQ/tIjkNDrnA+uGSg6H80MhHx1pssBaHTC8igkEKFKSfwFuuEid6y5HB4m4STv20P9aDh4l+hgVzxzadsDETPiuYYWpRpHpc9bLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622991; c=relaxed/simple;
	bh=mwrr+wqBGbkqiK2m24IM7UfsQNnXNaa+VaiJdmNNQ2A=;
	h=Date:To:From:Subject:Message-Id; b=iawsDohC0CkhcW2XvQ9kTyVwyxyC/ta5/yycRuGuCqyA0Vn4sVtV1FpAyxsmROmGCxAeB2fTdzwBS8gX10/fHar33Vcdfqj+6NaMZ3qUkc/39SMnEEVrTbesGb7PwsxeaHyK5AFIEkOl7+LLeh0kJUMiBIbx3zMYIF8yy3JwfUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m5G9HMsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m5G9HMsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2471F00A3A;
	Tue, 25 Aug 2026 01:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622990;
	bh=Z5EYCfhTm8nKSosd+WMyJ5nynqfkWIHtpGMIzMRVwBg=;
	h=Date:To:From:Subject;
	b=m5G9HMsmSER18scSRDn415lrlNfUheuxFjUsKVKqF/KuqvAnyjEf7x/U+WNyqEv/d
	 4A0gZ6jpi1ry5xQFJg/ktfzLT4M2S4BEmM1pR4iLJmktIrHddJhe7o+lLigT3ngVB5
	 k2RB0L+w8vmzEhh/UkXAl1TxPtH7zXPOzz2HVHjw=
Date: Mon, 24 Aug 2026 18:56:29 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-helper-mas_make_walkable.patch removed from -mm tree
Message-Id: <20260825015629.DB2471F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add helper mas_make_walkable()
has been removed from the -mm tree.  Its filename was
     maple_tree-add-helper-mas_make_walkable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: add helper mas_make_walkable()
Date: Fri, 21 Aug 2026 15:26:27 -0400

A check in mas_walk() was incorrect and caused inefficient use of the
maple state.  The same issue existed in mas_erase(), but was left unfixed.
Making a helper function is the obvious answer.

Link: https://lore.kernel.org/20260821192627.4085470-20-liam@infradead.org
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

 lib/maple_tree.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-helper-mas_make_walkable
+++ a/lib/maple_tree.c
@@ -261,6 +261,12 @@ static inline bool mas_is_underflow(stru
 	return mas->status == ma_underflow;
 }
 
+static inline void mas_make_walkable(struct ma_state *mas)
+{
+	if (!mas_is_active(mas) && !mas_is_start(mas))
+		mas->status = ma_start;
+}
+
 static __always_inline struct maple_node *mte_to_node(
 		const struct maple_enode *entry)
 {
@@ -4447,8 +4453,7 @@ void *mas_walk(struct ma_state *mas)
 	void *entry;
 
 	mas_may_init_lock_check(mas);
-	if (!mas_is_active(mas) && !mas_is_start(mas))
-		mas->status = ma_start;
+	mas_make_walkable(mas);
 retry:
 	entry = mas_state_walk(mas);
 	if (mas_is_start(mas)) {
@@ -5685,9 +5690,7 @@ void *mas_erase(struct ma_state *mas)
 	if (mt_external_lock(mas->tree))
 		might_alloc(GFP_KERNEL);
 
-	if (!mas_is_active(mas) || !mas_is_start(mas))
-		mas->status = ma_start;
-
+	mas_make_walkable(mas);
 write_retry:
 	entry = mas_state_walk(mas);
 	if (!entry)
_

Patches currently in -mm which might be from liam@infradead.org are


