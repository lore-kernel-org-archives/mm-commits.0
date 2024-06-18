Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E288613BC30
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 21:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718745381; cv=none; b=ENNsLf1cu6mgUyvofT00ATpeMRCahbywrMhK9Ie+aRKT6BnjPfVcwnh2rm04Jo+PbW/SW/U8VDKtNbLIQ5CC70yrKmKvjWovoVtFnrQdZtqn4auYFMZ/tdQuB2M0J9Ezw5f8dZQbjjNnfBgxWr5McVL8WpIUWEVqe4j6SfFOank=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718745381; c=relaxed/simple;
	bh=lPOegJQtPfOFUAS1AqJ1Rn4ljbDX2oGsPS9usTigOE4=;
	h=Date:To:From:Subject:Message-Id; b=ZmVzbUUDCQr8mbdTrtghSJ5+y01lrsPvvYquH+oTPsapF448ZXb4EznlhLBA1h+RnPWi2uZcroK5sM1pkyNip1ucfXw6MtLOCeH9u1pHV9zvSNKjEDGZhDbFRV5q1MafwxmptKwoWH6z4dk97sg11nyW9Gn2aHWpcMu+1B9VAZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gphbVJuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gphbVJuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB38C32786;
	Tue, 18 Jun 2024 21:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718745379;
	bh=lPOegJQtPfOFUAS1AqJ1Rn4ljbDX2oGsPS9usTigOE4=;
	h=Date:To:From:Subject:From;
	b=gphbVJuAmbJXJRU9QKMKXzPAf9uL5hMdx6fi0TLwYLB0LGVLYgJWLiXsefGnv7/7v
	 WGHybVWD+Udnicfb9SBvdD3s2XYUr9/zQNWygSPc8ETv5/g7pfgkHwqnrIvmaLtnlv
	 KJe37flNq+qkubqA292lvOGYb69uXEFXULAEyXqg=
Date: Tue, 18 Jun 2024 14:16:19 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,Liam.Howlett@oracle.com,rgbi3307@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-modified-return-type-of-mas_wr_store_entry.patch added to mm-unstable branch
Message-Id: <20240618211619.BCB38C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: modified return type of mas_wr_store_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-modified-return-type-of-mas_wr_store_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-modified-return-type-of-mas_wr_store_entry.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: JaeJoon Jung <rgbi3307@gmail.com>
Subject: maple_tree: modified return type of mas_wr_store_entry()
Date: Fri, 14 Jun 2024 18:24:28 +0900

Since the return value of mas_wr_store_entry() is not used,
the return type can be changed to void.

Link: https://lkml.kernel.org/r/20240614092428.29491-1-rgbi3307@gmail.com
Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-modified-return-type-of-mas_wr_store_entry
+++ a/lib/maple_tree.c
@@ -4203,31 +4203,28 @@ slow_path:
  *
  * Return: The contents that was stored at the index.
  */
-static inline void *mas_wr_store_entry(struct ma_wr_state *wr_mas)
+static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 
 	wr_mas->content = mas_start(mas);
 	if (mas_is_none(mas) || mas_is_ptr(mas)) {
 		mas_store_root(mas, wr_mas->entry);
-		return wr_mas->content;
+		return;
 	}
 
 	if (unlikely(!mas_wr_walk(wr_mas))) {
 		mas_wr_spanning_store(wr_mas);
-		return wr_mas->content;
+		return;
 	}
 
 	/* At this point, we are at the leaf node that needs to be altered. */
 	mas_wr_end_piv(wr_mas);
 	/* New root for a single pointer */
-	if (unlikely(!mas->index && mas->last == ULONG_MAX)) {
+	if (unlikely(!mas->index && mas->last == ULONG_MAX))
 		mas_new_root(mas, wr_mas->entry);
-		return wr_mas->content;
-	}
-
-	mas_wr_modify(wr_mas);
-	return wr_mas->content;
+	else
+		mas_wr_modify(wr_mas);
 }
 
 /**
_

Patches currently in -mm which might be from rgbi3307@gmail.com are

maple_tree-modified-return-type-of-mas_wr_store_entry.patch

