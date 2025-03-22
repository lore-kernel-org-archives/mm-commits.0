Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F151547F5
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619854; cv=none; b=G5h+CgKmDbgrZfwklEmhKUlQ2D49nF1Ocyy8bWjyhgNgXXpjw+a+Py0F8g5s2YS92PpZgyW/P6zC69YcLQh2THSs+tk7vEcSGPJd6ssvC6pLCrrXxxDCnC76dkkUCgLHZ34IEc+E0JxnUKcHpB8AXERNiICr3Odqp8w8k/WKHyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619854; c=relaxed/simple;
	bh=2qhMRQIBvJlSRg71vO8FUPwOMDEoRu48Nt6GzMcicw8=;
	h=Date:To:From:Subject:Message-Id; b=An1Ouq37RQSrWtbqCKoKyTCLidmmd9vFkNpWr2nU6bXaiy/hVn17LgYoK2iX28Utc/fqCRqpDzQ/Nl5llgfTii/gAKOl+j8npdTkpvvxisveDK/vZ2iV78OlKkgfks6lVHQWCGiTbpnTsLg2x1bcNYHyuNSNS1CiCn7wPL5Mv+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KeBrZRUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KeBrZRUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18516C4CEDD;
	Sat, 22 Mar 2025 05:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619854;
	bh=2qhMRQIBvJlSRg71vO8FUPwOMDEoRu48Nt6GzMcicw8=;
	h=Date:To:From:Subject:From;
	b=KeBrZRUY3fB1vk3hRQ18AoxKeRLgGaKWoxQC+I12hUApK1nUiERHlTzlHPSs6xo18
	 2EN3r22/KvEqaKbjj7SFnFgQPYaQY7sd1lON9htakiW+lCBd5oXBLD1yJRlXhmJgYC
	 pDDkc7fN+iff04t1YNXQG35ZTu5N5ME4INQq5N4M=
Date: Fri, 21 Mar 2025 22:04:13 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,corbet@lwn.net,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-docs-add-pswpin-and-pswpout-items-in-cgroup-v2-doc.patch removed from -mm tree
Message-Id: <20250322050414.18516C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cgroup: docs: add pswpin and pswpout items in cgroup v2 doc
has been removed from the -mm tree.  Its filename was
     cgroup-docs-add-pswpin-and-pswpout-items-in-cgroup-v2-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Jia <jiahao1@lixiang.com>
Subject: cgroup: docs: add pswpin and pswpout items in cgroup v2 doc
Date: Tue, 18 Mar 2025 15:58:33 +0800

The commit 15ff4d409e1a ("mm/memcontrol: add per-memcg pgpgin/pswpin
counter") introduced the pswpin and pswpout items in the memory.stat of
cgroup v2.  Therefore, update them accordingly in the cgroup-v2
documentation.

Link: https://lkml.kernel.org/r/20250318075833.90615-3-jiahao.kernel@gmail.com
Fixes: 15ff4d409e1a ("mm/memcontrol: add per-memcg pgpgin/pswpin counter") 
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~cgroup-docs-add-pswpin-and-pswpout-items-in-cgroup-v2-doc
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1561,6 +1561,12 @@ The following nested keys are defined.
 	  workingset_nodereclaim
 		Number of times a shadow node has been reclaimed
 
+	  pswpin (npn)
+		Number of pages swapped into memory
+
+	  pswpout (npn)
+		Number of pages swapped out of memory
+
 	  pgscan (npn)
 		Amount of scanned pages (in an inactive LRU list)
 
_

Patches currently in -mm which might be from jiahao1@lixiang.com are


