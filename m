Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6798123A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836955; cv=none; b=LBOxNGjdUT4vU7cqGuLC+Ndb2Ja2g4c3iiJB70ZipSFkYikcpSKkZi6d3e/vplZkfK9YTn/3bbx/Z6qL44ADgOiXdaXle990eJuGdZkEKGq1zhdtNg80F9UtQwvdL9HCEsQt6KCd5187eXfSxfsWq9V5JcrM2ZRlLYS0jKsf/uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836955; c=relaxed/simple;
	bh=uiuN8dVTWaV7lXZG6W6ors8Ieb0SwPoDe+NwPL5ISv8=;
	h=Date:To:From:Subject:Message-Id; b=EcPzjreb9UgFdNPHkwFAN47Slq61ek1H2D2E0Dp5Ehqpct0iSEqcTSFMbN2lz7xU5iLnv2+UEMHrgp6ez8aUPjLoBMzpfrhYWKglXJXfXR2ZyuE0IEdIn7VFxy0piF4IPA0JmqU6v033vsyyIxPm0kqqseKq3GE7WIy+G0ixVQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ced8TE7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ced8TE7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E168AC4CEDD;
	Tue, 14 Jan 2025 06:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836955;
	bh=uiuN8dVTWaV7lXZG6W6ors8Ieb0SwPoDe+NwPL5ISv8=;
	h=Date:To:From:Subject:From;
	b=ced8TE7kvyAJREIVcJUnbSENshIDB1JVqcs+YqdYfvA/YzDGI66N92hvt72qO9QQ2
	 xHi3v5VNgNZGnBuCusuMHvIUSpRhKz2R+FtdXCo8G8RL/pOp80P/KrRdGv0LYtAdWF
	 Y/5MZwlSNEw0A8dAM5Bkcevf1nAzbjwGRzPQvNZs=
Date: Mon, 13 Jan 2025 22:42:34 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-not-possible-to-be-a-root-node-after-loop.patch removed from -mm tree
Message-Id: <20250114064234.E168AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: not possible to be a root node after loop
has been removed from the -mm tree.  Its filename was
     maple_tree-not-possible-to-be-a-root-node-after-loop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4880,7 +4880,7 @@ static inline bool mas_anode_descend(str
 		if (gap >= size) {
 			if (ma_is_leaf(type)) {
 				found = true;
-				goto done;
+				break;
 			}
 
 			mas->node = mas_slot(mas, slots, offset);
@@ -4897,9 +4897,6 @@ next_slot:
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


