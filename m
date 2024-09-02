Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632AA14290
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 00:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725235212; cv=none; b=dKiGlKycY6n1d3k5CXdhIY2Kqz/tu1Lhqf1loDu+Cx886bNUnmOgAPDfzbqzD9jP3LDEx8Th12oxvglJQQ8Mv3iVsIGYzXeLN/JPVJUFGPR1MFF0W6RJ8yip/st9pH++k/lvHeu18ZTaxiXSVfr8fsc2LOxUDaFzRbK2/wbeH6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725235212; c=relaxed/simple;
	bh=1UiApV1UJ/ok52iq8xkHs5ACfvwaZySct5FHRdBQMSg=;
	h=Date:To:From:Subject:Message-Id; b=Hz0+iH9DdGwl7tXfDz1A7EdkDyJtFJfZ5Okccep1BsU1kMt7LPQhNFgW8N1Vv5kXo44T81ZXWXgo8eBoyiII6pD4N78cx5D+tMs7lgN4T6F77RVUpy3baYQ0omGUUWq+9uWSb8P52olkt0YpvuxRA0tBC4IUHIY08biO1TZcmSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sOm3cXJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sOm3cXJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67E7C4CEC3;
	Mon,  2 Sep 2024 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725235210;
	bh=1UiApV1UJ/ok52iq8xkHs5ACfvwaZySct5FHRdBQMSg=;
	h=Date:To:From:Subject:From;
	b=sOm3cXJ5i63XSL/cKfVvSvt62DmfvFFj2QZzchFV07tRATi3gNfl9TcKsFRU1NLZ6
	 BoQtEnZ+Yux3jDo30sWYnbk3H/oCUyax8UEip2Uy7vYUfBvha3DvGiBdFbkalkmuKL
	 HZA1LJVme4WG4eUawrcZ2xyELfNbZDwiq+8OFcu8=
Date: Sun, 01 Sep 2024 17:00:10 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch added to mm-unstable branch
Message-Id: <20240902000010.D67E7C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use mas_safe_pivot() to get the pivot range
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch

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
Subject: maple_tree: use mas_safe_pivot() to get the pivot range
Date: Sat, 31 Aug 2024 00:10:52 +0000

Before modifying data, we need to walk the tree to locate the
maple_node. Also we get the range boundary at offset/offset_end.

For the upper boundary at offset, we have defined function
mas_safe_pivot() to get it. Let's leverage it.

Link: https://lkml.kernel.org/r/20240831001053.4751-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_safe_pivot-to-get-the-pivot-range
+++ a/lib/maple_tree.c
@@ -2191,7 +2191,7 @@ static inline void mas_wr_node_walk(stru
 	while (offset < count && mas->index > wr_mas->pivots[offset])
 		offset++;
 
-	wr_mas->r_max = offset < count ? wr_mas->pivots[offset] : mas->max;
+	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, offset, wr_mas->type);
 	wr_mas->r_min = mas_safe_min(mas, wr_mas->pivots, offset);
 	wr_mas->offset_end = mas->offset = offset;
 }
@@ -3898,11 +3898,9 @@ static inline void mas_wr_extend_null(st
 		    (mas->end != wr_mas->offset_end) &&
 		    !wr_mas->slots[wr_mas->offset_end + 1]) {
 			wr_mas->offset_end++;
-			if (wr_mas->offset_end == mas->end)
-				mas->last = mas->max;
-			else
-				mas->last = wr_mas->pivots[wr_mas->offset_end];
-			wr_mas->end_piv = mas->last;
+			wr_mas->end_piv = mas->last =
+				mas_safe_pivot(mas, wr_mas->pivots,
+					wr_mas->offset_end, wr_mas->type);
 		}
 	}
 
@@ -3927,10 +3925,8 @@ static inline void mas_wr_end_piv(struct
 	       (wr_mas->mas->last > wr_mas->pivots[wr_mas->offset_end]))
 		wr_mas->offset_end++;
 
-	if (wr_mas->offset_end < wr_mas->mas->end)
-		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
-	else
-		wr_mas->end_piv = wr_mas->mas->max;
+	wr_mas->end_piv = mas_safe_pivot(wr_mas->mas, wr_mas->pivots,
+				wr_mas->offset_end, wr_mas->type);
 }
 
 static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
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

