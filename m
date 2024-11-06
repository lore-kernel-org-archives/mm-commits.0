Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625C717CA1B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854826; cv=none; b=VPBML/+tCEEF0GuoUkc0G9cSR0q0RVQz5LMzzjxcFzI5lL91f2treGBHJkUg0fSh3xLVLwmsbuXKXGpSUEJ+4Q9K/MKRouj7kBdxgcc44zvIOKYgU6h1v9Q9c9oXuXrpbdP5w3NHV1Rpchc5uiyCsN4TaOnTTGxDA2KmuLhXmKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854826; c=relaxed/simple;
	bh=U556Kk5oGtonMV54crKcUjdpik/PRwBAGaViOXtKOCI=;
	h=Date:To:From:Subject:Message-Id; b=ds70E5ZAmoXjjJD64QxE1DqbGCxkeXAk12m1KnKjh/YKhUdKrHbnnXF4cwZPLIZkDjRJ5aZqhffxcuDL5TiL6D2/pqhNLQtQFZcWwzEr4N41ljU24W/F2lu1CNCaST+9GHCYrVTR2CpqU5bKX3TkYGPSAHD22n2VDPx4XPAv1/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mE4Cazg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mE4Cazg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC9AC4CECF;
	Wed,  6 Nov 2024 01:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854826;
	bh=U556Kk5oGtonMV54crKcUjdpik/PRwBAGaViOXtKOCI=;
	h=Date:To:From:Subject:From;
	b=mE4Cazg7au1fBO2QA+MHuMTL5zZPNAoTzrWjX+4VfRzFYEctBLFFlB+CGw5+XqVDk
	 vF44nEsNjJndnXT4qGCharVQav0Y3rMtYAy3YYg4jDSPJIbwXYqeJ81Iod1E//OzRo
	 tSi5kMRBhSOhk4643tLKQ2rQwiYdAn6BdT3jSPgc=
Date: Tue, 05 Nov 2024 17:00:25 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch removed from -mm tree
Message-Id: <20241106010026.2DC9AC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove sanity check from mas_wr_slot_store()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: remove sanity check from mas_wr_slot_store()
Date: Thu, 17 Oct 2024 01:58:09 +0000

After commit 5d659bbb52a2 ("maple_tree: introduce mas_wr_store_type()"),
the check here is redundant.

Let's remove it.

Link: https://lkml.kernel.org/r/20241017015809.23392-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-sanity-check-from-mas_wr_slot_store
+++ a/lib/maple_tree.c
@@ -3897,7 +3897,8 @@ static inline void mas_wr_slot_store(str
 			wr_mas->pivots[offset] = mas->index - 1;
 			mas->offset++; /* Keep mas accurate. */
 		}
-	} else if (!mt_in_rcu(mas->tree)) {
+	} else {
+		WARN_ON_ONCE(mt_in_rcu(mas->tree));
 		/*
 		 * Expand the range, only partially overwriting the previous and
 		 * next ranges
@@ -3907,8 +3908,6 @@ static inline void mas_wr_slot_store(str
 		wr_mas->pivots[offset] = mas->index - 1;
 		wr_mas->pivots[offset + 1] = mas->last;
 		mas->offset++; /* Keep mas accurate. */
-	} else {
-		return;
 	}
 
 	trace_ma_write(__func__, mas, 0, wr_mas->entry);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

