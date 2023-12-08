Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B98641C8E
	for <mm-commits@vger.kernel.org>; Fri,  8 Dec 2023 19:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aYvxdl32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3580BC433C7;
	Fri,  8 Dec 2023 19:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702065344;
	bh=PfZ49dfITMSk6tJfHts/Nvkg4IeU/h1kZLtKaPlI1TU=;
	h=Date:To:From:Subject:From;
	b=aYvxdl32DIq4Zh0nQQcTufSApztpOME+kyrhIX52yF4FDrHBgLHKfcLd3fy/69Oui
	 sKYpz2NJn5rcFAXCugVb0mWH9sdWrnYa8fbxsq5qJGZDE+L7U1aCzvLE0gckrwDnCV
	 2eGTCj9I3iVL0GLRp7pktaoFUAdtNqk/bKHkr8SM=
Date: Fri, 08 Dec 2023 11:55:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,abaci@linux.alibaba.com,jiapeng.chong@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-warning-comparing-pointer-to-0.patch added to mm-unstable branch
Message-Id: <20231208195544.3580BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: Fix warning comparing pointer to 0
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-warning-comparing-pointer-to-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-warning-comparing-pointer-to-0.patch

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
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: maple_tree: Fix warning comparing pointer to 0
Date: Fri, 8 Dec 2023 10:04:50 +0800

Avoid pointer type value compared with 0 to make code clear.

./tools/testing/radix-tree/maple.c:34142:15-16: WARNING comparing pointer to 0.

Link: https://lkml.kernel.org/r/20231208020450.7003-1-jiapeng.chong@linux.alibaba.com
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7696
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/radix-tree/maple.c~maple_tree-fix-warning-comparing-pointer-to-0
+++ a/tools/testing/radix-tree/maple.c
@@ -34139,7 +34139,7 @@ STORE, 140501948112896, 140501948116991,
 	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
 	check_erase2_testset(mt, set27, ARRAY_SIZE(set27));
 	rcu_barrier();
-	MT_BUG_ON(mt, 0 != mtree_load(mt, 140415537422336));
+	MT_BUG_ON(mt, NULL != mtree_load(mt, 140415537422336));
 	mt_set_non_kernel(0);
 	mt_validate(mt);
 	mtree_destroy(mt);
@@ -34263,7 +34263,7 @@ STORE, 140501948112896, 140501948116991,
 	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
 	check_erase2_testset(mt, set37, ARRAY_SIZE(set37));
 	rcu_barrier();
-	MT_BUG_ON(mt, 0 != mtree_load(mt, 94637033459712));
+	MT_BUG_ON(mt, NULL != mtree_load(mt, 94637033459712));
 	mt_validate(mt);
 	mtree_destroy(mt);
 
@@ -34271,7 +34271,7 @@ STORE, 140501948112896, 140501948116991,
 	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
 	check_erase2_testset(mt, set38, ARRAY_SIZE(set38));
 	rcu_barrier();
-	MT_BUG_ON(mt, 0 != mtree_load(mt, 94637033459712));
+	MT_BUG_ON(mt, NULL != mtree_load(mt, 94637033459712));
 	mt_validate(mt);
 	mtree_destroy(mt);
 
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are

maple_tree-remove-unused-function.patch
maple_tree-fix-warning-comparing-pointer-to-0.patch

