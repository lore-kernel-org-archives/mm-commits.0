Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A77213B7BC
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722662733; cv=none; b=fbnFNSrTdeDbldWpWXts4JRU0DK30nk0jHsqteE+oYKljIYCL4BFlpJ7Ikcoj6aGUpmclHr+hPnIwk6S1heuyrICmq47MuBaTjIdMHDcqDUOY4WQibMeuh/ZEMEtLQmlGT5bWzUbolKoG2wEgZdDITfH1jtqtfC26rzmddEnHQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722662733; c=relaxed/simple;
	bh=PGwO0A+lCtVS5SL5kMqoXn5B+bmBA2Df78f/cf9IhAc=;
	h=Date:To:From:Subject:Message-Id; b=ejKkMSSeZyg9WEqMO7G/NzNiK/1swsZRej0zNC8unYzhHCVOIn3g49WLBs3na3yy6iCO1rhu3zK4R+XEt+KoYcxLXBPx9OH89anL43cXAJaz8n1HOm7OY03LhSze+ykFRnWPJnZjnJICr7EIx6v/6VMp2eGMkvmkFkLXxrKQvxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YBV7Ob3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YBV7Ob3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE03FC116B1;
	Sat,  3 Aug 2024 05:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722662732;
	bh=PGwO0A+lCtVS5SL5kMqoXn5B+bmBA2Df78f/cf9IhAc=;
	h=Date:To:From:Subject:From;
	b=YBV7Ob3zrTld6Rr7zfamELjjzrhRZw8bZT6pP371U4rrEfhFuLtsg/YSJer3riIxV
	 KIjKKq46kZ8CDAryrbtwl730IVAmj5L7QPycmD4CnypdBcxY60thQlGfvwlLro6jAG
	 dks4EkGyccWhUsPFbMxL0qfqf1he1uFHIEyxuV4g=
Date: Fri, 02 Aug 2024 22:25:31 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-protect-concurrent-access-to-mem_cgroup_idr.patch added to mm-hotfixes-unstable branch
Message-Id: <20240803052532.AE03FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: protect concurrent access to mem_cgroup_idr
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-protect-concurrent-access-to-mem_cgroup_idr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-protect-concurrent-access-to-mem_cgroup_idr.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: protect concurrent access to mem_cgroup_idr
Date: Fri, 2 Aug 2024 16:58:22 -0700

Commit 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after
many small jobs") decoupled the memcg IDs from the CSS ID space to fix the
cgroup creation failures.  It introduced IDR to maintain the memcg ID
space.  The IDR depends on external synchronization mechanisms for
modifications.  For the mem_cgroup_idr, the idr_alloc() and idr_replace()
happen within css callback and thus are protected through cgroup_mutex
from concurrent modifications.  However idr_remove() for mem_cgroup_idr
was not protected against concurrency and can be run concurrently for
different memcgs when they hit their refcnt to zero.  Fix that.

We have been seeing list_lru based kernel crashes at a low frequency in
our fleet for a long time.  These crashes were in different part of
list_lru code including list_lru_add(), list_lru_del() and reparenting
code.  Upon further inspection, it looked like for a given object (dentry
and inode), the super_block's list_lru didn't have list_lru_one for the
memcg of that object.  The initial suspicions were either the object is
not allocated through kmem_cache_alloc_lru() or somehow
memcg_list_lru_alloc() failed to allocate list_lru_one() for a memcg but
returned success.  No evidence were found for these cases.

Looking more deeply, we started seeing situations where valid memcg's id
is not present in mem_cgroup_idr and in some cases multiple valid memcgs
have same id and mem_cgroup_idr is pointing to one of them.  So, the most
reasonable explanation is that these situations can happen due to race
between multiple idr_remove() calls or race between
idr_alloc()/idr_replace() and idr_remove().  These races are causing
multiple memcgs to acquire the same ID and then offlining of one of them
would cleanup list_lrus on the system for all of them.  Later access from
other memcgs to the list_lru cause crashes due to missing list_lru_one.

Link: https://lkml.kernel.org/r/20240802235822.1830976-1-shakeel.butt@linux.dev
Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-protect-concurrent-access-to-mem_cgroup_idr
+++ a/mm/memcontrol.c
@@ -3386,11 +3386,28 @@ static void memcg_wb_domain_size_changed
 
 #define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
 static DEFINE_IDR(mem_cgroup_idr);
+static DEFINE_SPINLOCK(memcg_idr_lock);
+
+static int mem_cgroup_alloc_id(void)
+{
+	int ret;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(&memcg_idr_lock);
+	ret = idr_alloc(&mem_cgroup_idr, NULL, 1, MEM_CGROUP_ID_MAX + 1,
+			GFP_NOWAIT);
+	spin_unlock(&memcg_idr_lock);
+	idr_preload_end();
+	return ret;
+}
 
 static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
 {
 	if (memcg->id.id > 0) {
+		spin_lock(&memcg_idr_lock);
 		idr_remove(&mem_cgroup_idr, memcg->id.id);
+		spin_unlock(&memcg_idr_lock);
+
 		memcg->id.id = 0;
 	}
 }
@@ -3524,8 +3541,7 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg)
 		return ERR_PTR(error);
 
-	memcg->id.id = idr_alloc(&mem_cgroup_idr, NULL,
-				 1, MEM_CGROUP_ID_MAX + 1, GFP_KERNEL);
+	memcg->id.id = mem_cgroup_alloc_id();
 	if (memcg->id.id < 0) {
 		error = memcg->id.id;
 		goto fail;
@@ -3667,7 +3683,9 @@ static int mem_cgroup_css_online(struct
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
+	spin_lock(&memcg_idr_lock);
 	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
+	spin_unlock(&memcg_idr_lock);
 
 	return 0;
 offline_kmem:
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-protect-concurrent-access-to-mem_cgroup_idr.patch
memcg-increase-the-valid-index-range-for-memcg-stats.patch

