Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE31012AAE0
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559047; cv=none; b=afAoTrlB/gvLuxEccSVU1c+9CyyeBRKg6XUy6SYOwx6adMC0v0XrhJHVWH818vSBSsNHEL3CvLCpMycn5Zy+BrhHh44CB1gfOrEDq6QkfxyhLKZF2/L+tw6ytujo9xoyXP5/6wmqALAMUKTPrQvwaQElsGznnAREkNeR/UwlHKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559047; c=relaxed/simple;
	bh=5X30SsxtyKt7AxhgH+IZNv5MtD3juItXDy0iddZd03c=;
	h=Date:To:From:Subject:Message-Id; b=bgJkjRMYsycXGH2akc1hCxLTSYzHNmsX7eNJjwdJoZaQYi/+Rnh5wwX/Nogh5lHHZnvSvTl0C3fnknvBoZyEEwyEyd5fHvs3l7aNgVmKpgL0dFAp4XC6b1vOuSDSvoGxLadtP41wYDT5gnA39YkVFKVnmAHMHbHTZVmeSb3sgRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h6vSHrDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h6vSHrDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C55C433C7;
	Wed, 21 Feb 2024 23:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708559046;
	bh=5X30SsxtyKt7AxhgH+IZNv5MtD3juItXDy0iddZd03c=;
	h=Date:To:From:Subject:From;
	b=h6vSHrDgrLlhZARu/rpk7knFQSSeXiOptUE22OAxAZuUi2bczYnoBQQBs/owD9oES
	 VNf9fCqnlH9cxQLG/aAmxp6Jn2JT5K2wEOmx9VqfWAEveFNxtat+oVZRtrq275Wzc8
	 gmInotXFmnoJHoEAVhqpUdiD0Kemi7BRZ0jskvlg=
Date: Wed, 21 Feb 2024 15:44:05 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,sthanneeru.opensrc@micron.com,ravis.opensrc@micron.com,rakie.kim@sk.com,mhocko@kernel.org,hyeongtak.ji@sk.com,honggyu.kim@sk.com,Hasan.Maruf@amd.com,hannes@cmpxchg.org,gregory.price@memverge.com,dan.j.williams@intel.com,corbet@lwn.net,gourry.memverge@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq-fix.patch removed from -mm tree
Message-Id: <20240221234406.49C55C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: weighted interleave checks wrong parameter
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq-fix.patch

This patch was dropped because it was folded into mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq.patch

------------------------------------------------------
From: Gregory Price <gourry.memverge@gmail.com>
Subject: mm/mempolicy: weighted interleave checks wrong parameter
Date: Tue, 6 Feb 2024 14:28:53 -0500

weighted interleave presently checks (!node) when it should check
(!il_weight).  This causes a wrong distribution of memory.

Link: https://lkml.kernel.org/r/20240206192853.3589-1-gregory.price@memverge.com
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hasan Al Maruf <Hasan.Maruf@amd.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq-fix
+++ a/mm/mempolicy.c
@@ -1881,7 +1881,7 @@ retry:
 	/* to prevent miscount use tsk->mems_allowed_seq to detect rebind */
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	node = current->il_prev;
-	if (!node || !node_isset(node, policy->nodes)) {
+	if (!current->il_weight || !node_isset(node, policy->nodes)) {
 		node = next_node_in(node, policy->nodes);
 		if (read_mems_allowed_retry(cpuset_mems_cookie))
 			goto retry;
_

Patches currently in -mm which might be from gourry.memverge@gmail.com are

mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use.patch
mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving.patch
mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq.patch

