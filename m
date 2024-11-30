Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBF01EB3D
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939500; cv=none; b=JyrSEeITgbAHdfqnbYxpiyX9JihemHsdAJjnpXQFe8uMjAZo17iSy921V4P6e9fAoJE8wtu6DFwt/NlFgenpxGKPTIQ8Z0r0eEndBpc/4fFlYyrlSPYnJEFatLWBQ7WPkaQciZbMOoTWqJB+ivq4HTiBxhqHkqP4YraPtdOqB3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939500; c=relaxed/simple;
	bh=Rj7PQ5zv2j/yEfocw83BFZ+reziZzTtXaSfa2snsqDs=;
	h=Date:To:From:Subject:Message-Id; b=UgWLIEwCXVdySe3ukPhb6oKv53HUqBTOcHhQXvlnGHeBtXYB0APWpLFTKpyC025fuxqbGIBuHzGKbFoWF0PWwvP10M9/q4w8NrBOXJQJil/BH5TH1FzRfAOLIRIDpROYzHjnBf0hjxr+oZ+3CtZio77GuFpWRlA37ZlxDxmZf8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ROA++KA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ROA++KA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D679C4CECC;
	Sat, 30 Nov 2024 04:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939500;
	bh=Rj7PQ5zv2j/yEfocw83BFZ+reziZzTtXaSfa2snsqDs=;
	h=Date:To:From:Subject:From;
	b=1ROA++KAkqvfd23bHlN7bAqT7FBeq3R9DWbEolNMCRBO5nfPZZ0UO1acn7j4KiHeU
	 YPplgUChooF8zebie2RZeQIPo0ApG/Uq/UyKTQZKHQTAonXnz1g1+EdfqtaYRoHiR8
	 wx2L4U5mzTiUz/P9M6ub11RafHmHO1rGD23GmeSA=
Date: Fri, 29 Nov 2024 20:04:59 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch added to mm-unstable branch
Message-Id: <20241130040500.3D679C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: index has been checked to be smaller than pivot
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch

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
Subject: maple_tree: index has been checked to be smaller than pivot
Date: Sat, 16 Nov 2024 01:48:03 +0000

Patch series "mas_anode_descend() related cleanup".

Some cleanup related to mas_anode_descend().


This patch (of 3):

At the beginning of loop, it has checked the range is in lower bounds.

Link: https://lkml.kernel.org/r/20241116014805.11547-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20241116014805.11547-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/lib/maple_tree.c~maple_tree-index-has-been-checked-to-be-smaller-than-pivot
+++ a/lib/maple_tree.c
@@ -4881,13 +4881,12 @@ static inline bool mas_anode_descend(str
 				found = true;
 				goto done;
 			}
-			if (mas->index <= pivot) {
-				mas->node = mas_slot(mas, slots, offset);
-				mas->min = min;
-				mas->max = pivot;
-				offset = 0;
-				break;
-			}
+
+			mas->node = mas_slot(mas, slots, offset);
+			mas->min = min;
+			mas->max = pivot;
+			offset = 0;
+			break;
 		}
 next_slot:
 		min = pivot + 1;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-use-mas_next_slot-directly.patch
maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch
maple_tree-not-possible-to-be-a-root-node-after-loop.patch
maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch

