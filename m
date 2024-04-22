Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0D91D539;
	Mon, 22 Apr 2024 22:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713823543; cv=none; b=O4Nx8b51fJT17wf+BmeTVBVLw/PB2e96WP/EMPm0zjAEZGhjpNIR7vTj6hC4XqAb9FtRC0KoVzZMSVNcF0u/DuoF2gawj0uNC3vuRHx1RQ4Zz4g/YLE/hrtWnbov3a+JTgGzMKvqDzgPczNu8daWkGNSbUDXOncSyMEdzfVi9ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713823543; c=relaxed/simple;
	bh=yPebEQYEnoVsGbtFMoZDWIqJM7l5KRSiuB1nY1R0K9Q=;
	h=Date:To:From:Subject:Message-Id; b=HnZ7DnVsVJpi/Npz3Ne+ZKXcdWasVuox1fns0+CmwFEcckaSCFuLJWI8UTRBWEvGrBT6zlYokvs3F8mh5Inbu7ESL0ENoTXCre8bFpO9BYGs+DRP5i5N48rLG92SNZaH7kFVBYzHlAk/wyunuDhNOm0EyzTptUwvLFjdoswdUtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mvgiLVBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mvgiLVBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7040C113CC;
	Mon, 22 Apr 2024 22:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713823543;
	bh=yPebEQYEnoVsGbtFMoZDWIqJM7l5KRSiuB1nY1R0K9Q=;
	h=Date:To:From:Subject:From;
	b=mvgiLVBJooBoVc7xTxuyk9ik/XVjz8jw+JliRx5z3EwxF34QHykjadBrblS03tec6
	 gzQp0q2jNL+gbDTtSBrXlBg7g7NBNaQcGml/jjxspc51Z310yhUoUYKxv0tadcVtRs
	 jsHWWuYx++xjDKarZQ8K96uNnh6vD3O594HNS0lU=
Date: Mon, 22 Apr 2024 15:05:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sidhartha.kumar@oracle.com,fleischermarius@gmail.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-mas_empty_area_rev-null-pointer-dereference.patch added to mm-hotfixes-unstable branch
Message-Id: <20240422220542.E7040C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix mas_empty_area_rev() null pointer dereference
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-mas_empty_area_rev-null-pointer-dereference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-mas_empty_area_rev-null-pointer-dereference.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

maple_tree-fix-mas_empty_area_rev-null-pointer-dereference.patch

