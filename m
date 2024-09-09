Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E801518A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925230; cv=none; b=Iw4H9sJGwtz4uLJvVZaurXtEsX7p6K08T9Ch3b5aSazNJ42/pNsspXaoQ97yJOo7EVsG3V9MSjrsDptGoQDKdwkUhv5Z9Fn0vKfQAty8zr2gdHXCrhuUQbphylAH4koasJVP7JNAp424IqoSjrBm5M+RnMGO51ZgSm2FM1SygOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925230; c=relaxed/simple;
	bh=tSMClI/mHTS54wZH/+L3oEwNKdX5z5AWLMBc0WyWnAU=;
	h=Date:To:From:Subject:Message-Id; b=DABLxSCUQhjRLguDXL1/wBxpW7d/ELIsXISCyYAK1+ccZaArCA5ZlAV61fznP/ethu0Agyp5ydoCZpMANJNFJoKiXgwPvvx9VrwnVHkYINu0+VYW13GSA8pP03nAhhOSkS4fyRKOLaRd7CcDP/D/4Hbidm1I+GqVVRlU0Ex/jZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VbfFHA9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VbfFHA9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF23DC4CEC5;
	Mon,  9 Sep 2024 23:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925229;
	bh=tSMClI/mHTS54wZH/+L3oEwNKdX5z5AWLMBc0WyWnAU=;
	h=Date:To:From:Subject:From;
	b=VbfFHA9t1LODEiiio4D+Mw3ozPH5jYi1OneMTYdzByca5HfROyShYAxju6lGHTd5R
	 LzDvWCt06pSWfcuZjbpnXjZjdhlKhjk79MG3N/T9r89MBPdF2an7yUhpWI6sS00pww
	 QGCDzocQI+gWLZj+Lx/PEX+NCYuNUg06ltzHWqNE=
Date: Mon, 09 Sep 2024 16:40:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-arange64-node-is-not-a-leaf-node.patch removed from -mm tree
Message-Id: <20240909234029.BF23DC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: arange64 node is not a leaf node
has been removed from the -mm tree.  Its filename was
     maple_tree-arange64-node-is-not-a-leaf-node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: arange64 node is not a leaf node
Date: Mon, 26 Aug 2024 01:24:21 +0000

mt_dump_arange64() only applies to an entry whose type is maple_arange_64,
in which mte_is_leaf() must return false.

Since mte_is_leaf() here is always false, we can remove this condition
check.

Link: https://lkml.kernel.org/r/20240826012422.29935-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-arange64-node-is-not-a-leaf-node
+++ a/lib/maple_tree.c
@@ -7203,7 +7203,6 @@ static void mt_dump_arange64(const struc
 	enum mt_dump_format format)
 {
 	struct maple_arange_64 *node = &mte_to_node(entry)->ma64;
-	bool leaf = mte_is_leaf(entry);
 	unsigned long first = min;
 	int i;
 
@@ -7237,10 +7236,7 @@ static void mt_dump_arange64(const struc
 			break;
 		if (last == 0 && i > 0)
 			break;
-		if (leaf)
-			mt_dump_entry(mt_slot(mt, node->slot, i),
-					first, last, depth + 1, format);
-		else if (node->slot[i])
+		if (node->slot[i])
 			mt_dump_node(mt, mt_slot(mt, node->slot, i),
 					first, last, depth + 1, format);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


