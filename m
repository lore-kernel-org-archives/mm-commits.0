Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58C59461
	for <mm-commits@vger.kernel.org>; Tue, 17 Dec 2024 18:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734461271; cv=none; b=V6UgSZJLwqkEWlBoVZ1eDk3qshII8LcsYGlA8MLykEr/KE/ngQr5t+vvLG1TnEIBdvNgrPIandVNJ9DmjyTAH27mSVUkcduW2bvqFONCKnzYjKNeP+5UK4dXDLQvgxXSbouPNebI7DSAmqTS+ftHhgGA3wmfmPexlOcszZRhkQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734461271; c=relaxed/simple;
	bh=MOETiRKn/oNh+Y9hi24ChBgFQNEHt+lRnaf3hA/jPd4=;
	h=Date:To:From:Subject:Message-Id; b=a3/4IdvlQwgL8bwuJ/sVYlFWKBV96LCjZbByKCo3ivp38XiTyaCZqHEnL8A4Dy7dXxrbt/yQKcpsYUixfaKaLPDv2FPSYMmpFmgMAQOq6McNQyu0VVKbwfVWJnzujYoMeQjH4V8TGQ14fVmY/RT41+J7gPMgc2JSZicnYFH8NCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FDFbdfwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FDFbdfwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B76C4CED3;
	Tue, 17 Dec 2024 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734461271;
	bh=MOETiRKn/oNh+Y9hi24ChBgFQNEHt+lRnaf3hA/jPd4=;
	h=Date:To:From:Subject:From;
	b=FDFbdfwHhjc3QLfRkYTQqdBF6we9v628zVsuE4rlj8CRg9Hmfg89d9ZRs1bTVaSsg
	 pk2Tm21zZPGJ4KC9RbJHTmeIbbqiPboV7JHSSd27rGgwOEiBaVKVYegFzWAAUBuXIw
	 1CE5qLxlGslnY2UFLU5MfvmBeFNwb8PSQIN//Cew=
Date: Tue, 17 Dec 2024 10:47:48 -0800
To: mm-commits@vger.kernel.org,yangerkun@huawei.com,chuck.lever@oracle.com,brauner@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic.patch added to mm-unstable branch
Message-Id: <20241217184751.48B76C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_maple_tree: test exhausted upper limit of mtree_alloc_cyclic()
has been added to the -mm mm-unstable branch.  Its filename is
     test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: test_maple_tree: test exhausted upper limit of mtree_alloc_cyclic()
Date: Mon, 16 Dec 2024 14:01:13 -0500

When the upper bound of the search is exhausted, the maple state may be
returned in an error state of -EBUSY.  This means maple state needs to be
reset before the second search in mas_alloc_cylic() to ensure the search
happens.  This test ensures the issue is not recreated.

Link: https://lkml.kernel.org/r/20241216190113.1226145-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com> says:
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/lib/test_maple_tree.c~test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic
+++ a/lib/test_maple_tree.c
@@ -3738,6 +3738,34 @@ static noinline void __init alloc_cyclic
 	}
 
 	mtree_destroy(mt);
+
+	/*
+	 * Issue with reverse search was discovered
+	 * https://lore.kernel.org/all/20241216060600.287B4C4CED0@smtp.kernel.org/
+	 * Exhausting the allocation area and forcing the search to wrap needs a
+	 * mas_reset() in mas_alloc_cyclic().
+	 */
+	next = 0;
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (int i = 0; i < 1023; i++) {
+		mtree_alloc_cyclic(mt, &location, mt, 2, 1024, &next, GFP_KERNEL);
+		MT_BUG_ON(mt, i != location - 2);
+		MT_BUG_ON(mt, i != next - 3);
+		MT_BUG_ON(mt, mtree_load(mt, location) != mt);
+	}
+	mtree_erase(mt, 123);
+	MT_BUG_ON(mt, mtree_load(mt, 123) != NULL);
+	mtree_alloc_cyclic(mt, &location, mt, 2, 1024, &next, GFP_KERNEL);
+	MT_BUG_ON(mt, 123 != location);
+	MT_BUG_ON(mt, 124 != next);
+	MT_BUG_ON(mt, mtree_load(mt, location) != mt);
+	mtree_erase(mt, 100);
+	mtree_alloc_cyclic(mt, &location, mt, 2, 1024, &next, GFP_KERNEL);
+	MT_BUG_ON(mt, 100 != location);
+	MT_BUG_ON(mt, 101 != next);
+	MT_BUG_ON(mt, mtree_load(mt, location) != mt);
+	mtree_destroy(mt);
+
 	/* Overflow test */
 	next = ULONG_MAX - 1;
 	ret = mtree_alloc_cyclic(mt, &location, mt, 2, ULONG_MAX, &next, GFP_KERNEL);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-fix-mas_alloc_cyclic-second-search.patch
test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic.patch

