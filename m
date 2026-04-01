Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEC4184;
	Wed,  1 Apr 2026 03:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775014098; cv=none; b=MnQMeOtx6LzAu04+cejEuwBdYKj0Hl0NZI3pYvb8smcvT7TgGfdotekjyVEDpF3M2UwHFgz7aWEFbzDFZxf8nL4HoaE1pIPs21axZ1Pra//7H6tw3cMrXBDOPBioqOcu27nrJkSqx44UAaehw//Fbfe+YhYEBlbqPQ0FKW8rLbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775014098; c=relaxed/simple;
	bh=gfXXJ0R9XodJzZLl7hG+WRT5EKZofYA3Lu0joFbhfRI=;
	h=Date:To:From:Subject:Message-Id; b=R05WazqPnUA2RDgUh5KIYCYoTdKn80oRKb3Y6lDHSppaon6x6faFT0qluQALaI64ZbcXHR9DUIYXXINHw7gjjiaelJ5xgeHm3Hz0EMzDURdEEZ6QaDivsk9F1IFb/260HLoGLu9ggV/b2/BBxDonsJjrWWu4h978S+k8xYJrKY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rJDv3vNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rJDv3vNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08768C4CEF7;
	Wed,  1 Apr 2026 03:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775014098;
	bh=gfXXJ0R9XodJzZLl7hG+WRT5EKZofYA3Lu0joFbhfRI=;
	h=Date:To:From:Subject:From;
	b=rJDv3vNcDi0KFjO7v0F2epllI+LajwniV9UaCrLZvVePBP3N2M78EJXN/hw+h/CmG
	 WUFyE1dDGIU/mN2SvxWXA75iC5vxfBm70VkBYSRdGYvc67/qZwifdkcxczrRYuekLv
	 kVWr+WWQ417rZ7SFq86XBvPC3KB3nm6r0I8cUZdM=
Date: Tue, 31 Mar 2026 20:28:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,liam.howlett@oracle.com,andrewjballance@gmail.com,aliceryhl@google.com,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch removed from -mm tree
Message-Id: <20260401032818.08768C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/maple_tree: fix swapped arguments in mas_safe_pivot() call
has been removed from the -mm tree.  Its filename was
     lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/maple_tree: fix swapped arguments in mas_safe_pivot() call
Date: Fri, 6 Mar 2026 20:08:20 +0000

The call to mas_safe_pivot() in mas_wr_extend_null() has the pivot index
and maple type arguments swapped.  The function signature expects (mas,
pivots, piv, type) but the call passes (mas, pivots, type, piv).

This causes the pivot index to be interpreted as a maple node type and
vice versa, leading to incorrect pivot lookups.  In practice, this means a
null-extending store into a maple tree node can read the wrong pivot
value, potentially corrupting the range tracked by the maple state.  For a
VMA maple tree, this could cause an incorrect vm_area_struct range to be
returned during operations like mmap or munmap, leading to silent memory
mapping corruption.

Every other mas_safe_pivot() call site in the file passes the arguments in
the correct (piv, type) order; this is the only one with them reversed.

Link: https://lkml.kernel.org/r/20260306225849.2824409-1-objecting@objecting.org
Link: https://lkml.kernel.org/r/20260306223219.2824040-1-objecting@objecting.org
Link: https://lkml.kernel.org/r/20260306200820.2819999-1-objecting@objecting.org
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Josh Law <objecting@objecting.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call
+++ a/lib/maple_tree.c
@@ -2932,7 +2932,7 @@ static inline void mas_extend_spanning_n
 	    (r_mas->last < r_mas->max) &&
 	    !mas_slot_locked(r_mas, r_wr_mas->slots, r_mas->offset + 1)) {
 		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
-					     r_wr_mas->type, r_mas->offset + 1);
+					     r_mas->offset + 1, r_wr_mas->type);
 		r_mas->offset++;
 		r_wr_mas->r_max = r_mas->last;
 	}
_

Patches currently in -mm which might be from objecting@objecting.org are

lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

