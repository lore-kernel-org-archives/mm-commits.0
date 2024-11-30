Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50621EB3D
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939502; cv=none; b=pR170HFS/252NeDCE4uo89l66GmoglBp8StHcRModBunbMbmwEZD05xpORe2A4p0j/SkJhs1nPQFkSI1vlAPc5uzqyvghTXSOBGobxzkDIvuMdketgtpTbbwdEf9LGDDk/TlZHH0RxVA1E5P1WLCpz70D6kntnDVT1xf9MxmPz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939502; c=relaxed/simple;
	bh=KVMPqfHCRZadzhaEdTjYm1EcTzFF9LveMFx6rZEbOTM=;
	h=Date:To:From:Subject:Message-Id; b=hW8ZDPkCDLjWtJXfpTzlTkybVM9YFF82JXEsWUXVoiTX0hxDKg+p/5aZotfc8x8T0ABX8fcVAeiH7MEqX722oKEx9yTeGMct97P1qqfZ0/Tg5WjBVIxsd+/jVkGRXjXsL4LopU4P60vV5dWgI7FsB6y2QzDg7MDFKcrK9agfNW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pavyjr7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pavyjr7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253CBC4CECC;
	Sat, 30 Nov 2024 04:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939502;
	bh=KVMPqfHCRZadzhaEdTjYm1EcTzFF9LveMFx6rZEbOTM=;
	h=Date:To:From:Subject:From;
	b=pavyjr7DspOuYU5G8+Wk7i81uUGZQCIHJY1LOo2bmtSVQF5c/t0qNMZWdGWDA5Y0H
	 IlIoZ9beu2k+qnXydHQQI0CGcrVEwpSVUynI53AW0LEdb+B23KQsccClfr6WQI4Zxk
	 8iNBr4unGi7JuQV06sxaBjlbz3qoweIiVNcE1d3Q=
Date: Fri, 29 Nov 2024 20:05:01 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-not-possible-to-be-a-root-node-after-loop.patch added to mm-unstable branch
Message-Id: <20241130040502.253CBC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: not possible to be a root node after loop
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-not-possible-to-be-a-root-node-after-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-not-possible-to-be-a-root-node-after-loop.patch

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
Subject: maple_tree: not possible to be a root node after loop
Date: Sat, 16 Nov 2024 01:48:04 +0000

Empty tree and single entry tree is handled else whether, so the maple
tree here must be a tree with nodes.

If the height is 1 and we found the gap, it will jump to *done* since it
is also a leaf.

If the height is more than one, and there may be an available range, we
will descend the tree, which is not root anymore.

If there is no available range, we will set error and return.

This means the check for root node here is not necessary.

Link: https://lkml.kernel.org/r/20241116014805.11547-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-not-possible-to-be-a-root-node-after-loop
+++ a/lib/maple_tree.c
@@ -4879,7 +4879,7 @@ static inline bool mas_anode_descend(str
 		if (gap >= size) {
 			if (ma_is_leaf(type)) {
 				found = true;
-				goto done;
+				break;
 			}
 
 			mas->node = mas_slot(mas, slots, offset);
@@ -4896,9 +4896,6 @@ next_slot:
 		}
 	}
 
-	if (mte_is_root(mas->node))
-		found = true;
-done:
 	mas->offset = offset;
 	return found;
 }
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-use-mas_next_slot-directly.patch
maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch
maple_tree-not-possible-to-be-a-root-node-after-loop.patch
maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch

