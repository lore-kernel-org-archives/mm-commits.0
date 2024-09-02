Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5FF7DA82
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 00:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725235213; cv=none; b=mS/IUS/yFM0C05/2VtiqUCM69ZEsMndLyUsRFGZOWslUJo3TaYRBlwXNBufSzHG6IrbTad2cmGybn3ByM1gjZyfM8HmTJITrwHywHhEe1m3FJTP71CAMCeMTF+9aE3+Xn8mkA8JVk9S1tJebKvw8rbrhd4+pdF9av5bd/TC9nXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725235213; c=relaxed/simple;
	bh=fOUBvc3HR3c7hhpnDuanFgXGLo2cgEVzCQ1ylR5JF2A=;
	h=Date:To:From:Subject:Message-Id; b=uM7k0fzG1MtXJryBSMxmgqYDoJRz3Z1PT3WKZEyKYYg5gb+5Bp49Pd3Z2IyZKdMEV3+JYt2ijzCAli8raCoRs3KjRruVybXKfeKKwPlAi3PRTyXNs+Y1oECrdW5Rot9jHF6GK2MSpTh1cy463RRypJ2YArbNCwItrTB+x7oPfa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QsJ4oJh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QsJ4oJh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA589C4CEC3;
	Mon,  2 Sep 2024 00:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725235212;
	bh=fOUBvc3HR3c7hhpnDuanFgXGLo2cgEVzCQ1ylR5JF2A=;
	h=Date:To:From:Subject:From;
	b=QsJ4oJh16AFbakoUZgZojzerMvKwfB0k1OXzHUGanEm4joOJN4XEJ47OlIXfN+Sy7
	 4Ux4ncir0QTWEmfOms8+NStoG1VIe2QBIzs/uWk5kvQnpA839TaMGLKlorrz6Dojn3
	 c2txY3H6m3aMpCpeT3OHzmbFNiVtJDt7GTK9QpS0=
Date: Sun, 01 Sep 2024 17:00:12 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-local-variable-count-is-not-necessary.patch added to mm-unstable branch
Message-Id: <20240902000012.AA589C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: local variable 'count' is not necessary
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-local-variable-count-is-not-necessary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-local-variable-count-is-not-necessary.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: local variable 'count' is not necessary
Date: Sat, 31 Aug 2024 00:10:53 +0000

'count' is never changed after assignment and it looks a little
more direct to use mas->end to locate the offset.

Also ma_data_end() returns slot index instead of count.

Link: https://lkml.kernel.org/r/20240831001053.4751-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-local-variable-count-is-not-necessary
+++ a/lib/maple_tree.c
@@ -2174,7 +2174,7 @@ static inline void mas_node_or_none(stru
 static inline void mas_wr_node_walk(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
-	unsigned char count, offset;
+	unsigned char offset;
 
 	if (unlikely(ma_is_dense(wr_mas->type))) {
 		wr_mas->r_max = wr_mas->r_min = mas->index;
@@ -2184,11 +2184,11 @@ static inline void mas_wr_node_walk(stru
 
 	wr_mas->node = mas_mn(wr_mas->mas);
 	wr_mas->pivots = ma_pivots(wr_mas->node, wr_mas->type);
-	count = mas->end = ma_data_end(wr_mas->node, wr_mas->type,
+	mas->end = ma_data_end(wr_mas->node, wr_mas->type,
 				       wr_mas->pivots, mas->max);
 	offset = mas->offset;
 
-	while (offset < count && mas->index > wr_mas->pivots[offset])
+	while (offset < mas->end && mas->index > wr_mas->pivots[offset])
 		offset++;
 
 	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, offset, wr_mas->type);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-improve-code-consistency-with-zonelist_-helper-functions.patch
mm-memory_hotplug-get-rid-of-__ref.patch
maple_tree-fix-comment-typo-of-ma_root.patch
maple_tree-fix-comment-typo-with-corresponding-maple_status.patch
maple_tree-arange64-node-is-not-a-leaf-node.patch
maple_tree-dump-error-message-based-on-format.patch
maple_tree-cleanup-function-descriptions.patch
maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch
maple_tree-use-ma_data_end-in-mas_data_end.patch
maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch
maple_tree-local-variable-count-is-not-necessary.patch

