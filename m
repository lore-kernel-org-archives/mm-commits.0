Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F70C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011123; cv=none; b=YiTeXQ1HNCxOWQu/D49aj1+Zk3FsoIjAi3ZYAB95v2bhd8dpfR7+ra1jMICrMELv5WBsiPNAShtau+ZN+eSrXmfhxk3WBscYy0JoRMjK82uUR6kLVCThi+nCKpTEAmI4biE/ENIa/jr8gmt7aLtAyxFlCHmdO1VY3hksc8z6hX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011123; c=relaxed/simple;
	bh=ZG/DMl7a2DPwvvbj0J7bDWQ6WCY4b1Tm7z0OmmyqpUI=;
	h=Date:To:From:Subject:Message-Id; b=X7sRAQzsIcKw8cqJVfNmUXkQM6vsYPu6/F7PHegjJcF/4zXX3D11kkNWd0jQfYQGL6GUHzbsWE0pVh3DHsas6e+5KTm55+SHCcCCvhmRl9WIA+WOwOrs/Q9SPeeMnfHXWs9v3orz4ZIHP6fewLD/DhiaPNSPKMPAqMzaprzoXrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LrBmi3FE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LrBmi3FE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E48DC4CEE4;
	Mon, 12 May 2025 00:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011123;
	bh=ZG/DMl7a2DPwvvbj0J7bDWQ6WCY4b1Tm7z0OmmyqpUI=;
	h=Date:To:From:Subject:From;
	b=LrBmi3FEEuKjlJAtNOa4M+A/LSamKDpSVRVsAE57Z+w6CJX5Gzr2HJZGZH3/SKyD9
	 EvXe3O87qXoqAIRagwoRG02+W3QzOZoBi2NI33SUtpPW+OaxMmsrHlvAp5xTM+JTfn
	 Rcz2G2Q1ltAaH5yx/AU3PCJnYoM6IKCcKEr812EU=
Date: Sun, 11 May 2025 17:52:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-reorder-mas-store_type-case-statements.patch removed from -mm tree
Message-Id: <20250512005203.2E48DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: reorder mas->store_type case statements
has been removed from the -mm tree.  Its filename was
     maple_tree-reorder-mas-store_type-case-statements.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: reorder mas->store_type case statements
Date: Thu, 10 Apr 2025 19:14:46 +0000

Move the unlikely case that mas->store_type is invalid to be the last
evaluated case and put liklier cases higher up.

Link: https://lkml.kernel.org/r/20250410191446.2474640-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Liam R. Howlett <liam.howlett@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   51 ++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

--- a/lib/maple_tree.c~maple_tree-reorder-mas-store_type-case-statements
+++ a/lib/maple_tree.c
@@ -4083,15 +4083,6 @@ static inline void mas_wr_store_entry(st
 	unsigned char new_end = mas_wr_new_end(wr_mas);
 
 	switch (mas->store_type) {
-	case wr_invalid:
-		MT_BUG_ON(mas->tree, 1);
-		return;
-	case wr_new_root:
-		mas_new_root(mas, wr_mas->entry);
-		break;
-	case wr_store_root:
-		mas_store_root(mas, wr_mas->entry);
-		break;
 	case wr_exact_fit:
 		rcu_assign_pointer(wr_mas->slots[mas->offset], wr_mas->entry);
 		if (!!wr_mas->entry ^ !!wr_mas->content)
@@ -4113,6 +4104,14 @@ static inline void mas_wr_store_entry(st
 	case wr_rebalance:
 		mas_wr_bnode(wr_mas);
 		break;
+	case wr_new_root:
+		mas_new_root(mas, wr_mas->entry);
+		break;
+	case wr_store_root:
+		mas_store_root(mas, wr_mas->entry);
+		break;
+	case wr_invalid:
+		MT_BUG_ON(mas->tree, 1);
 	}
 
 	return;
@@ -4177,19 +4176,10 @@ static inline int mas_prealloc_calc(stru
 	unsigned char delta = height - wr_mas->vacant_height;
 
 	switch (mas->store_type) {
-	case wr_invalid:
-		WARN_ON_ONCE(1);
-		break;
-	case wr_new_root:
-		ret = 1;
-		break;
-	case wr_store_root:
-		if (likely((mas->last != 0) || (mas->index != 0)))
-			ret = 1;
-		else if (((unsigned long) (entry) & 3) == 2)
-			ret = 1;
-		else
-			ret = 0;
+	case wr_exact_fit:
+	case wr_append:
+	case wr_slot_store:
+		ret = 0;
 		break;
 	case wr_spanning_store:
 		if (wr_mas->sufficient_height < wr_mas->vacant_height)
@@ -4209,10 +4199,19 @@ static inline int mas_prealloc_calc(stru
 	case wr_node_store:
 		ret = mt_in_rcu(mas->tree) ? 1 : 0;
 		break;
-	case wr_append:
-	case wr_exact_fit:
-	case wr_slot_store:
-		ret = 0;
+	case wr_new_root:
+		ret = 1;
+		break;
+	case wr_store_root:
+		if (likely((mas->last != 0) || (mas->index != 0)))
+			ret = 1;
+		else if (((unsigned long) (entry) & 3) == 2)
+			ret = 1;
+		else
+			ret = 0;
+		break;
+	case wr_invalid:
+		WARN_ON_ONCE(1);
 	}
 
 	return ret;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


