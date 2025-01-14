Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580B723A10F
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836954; cv=none; b=F2iL3oEjaaddUNXhu3hwSngDYmjYnJ+LIl3ap3ivq+NnVJdJiSj3CF7YlMYPxJ3ONHDpGmhm1U+MzMeh2omy8bHQ1pRs75uRNBF/gGxNPNlRGHsiR2tj5JIgB7XjupjSrRmSvust4UzKKEfWpQFTnPnt0aV/g5rLsOYo2+T9/dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836954; c=relaxed/simple;
	bh=AQY+Q93q3yt3b6OwortXAZvRVLe7vCvIi2Htwnam7sU=;
	h=Date:To:From:Subject:Message-Id; b=YJI1tb7jEXejF8nCz+FlhsvA14LSricZXr6VlrSR4+7GUiMQLtjcU93SW5rFSsIF8dVT549ib9crZ+8x1KpDbvQgu4K/qTX5DB2h1DLnx9zh+fjPJGJ0dunGCQGV4iAOhsrlkJCoXahMmtXEIHilvSuEYuUWsv7SWJA0LjcpmBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jfe/Oga+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jfe/Oga+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAABC4CEDD;
	Tue, 14 Jan 2025 06:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836953;
	bh=AQY+Q93q3yt3b6OwortXAZvRVLe7vCvIi2Htwnam7sU=;
	h=Date:To:From:Subject:From;
	b=jfe/Oga+VIpOVUkMjaoJ4LOodFw54kyEo4PW6zoZX2Su5La+BdZg91LPep20cJSYW
	 DXD5aTeknCDtaZgm+T8r+/yMcSeeGVtGDN4G1lT7Zk4eqVw4WrCzJn3LSNiiTyOgti
	 dkN7PaOZHo9DEhFqNcG4KrtElrWcEcKiw8scxqz4=
Date: Mon, 13 Jan 2025 22:42:33 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch removed from -mm tree
Message-Id: <20250114064233.CAAABC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: index has been checked to be smaller than pivot
has been removed from the -mm tree.  Its filename was
     maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4882,13 +4882,12 @@ static inline bool mas_anode_descend(str
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


