Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB4C157499
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 17:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715018240; cv=none; b=Bly9dCzrrX/JNY+++R0Vo4Pt5pkV1TpEyPlOJAiBVk2DIpS7VW6DtnVqZGGzSoE+pksk1MTX9Y2NnIJApFd2ERwbbaXf9/RYGG71f78QblRu5FCMoKJTqyejFMthum9afRfon9PPcnfc6XwPpLm5ntqd8s2msQCRf75YdQWtVtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715018240; c=relaxed/simple;
	bh=q1RBJ2m2DpCtfV0hEsmURl5BS1HY0zi7y5JLYGG3kWQ=;
	h=Date:To:From:Subject:Message-Id; b=UZcFw03p6Tf63nyQsbvXZI6MRf3NEH0Mnb+U0OpXdZdT1R4ZSm/UrRijBHh5j+Zkz3RkDmhtvlYZJyxpd8ekLCvw4tvrfilvL9Exom7Ie7DEqqLDlmijJ1f56L3bePBKQ5Yz3yEjB8CCPnOa5XBcvUeNuKMazD0cSm/8Kmd4Gsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gydrceqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gydrceqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4CDC116B1;
	Mon,  6 May 2024 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715018239;
	bh=q1RBJ2m2DpCtfV0hEsmURl5BS1HY0zi7y5JLYGG3kWQ=;
	h=Date:To:From:Subject:From;
	b=gydrceqcn8Mn1iiTdNPyodLPAkvx4JMjeC2Ba6z4kpGyOQPxcKzQax66wVPlyQRdt
	 wav4xdHpexOP1WyqsOm5iC8kbp6JKnke7/mEXNaM/yiqzPtNDxKtySk8UJ8zA91ERK
	 oRfS76TeLTpczv05iJ7byZ5F84ETXPBjc3GB4QcE=
Date: Mon, 06 May 2024 10:57:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,Liam.Howlett@oracle.com,justinstitt@google.com,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] maple_tree-fix-build-failure-with-w=1-and-llvm=1.patch removed from -mm tree
Message-Id: <20240506175719.AC4CDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix build failure with W=1 and LLVM=1
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-build-failure-with-w=1-and-llvm=1.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: maple_tree: fix build failure with W=1 and LLVM=1
Date: Fri, 3 May 2024 17:50:27 +0800

When compiling library code using "make W=1 LLVM=1 lib/", clang generated
the following compilation errors:

lib/maple_tree.c:351:21: error: unused function 'mte_set_full' [-Werror,-Wunused-function]
static inline void *mte_set_full(const struct maple_enode *node)
                    ^
lib/maple_tree.c:356:21: error: unused function 'mte_clear_full' [-Werror,-Wunused-function]
static inline void *mte_clear_full(const struct maple_enode *node)
                    ^
lib/maple_tree.c:361:20: error: unused function 'mte_has_null' [-Werror,-Wunused-function]
static inline bool mte_has_null(const struct maple_enode *node)
                   ^
3 errors generated.

Remove unused static inline functions to resolve compilation errors
with clang.

Link: https://lkml.kernel.org/r/20240503095027.747838-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-build-failure-with-w=1-and-llvm=1
+++ a/lib/maple_tree.c
@@ -348,21 +348,6 @@ static inline void *mte_safe_root(const
 	return (void *)((unsigned long)node & ~MAPLE_ROOT_NODE);
 }
 
-static inline void *mte_set_full(const struct maple_enode *node)
-{
-	return (void *)((unsigned long)node & ~MAPLE_ENODE_NULL);
-}
-
-static inline void *mte_clear_full(const struct maple_enode *node)
-{
-	return (void *)((unsigned long)node | MAPLE_ENODE_NULL);
-}
-
-static inline bool mte_has_null(const struct maple_enode *node)
-{
-	return (unsigned long)node & MAPLE_ENODE_NULL;
-}
-
 static __always_inline bool ma_is_root(struct maple_node *node)
 {
 	return ((unsigned long)node->parent & MA_ROOT_PARENT);
_

Patches currently in -mm which might be from visitorckw@gmail.com are


