Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E07A184;
	Wed,  1 Apr 2026 03:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775014314; cv=none; b=NSMnu3hOxmbsG6BItBuhPK2Yay92ASHojs2baboMQOEig+RhGGshLvHrU9rNzXpb3p65QL8a6kRwMSqdLtcnxv4QIzwNu4WCQ3Gf11V7neoBx+GkwxOvCLn7zLO3RaI5dpfr9BGcZz50PkalgiIF603ate70bv3pCj7e8UGAzsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775014314; c=relaxed/simple;
	bh=iXPMsSfwGZbEoAKideL7NpFaaYki4wJeb5xsX32jbDY=;
	h=Date:To:From:Subject:Message-Id; b=j3vhpkcDp5qotE3SpinHFPpSjijXrxDO5Q0Y+TicvBNh6eowvAn4LnPjyIFABedXj8YK5yarWZzrWzIT0xKaCqlRGnygaJ/26+iHNf3uJVeAEsiuysnhqfdWEfPasYoY/Y8gQn3L+9lyXFU9cHBWyWU44xVuSW06xNhI5euopUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ryUzRlIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ryUzRlIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5857C4CEF7;
	Wed,  1 Apr 2026 03:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775014313;
	bh=iXPMsSfwGZbEoAKideL7NpFaaYki4wJeb5xsX32jbDY=;
	h=Date:To:From:Subject:From;
	b=ryUzRlIzPj6sBysQGYq4cYDvDDoWmhuvQ9NcFTW1hepzl2ysS9o2UuwmuRonZi840
	 I9DxKp+SejF6Lfc9zzPPewcsT22MJuLETUxuVPzue81J30VQ+l8sk6lULh0qDW1Dib
	 lDr2Z3h08u7MVglgKUtsfbgys+PPg5RFFahpCF04=
Date: Tue, 31 Mar 2026 20:31:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch added to mm-hotfixes-unstable branch
Message-Id: <20260401033153.D5857C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

Link: https://lkml.kernel.org/r/20260329043902.46163-3-sj@kernel.org
Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp
+++ a/mm/damon/core.c
@@ -2112,6 +2112,13 @@ static unsigned long damos_get_node_memc
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

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch
mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch
mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch

