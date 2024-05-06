Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94747EDF;
	Mon,  6 May 2024 00:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955322; cv=none; b=L5SKyUU/zY+w1X7QP2/y2yHt3nWFvsFk7gNYJT4hMOAdzWAuhZn5N1g9ojCUrFSTkLio+AbzcQFgOYjMm4DQS2AJuNCnxffpjAj+X7ie5gf67L9AiwvrGNIqSEaLWZZHDHZRxgc2axjz/SY1umzcSY43uhZbwCFIySf3Mvcxh90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955322; c=relaxed/simple;
	bh=w8PO+7p09xfzWzQ2N0UaUvqVJIDbP88kb9v1BppWHKg=;
	h=Date:To:From:Subject:Message-Id; b=KfxKhujzFfke743mFhbwrEA/uTaD8zfujYwXIhEbZTtnMMuoxuywXT9mLhFXHuwooC665N5EKdlnk8mwbGuFXlUkdIWHN3LtfUP8Uc3DzOQD9FechTh29xGU0jfBt074vfG9Hl26IPZw2lU2vv3GdBKJgJQOmnLCD07K2+gEpik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RL6yV8np; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RL6yV8np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04450C116B1;
	Mon,  6 May 2024 00:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955322;
	bh=w8PO+7p09xfzWzQ2N0UaUvqVJIDbP88kb9v1BppWHKg=;
	h=Date:To:From:Subject:From;
	b=RL6yV8npjD4cCdsMc1hunIBlX4vPlYrVsx1Fj7QIWNgRro3C2qi1Yfy4GG7pWQUTw
	 SVwtQOnI/efZEtl0TkxslVdmA4xc9NAMb84lMtI7UiHmMYUrJiFaOvGReheaF3WlHk
	 0elPdO7le0lzl6JcfIw3gKcPsjtvaoAJBvLoaN9E=
Date: Sun, 05 May 2024 17:28:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sidhartha.kumar@oracle.com,fleischermarius@gmail.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-mas_empty_area_rev-null-pointer-dereference.patch removed from -mm tree
Message-Id: <20240506002842.04450C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix mas_empty_area_rev() null pointer dereference
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-mas_empty_area_rev-null-pointer-dereference.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix mas_empty_area_rev() null pointer dereference
Date: Mon, 22 Apr 2024 16:33:49 -0400

Currently the code calls mas_start() followed by mas_data_end() if the
maple state is MA_START, but mas_start() may return with the maple state
node == NULL.  This will lead to a null pointer dereference when checking
information in the NULL node, which is done in mas_data_end().

Avoid setting the offset if there is no node by waiting until after the
maple state is checked for an empty or single entry state.

A user could trigger the events to cause a kernel oops by unmapping all
vmas to produce an empty maple tree, then mapping a vma that would cause
the scenario described above.

Link: https://lkml.kernel.org/r/20240422203349.2418465-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Marius Fleischer <fleischermarius@gmail.com>
Closes: https://lore.kernel.org/lkml/CAJg=8jyuSxDL6XvqEXY_66M20psRK2J53oBTP+fjV5xpW2-R6w@mail.gmail.com/
Link: https://lore.kernel.org/lkml/CAJg=8jyuSxDL6XvqEXY_66M20psRK2J53oBTP+fjV5xpW2-R6w@mail.gmail.com/
Tested-by: Marius Fleischer <fleischermarius@gmail.com>
Tested-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_empty_area_rev-null-pointer-dereference
+++ a/lib/maple_tree.c
@@ -5109,18 +5109,18 @@ int mas_empty_area_rev(struct ma_state *
 	if (size == 0 || max - min < size - 1)
 		return -EINVAL;
 
-	if (mas_is_start(mas)) {
+	if (mas_is_start(mas))
 		mas_start(mas);
-		mas->offset = mas_data_end(mas);
-	} else if (mas->offset >= 2) {
-		mas->offset -= 2;
-	} else if (!mas_rewind_node(mas)) {
+	else if ((mas->offset < 2) && (!mas_rewind_node(mas)))
 		return -EBUSY;
-	}
 
-	/* Empty set. */
-	if (mas_is_none(mas) || mas_is_ptr(mas))
+	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
 		return mas_sparse_area(mas, min, max, size, false);
+	else if (mas->offset >= 2)
+		mas->offset -= 2;
+	else
+		mas->offset = mas_data_end(mas);
+
 
 	/* The start of the window can only be within these values. */
 	mas->index = min;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


