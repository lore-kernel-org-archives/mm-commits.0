Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB4E801
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 00:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253477; cv=none; b=XolTgUUve2YQcxwCW9Sf2CA5PQ03+lJy0gAx5632lL1BadwjO4Mj8qR2RIyUGAvyGtK/SJK4pfyWOxCSvMzrQqW3BUHwIXCCtqosTInDb2EqRYiA0vyi1Mkf5M6aKJkafB7e7oBiB4+unt/kaUlg7qwI9smzMUsGn2u1vUdGHqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253477; c=relaxed/simple;
	bh=/jH0hfKG8w6jZ6Me981WGh/iLAnQ/XC0RN0Uidtysm0=;
	h=Date:To:From:Subject:Message-Id; b=JR6bcEAeh4MUWfYKOolVsraKplc4NjGA9afKDrlzgsqQrspFBYM/xAydvEg0ghVrGNOz3FtRxoJL8Rqvlxl5U1QSn/2jYNnmkwEBIyDKgoThvqwJpXPnxH2KCPvfLXnSgbWnpPFjRqtEB3YkIA3I5dNhw78sYl4V0G5nBJV75h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bhcmLUVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bhcmLUVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED90FC4CEF1;
	Wed, 27 Aug 2025 00:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756253477;
	bh=/jH0hfKG8w6jZ6Me981WGh/iLAnQ/XC0RN0Uidtysm0=;
	h=Date:To:From:Subject:From;
	b=bhcmLUVMp5aDeHC2ZNdSV6rvkDX2NZdU1VyAfuv7LpXb7NLnVt4tp/+mkDjxnoUEg
	 TasNo2ZSpJvznMooljZ92mUI9mcxNAr1oWCGAgs4oWaqToa9RcJxaVkOEFTK0HPbh2
	 ikhN/counTkJkdAoYhOwuDs0AS9OXi9JFHk6vD70=
Date: Tue, 26 Aug 2025 17:11:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-maple_parent_range32-and-parent-pointer-docs.patch added to mm-new branch
Message-Id: <20250827001116.ED90FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix MAPLE_PARENT_RANGE32 and parent pointer docs
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-fix-maple_parent_range32-and-parent-pointer-docs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-maple_parent_range32-and-parent-pointer-docs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: fix MAPLE_PARENT_RANGE32 and parent pointer docs
Date: Tue, 26 Aug 2025 15:13:44 +0000

MAPLE_PARENT_RANGE32 should be 0x02 as a 32 bit node is indicated by the
bit pattern 0b010 which is the hex value 0x02.  There are no users
currently, so there is no associated bug with this wrong value.

Fix typo Note -> Node and replace x with b to indicate binary values.

Link: https://lkml.kernel.org/r/20250826151344.403286-1-sidhartha.kumar@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |   16 ++++++++--------
 lib/maple_tree.c           |   12 ++++++------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-fix-maple_parent_range32-and-parent-pointer-docs
+++ a/include/linux/maple_tree.h
@@ -57,17 +57,17 @@
  * MT_FLAGS_ALLOC_RANGE flag.
  *
  *  Node types:
- *   0x??1 = Root
- *   0x?00 = 16 bit nodes
- *   0x010 = 32 bit nodes
- *   0x110 = 64 bit nodes
+ *   0b??1 = Root
+ *   0b?00 = 16 bit nodes
+ *   0b010 = 32 bit nodes
+ *   0b110 = 64 bit nodes
  *
  *  Slot size and location in the parent pointer:
  *   type  : slot location
- *   0x??1 : Root
- *   0x?00 : 16 bit values, type in 0-1, slot in 2-6
- *   0x010 : 32 bit values, type in 0-2, slot in 3-6
- *   0x110 : 64 bit values, type in 0-2, slot in 3-6
+ *   0b??1 : Root
+ *   0b?00 : 16 bit values, type in 0-1, slot in 2-6
+ *   0b010 : 32 bit values, type in 0-2, slot in 3-6
+ *   0b110 : 64 bit values, type in 0-2, slot in 3-6
  */
 
 /*
--- a/lib/maple_tree.c~maple_tree-fix-maple_parent_range32-and-parent-pointer-docs
+++ a/lib/maple_tree.c
@@ -405,11 +405,11 @@ static __always_inline bool mt_is_alloc(
  * a reuse of the last bit in the node type.  This is possible by using bit 1 to
  * indicate if bit 2 is part of the type or the slot.
  *
- * Note types:
- *  0x??1 = Root
- *  0x?00 = 16 bit nodes
- *  0x010 = 32 bit nodes
- *  0x110 = 64 bit nodes
+ * Node types:
+ *  0b??1 = Root
+ *  0b?00 = 16 bit nodes
+ *  0b010 = 32 bit nodes
+ *  0b110 = 64 bit nodes
  *
  * Slot size and alignment
  *  0b??1 : Root
@@ -427,7 +427,7 @@ static __always_inline bool mt_is_alloc(
 #define MAPLE_PARENT_16B_SLOT_MASK	0xFC
 
 #define MAPLE_PARENT_RANGE64		0x06
-#define MAPLE_PARENT_RANGE32		0x04
+#define MAPLE_PARENT_RANGE32		0x02
 #define MAPLE_PARENT_NOT_RANGE16	0x02
 
 /*
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-nommu-convert-kobjsize-to-folios.patch
maple_tree-fix-maple_parent_range32-and-parent-pointer-docs.patch

