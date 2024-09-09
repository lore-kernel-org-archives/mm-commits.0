Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E7E18E375
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925320; cv=none; b=ok/BopP/27IKHZGuyLHX3xkoJjTsJgOCFErTWkVAKoHBFLXgP+N3uPfWZ/zXe9x2Ybc0WTSjR1SRcGmV3j3QVSQr0aiWmB7Ic7oJkNLFl44KoOcv4RvCOd+2U+QIO8TQpKxNjJwSXT8itCRvNY1CQ3YfouiPuC346nG0Nych1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925320; c=relaxed/simple;
	bh=En6SmwQl+RhO2TF8/jjBjhM/2pPBysE4/7LWz7G6528=;
	h=Date:To:From:Subject:Message-Id; b=ha6v1ytfRSvx3zCbz58KVdAtop37zFcbNCUaSb1DmyPoDHcakQmKC0qpkWf4+Tmu0jqI89iEnCvywJlqFEhb7uwbHfbuEYQpTkI1sx71tNLcioY55md07qoFEX8LIJzz2mU/jRm9nXLsvUG3c192bzCpU47H+/SVNYRkXobWNd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0DkbzU3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0DkbzU3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD57C4CECA;
	Mon,  9 Sep 2024 23:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925320;
	bh=En6SmwQl+RhO2TF8/jjBjhM/2pPBysE4/7LWz7G6528=;
	h=Date:To:From:Subject:From;
	b=0DkbzU3Kk2gnZL6G5ut3db46B5+rMDNdKSdV0RbxClNy3bIjH9QgIYLuO9WBi+otO
	 lAk1nP0CT4qbdFINNY9dltqNJnHf899uGinzpUKxGfv8DuSirl9Hf1ZLLyMOmhXhUQ
	 MSBcfNAvf73R+db5PUTbRfSQ2OqveZRbjJssYxv0=
Date: Mon, 09 Sep 2024 16:41:59 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-mark-three-functions-as-__maybe_unused.patch removed from -mm tree
Message-Id: <20240909234200.5DD57C4CECA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: mark three functions as __maybe_unused
has been removed from the -mm tree.  Its filename was
     maple_tree-mark-three-functions-as-__maybe_unused.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: mark three functions as __maybe_unused
Date: Fri, 6 Sep 2024 22:15:06 -0400

People keep trying to remove three functions that are going to be used in
a feature that is being developed.  Dropping the functions entirely may
end up with people trying to use the bit for other uses, as people have
tried in the past.

Adding __maybe_unused stops compilers complaining about the unused
functions so they can be silently optimised out of the compiled code and
people won't try to claim the bit for another use.

Link: https://lore.kernel.org/all/20230726080916.17454-2-zhangpeng.00@bytedance.com/
Link: https://lore.kernel.org/all/202408310728.S7EE59BN-lkp@intel.com/
Link: https://lkml.kernel.org/r/20240907021506.4018676-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-mark-three-functions-as-__maybe_unused
+++ a/lib/maple_tree.c
@@ -348,17 +348,17 @@ static inline void *mte_safe_root(const
 	return (void *)((unsigned long)node & ~MAPLE_ROOT_NODE);
 }
 
-static inline void *mte_set_full(const struct maple_enode *node)
+static inline void __maybe_unused *mte_set_full(const struct maple_enode *node)
 {
 	return (void *)((unsigned long)node & ~MAPLE_ENODE_NULL);
 }
 
-static inline void *mte_clear_full(const struct maple_enode *node)
+static inline void __maybe_unused *mte_clear_full(const struct maple_enode *node)
 {
 	return (void *)((unsigned long)node | MAPLE_ENODE_NULL);
 }
 
-static inline bool mte_has_null(const struct maple_enode *node)
+static inline bool __maybe_unused mte_has_null(const struct maple_enode *node)
 {
 	return (unsigned long)node & MAPLE_ENODE_NULL;
 }
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


