Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AC936AB7C;
	Sat, 18 Apr 2026 07:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498890; cv=none; b=JhCYZCSisQQ1PIP47dm7pQhv11Y2S3+Z7L6AYcZlE+w/XZfr6FDjEMPflf8F0ve07b2kgP565WQRmVqzVBnJKw10n0uTXK8VCGrRe2ZYOX0KG58h05LJqL+yBdwmnl6R1mk/XW375B1WJZ0WFjosOE0maUd9CHp7tmdaYvcl388=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498890; c=relaxed/simple;
	bh=M9uPB5ouAHYSmOrjES21+G/nBuwj6EjUwD0rylpMZBA=;
	h=Date:To:From:Subject:Message-Id; b=DphNI8Jm/ZcOii5VfZIc/nZQWRl9Mt0HxEn+Zs/j998IamNsKdgIs38IL+B+M9EydViFxtPTrNxkgJRkJ5AgyKdIpcjHuZH3xQhMqg5jTWRO+B92AQ8kRznhybxYVtCi65VXFIP4LbRF9LdzgnMw7WfGIH89mBpxMF1rRJGdivo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vdnmqRsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vdnmqRsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5946C19424;
	Sat, 18 Apr 2026 07:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498889;
	bh=M9uPB5ouAHYSmOrjES21+G/nBuwj6EjUwD0rylpMZBA=;
	h=Date:To:From:Subject:From;
	b=vdnmqRsM1uc2g6Z/QhVuRJqxF5xEW84T7PR9RcBUgsgfTg0fXZjWDCZrBfdgcI+oP
	 QK3fGYlmbUqkigoEQfpqDsG+Iht45w6r7MIV8XkxVJp2Qyb4hFFt5JmAfDqdWg9M+s
	 XB1TVCI1+16N0K+zZGUUwHDMv/nWY7oSq4VHa9mo=
Date: Sat, 18 Apr 2026 00:54:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch removed from -mm tree
Message-Id: <20260418075448.C5946C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
has been removed from the -mm tree.  Its filename was
     mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
Date: Sat, 28 Mar 2026 21:39:00 -0700

Users can set damos_quota_goal->nid with arbitrary value for
node_memcg_{used,free}_bp.  But DAMON core is using those for NODE-DATA()
without a validation of the value.  This can result in out of bounds
memory access.  The issue can actually triggered using DAMON user-space
tool (damo), like below.

    $ sudo mkdir /sys/fs/cgroup/foo
    $ sudo ./damo start --damos_action stat --damos_quota_interval 1s \
            --damos_quota_goal node_memcg_used_bp 50% -1 /foo
    $ sudo dmseg
    [...]
    [  524.181426] Unable to handle kernel paging request at virtual address 0000000000002c00

Fix this issue by adding the validation of the given node id.  If an
invalid node id is given, it returns 0% for used memory ratio, and 100%
for free memory ratio.

Link: https://lore.kernel.org/20260329043902.46163-3-sj@kernel.org
Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp
+++ a/mm/damon/core.c
@@ -2251,6 +2251,13 @@ static unsigned long damos_get_node_memc
 	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
+	if (invalid_mem_node(goal->nid)) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 0;
+		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+			return 10000;
+	}
+
 	memcg = mem_cgroup_get_from_id(goal->memcg_id);
 	if (!memcg) {
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-disallow-time-quota-setting-zero-esz.patch
mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch

