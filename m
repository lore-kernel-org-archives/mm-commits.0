Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4953813FEE
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 00:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788220998; cv=none; b=jxYRXYITg0c3MQXDAxY4kLeoAhWWloi7iVRZtEbj3oQbu6DbsqJ9nxk2gRLVJUff/FEPcIlA6QjUdoRTy0AoeIjWQTfYA9Kk6G8/BSx0zD6rnQT1nVDpeipdjaHU9vVN3ojhZCy/43lepqcegK6pcLWdsbSjrebPJ3j4/Gq5dUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788220998; c=relaxed/simple;
	bh=8y55W0RRCT5Brs2fEbMv/w4Et/dSCVVY9PrOYYJhyTs=;
	h=Date:To:From:Subject:Message-Id; b=qHnrxbPB5UdhvCaA2LMhSSW+xdiGnWu9jc79Ge05sFN48u36O7ilnZaL7DGFw7/d/1QdkqLa90/mWj0JBgLRicNE8+3vZBWNi2EDboDn48rchLcCGmJPEvH8wZkGmPlxWqAz8KYNS/rolUU8zZEjKDrNML6HUfeXRgOmU0rJ0nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t2y44drL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t2y44drL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF52C1F000E9;
	Tue,  1 Sep 2026 00:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788220996;
	bh=JQQ9DfD82+hlm73yBm4P7alemvCQ4+NuzDTX/G9XrfA=;
	h=Date:To:From:Subject;
	b=t2y44drLyAkiglXVIoBitqg+B09zQWad7G7nOVnZAxcjtCVTmXCEf8eykHfhq12aq
	 0UBwvtLgQ3RL1KRKqWdmzhKxkYghTDReZpCF/vWM4BWEyJ+R0z3I1NxvDS6XOHD3ZP
	 AtOQn4GCCdHtYpz/i77rgYb9Mz1SVXexJHHkk2Eg=
Date: Mon, 31 Aug 2026 17:03:16 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,stevensd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch added to mm-new branch
Message-Id: <20260901000316.BF52C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: don't call schedule_work when no spinning is allowed
has been added to the -mm mm-new branch.  Its filename is
     memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: David Stevens <stevensd@google.com>
Subject: memcg: don't call schedule_work when no spinning is allowed
Date: Mon, 31 Aug 2026 16:43:39 -0700

Memcg charging can be done from any context, but calling schedule_work()
isn't safe from an NMI.  If memory.high is breached from a context where
spinning isn't allowed, use irq_work to schedule the reclaim work.

Link: https://lore.kernel.org/20260831234339.280376-1-stevensd@google.com
Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
Signed-off-by: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~memcg-dont-call-schedule_work-when-no-spinning-is-allowed
+++ a/include/linux/memcontrol.h
@@ -206,6 +206,7 @@ struct mem_cgroup {
 	spinlock_t	 peaks_lock;
 
 	/* Range enforcement for interrupt charges */
+	struct irq_work high_irq_work;
 	struct work_struct high_work;
 
 #ifdef CONFIG_ZSWAP
--- a/mm/memcontrol.c~memcg-dont-call-schedule_work-when-no-spinning-is-allowed
+++ a/mm/memcontrol.c
@@ -2424,6 +2424,11 @@ static void high_work_func(struct work_s
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
 }
 
+static void high_irq_work_func(struct irq_work *work)
+{
+	schedule_work(&container_of(work, struct mem_cgroup, high_irq_work)->high_work);
+}
+
 /*
  * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
  * enough to still cause a significant slowdown in most cases, while still
@@ -2832,7 +2837,10 @@ done_restock:
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
 			if (mem_high) {
-				schedule_work(&memcg->high_work);
+				if (allow_spinning)
+					schedule_work(&memcg->high_work);
+				else
+					irq_work_queue(&memcg->high_irq_work);
 				break;
 			}
 			continue;
@@ -4207,6 +4215,7 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 
 	INIT_WORK(&memcg->high_work, high_work_func);
+	init_irq_work(&memcg->high_irq_work, high_irq_work_func);
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->memory_peaks);
 	INIT_LIST_HEAD(&memcg->swap_peaks);
@@ -4415,6 +4424,7 @@ static void mem_cgroup_css_free(struct c
 		static_branch_dec(&memcg_bpf_enabled_key);
 
 	vmpressure_cleanup(&memcg->vmpressure);
+	irq_work_sync(&memcg->high_irq_work);
 	cancel_work_sync(&memcg->high_work);
 	free_shrinker_info(memcg);
 	mem_cgroup_free(memcg);
_

Patches currently in -mm which might be from stevensd@google.com are

memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch

