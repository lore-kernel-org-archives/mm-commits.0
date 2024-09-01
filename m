Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2645A3FC7
	for <mm-commits@vger.kernel.org>; Sun,  1 Sep 2024 22:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725231089; cv=none; b=NHPd9VJhXvivcyhBNZR2XPS/RwgRXq8XYah7xFmQ27pCIRkGYOZSs9/Va2E1+pHjb/rAS0PkPjn/WoEqyvEUz9kMrUsOWOstlPoYMZsN9wZBHAbnV4e1kEZM2byx6oh5+OrlIAZYNpyW77Xbt7+qQqt9D8f8eM/7ldwvHDl9csg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725231089; c=relaxed/simple;
	bh=fnjmlnIrIVwy9r/G5XwstV/2GRjcqWXja819NIpi2FA=;
	h=Date:To:From:Subject:Message-Id; b=QHiHlNR7bFj5mU1n3lacjPnbILCFY2V5VqSD3zDnFu6D0lr9EgaIsoUc+5fnOuR8MWn6Qntbr2c/BhG4xiUMkBFfPrO7wrgyP9vN/Ouy9dzDO570qd3Ml4oM2mqzGTz3QR8DCik5yt5MGr/C164fNcR9CKlvrdPtFAmQEaw5P7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X/jNyYqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X/jNyYqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB43C4CEC3;
	Sun,  1 Sep 2024 22:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725231088;
	bh=fnjmlnIrIVwy9r/G5XwstV/2GRjcqWXja819NIpi2FA=;
	h=Date:To:From:Subject:From;
	b=X/jNyYqGVsd0pRq7ebZ9QxlKNKqT9yWQlj9ViqQxg7rCW6L8DXaKTz7LwHoXC50KD
	 +y6cvAExdA7BuxUldkffdpvq+QzfX3ajlzfrIDNgrDuacPQWt9HLgogoh8AynluQvG
	 3Lm36DtLvLvb0qtOIq/cHyLJsJ1h7PXhXQ9aEN48=
Date: Sun, 01 Sep 2024 15:51:27 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch added to mm-unstable branch
Message-Id: <20240901225128.9BB43C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix comment typo on ma_flag of allocation tree
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch

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
Subject: maple_tree: fix comment typo on ma_flag of allocation tree
Date: Fri, 9 Aug 2024 02:01:15 +0000

The maple tree flag of allocation tree is MT_FLAGS_ALLOC_RANGE.

Just correct it.

Link: https://lkml.kernel.org/r/20240809020115.31575-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree
+++ a/include/linux/maple_tree.h
@@ -52,9 +52,9 @@
  * bit in the node type.  This is possible by using bit 1 to indicate if bit 2
  * is part of the type or the slot.
  *
- * Once the type is decided, the decision of an allocation range type or a range
- * type is done by examining the immutable tree flag for the MAPLE_ALLOC_RANGE
- * flag.
+ * Once the type is decided, the decision of an allocation range type or a
+ * range type is done by examining the immutable tree flag for the
+ * MT_FLAGS_ALLOC_RANGE flag.
  *
  *  Node types:
  *   0x??1 = Root
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

