Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49243271450
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 23:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756423535; cv=none; b=m1bBqGKVayeKrBNGlqgxy40BDCEbWfda6irAsLPKthqfTq527zvbyF/R/803vypW/68GohTjwPpz9arMNMnnrO1wx6L49lxWhq2NjEv0Lrpok9GyA74SJfy0WNvba8uuQyWwi+aFpIiPJG6b/dy18YxJYos3VGKMzskyBP93Pek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756423535; c=relaxed/simple;
	bh=zUUhk1K48mh8I8OyzN/0GLqay+eaV2pcAUXWAP5T/FE=;
	h=Date:To:From:Subject:Message-Id; b=He9d0Ej0xPMvbzWeb7w7ZBFhXna8ssEuvWGXlmXCFRvlbUNBR45Z21PkVwJgmEQG9SxXsYN67Gpra6IRw2WvhPsB+TM1y2EBELSl7+6IrxB0/wh83n+1IytHkYf3aYUPAzeUkSzP5c8zG9c8o+X+0/mijswH0+e943uxjJHlMaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SwMDAwG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SwMDAwG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4244C4CEF7;
	Thu, 28 Aug 2025 23:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756423534;
	bh=zUUhk1K48mh8I8OyzN/0GLqay+eaV2pcAUXWAP5T/FE=;
	h=Date:To:From:Subject:From;
	b=SwMDAwG4XTfHJaP8aOSUtrl3IEYzik0+WqQhLH1/DXCzvYLijq1cLo89g/x+ue81m
	 uhvATazaQ2S5/SYiY2kALgFZTi2RwCqzcpmk1xokW3vXLbEZbG0NbhwMaUkIKq+DEj
	 VysSxGnHbnQSavlKpXXtXiTHaVEs+MONOLz5e+Po=
Date: Thu, 28 Aug 2025 16:25:34 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-testing-fix-for-spanning-store-on-32b.patch added to mm-new branch
Message-Id: <20250828232534.A4244C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: testing fix for spanning store on 32b
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-testing-fix-for-spanning-store-on-32b.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-testing-fix-for-spanning-store-on-32b.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: testing fix for spanning store on 32b
Date: Wed, 27 Aug 2025 20:30:23 -0400

32 bit nodes have a larger branching factor.  This affects the required
value to cause a height change.  Update the spanning store height test to
work for both 64 and 32 bit nodes.

Link: https://lkml.kernel.org/r/20250828003023.418966-3-Liam.Howlett@oracle.com
Fixes: f9d3a963fef4 ("maple_tree: use height and depth consistently")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/testing/radix-tree/maple.c~maple_tree-testing-fix-for-spanning-store-on-32b
+++ a/tools/testing/radix-tree/maple.c
@@ -36327,13 +36327,18 @@ extern void test_kmem_cache_bulk(void);
 static inline void check_spanning_store_height(struct maple_tree *mt)
 {
 	int index = 0;
+	int last = 140;
 	MA_STATE(mas, mt, 0, 0);
 	mas_lock(&mas);
 	while (mt_height(mt) != 3) {
 		mas_store_gfp(&mas, xa_mk_value(index), GFP_KERNEL);
 		mas_set(&mas, ++index);
 	}
-	mas_set_range(&mas, 90, 140);
+
+	if (MAPLE_32BIT)
+		last = 155; /* 32 bit higher branching factor. */
+
+	mas_set_range(&mas, 90, last);
 	mas_store_gfp(&mas, xa_mk_value(index), GFP_KERNEL);
 	MT_BUG_ON(mt, mas_mt_height(&mas) != 2);
 	mas_unlock(&mas);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-testing-fix-for-spanning-store-on-32b.patch

