Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7030823A115
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836967; cv=none; b=mHe/zX7VNRbyc8I13c0TH0iIx43wTRh9uXsUBVw0tuI9vEJUVH07pkutgi8ofaSRdMOM4YNYbjVQuncN3lwXK2ozbK2skDWFZsorht4PiATcXNZSLMajhpyGJD6S5bPQDWh7mrXgYFE2tBSjRzPBp3dh9hZodOYZtUILoVmNmFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836967; c=relaxed/simple;
	bh=ZL9ZN+5RAx1O9UyZx4muu9M1teTkBxLYl3tazvN7JOY=;
	h=Date:To:From:Subject:Message-Id; b=PCjaXlo4ETZNRW7sDyfIMQjwzn7g6zg5FDMGwFDQUcs1JImIfkWL3ctOMihp77/FTC2YP19YaUJ9BgAGaoMzh+2aSkzv0ABlB/YEl7OauvdANSvB4f986hpB+qPwjGw9yddunXcJyo/G/h8/yJAd972QXImGx7ay0bcrUoAqrjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=meOZE9dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="meOZE9dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B6EC4CEDD;
	Tue, 14 Jan 2025 06:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836967;
	bh=ZL9ZN+5RAx1O9UyZx4muu9M1teTkBxLYl3tazvN7JOY=;
	h=Date:To:From:Subject:From;
	b=meOZE9dkLOgH1otygMQHYSIe76NUQDnmhSgJaoRuod1n26bDFM294ygUkI6VJIw6y
	 BrqyqhPheBAvopOtlkxS2egOH4BK4A2QxqbFlTXZw9rWPJDOy7bi7wKp2RfhOXAz/0
	 lxS8UMHqSVKhTscHay9eRqxB5PSYGnpzeZspmkQo=
Date: Mon, 13 Jan 2025 22:42:46 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-only-root-node-could-be-deficient.patch removed from -mm tree
Message-Id: <20250114064247.42B6EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: only root node could be deficient
has been removed from the -mm tree.  Its filename was
     maple_tree-only-root-node-could-be-deficient.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: only root node could be deficient
Date: Wed, 13 Nov 2024 03:16:16 +0000

Each level's rightmost node should have (max == ULONG_MAX).  This means
current validation skips the right most node on each level.

Only the root node may be below the minimum data threshold.

Link: https://lkml.kernel.org/r/20241113031616.10530-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-only-root-node-could-be-deficient
+++ a/lib/maple_tree.c
@@ -7556,7 +7556,7 @@ void mt_validate(struct maple_tree *mt)
 		MAS_WARN_ON(&mas, mte_dead_node(mas.node));
 		end = mas_data_end(&mas);
 		if (MAS_WARN_ON(&mas, (end < mt_min_slot_count(mas.node)) &&
-				(mas.max != ULONG_MAX))) {
+				(!mte_is_root(mas.node)))) {
 			pr_err("Invalid size %u of " PTR_FMT "\n",
 			       end, mas_mn(&mas));
 		}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


