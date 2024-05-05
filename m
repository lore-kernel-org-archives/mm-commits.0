Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB427580E
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942888; cv=none; b=X1fnsoopyuiBSys8Tetw229MTQFTyDUU33KlYVCgwLMv9QEnuLZPJXI25HM9Kt1T4tZNLIbi5dQxgHvKpe1yUXCTXtReOa/faUTEgT6wahiMVzDpoUvoa+67pQVl/ue0FWV+YWO3Q78PuS0ZFDDx9k36Km+Sxi7NhdVbpXyRqHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942888; c=relaxed/simple;
	bh=vyntDU90zvLeMdj/reiDfyKFdg9gGeWl3PeIlIvri2s=;
	h=Date:To:From:Subject:Message-Id; b=DaP4KXOUHC4+LPjIzq8c09CFXx3yd7IeJwD4nin6YXGXnOngzwAtf7+1DyxqpqtEO+P8ZjwyO5UqiMmZ6L4inkd/I6gEUaIFaoiFPdF/+1mN3j++nndVE2ET6D+fsiF4xMh8A4iu13u9eDUH87ItLp/9EUJoelTVl74MYpdxqNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aS1QELBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aS1QELBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFDCC113CC;
	Sun,  5 May 2024 21:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942888;
	bh=vyntDU90zvLeMdj/reiDfyKFdg9gGeWl3PeIlIvri2s=;
	h=Date:To:From:Subject:From;
	b=aS1QELBglj/cQC0hwylDoo0QFJQVyZgIS974B5kbLG+lWSU6luKeivfi9Mn60d3yX
	 /Jn5T6rPCIu4EmlAmdngFor6jl1kbFw6r6Ioe8BrcE0vhDMmPiUFFZNp5u4a5cFMLq
	 4WMcsuinH63x4O4aaNJCNeZg4pjTw/RTwf20IYgg=
Date: Sun, 05 May 2024 14:01:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,Liam.Howlett@oracle.com,justinstitt@google.com,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-build-failure-with-w=1-and-llvm=1.patch added to mm-unstable branch
Message-Id: <20240505210128.5AFDCC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix build failure with W=1 and LLVM=1
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-build-failure-with-w=1-and-llvm=1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-build-failure-with-w=1-and-llvm=1.patch

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

maple_tree-fix-build-failure-with-w=1-and-llvm=1.patch

