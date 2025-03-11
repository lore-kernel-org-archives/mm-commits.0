Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE13A19007D;
	Tue, 11 Mar 2025 03:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741663618; cv=none; b=IVfYPCyHCHMYvMnjjDoNCaUirFGhxbt9GKIsmW9KYXIiExe6NowbhbRKjUjpTw9AhhaEpWf0olYWXTq3DE8N3IkG/pTEsupi4W108S6xlqyOk0QAr0TPxpcAgzEbGZ8AZYB97pXo63E2JyxgnoavShqIAjUpHAs6RdoctnVlW3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741663618; c=relaxed/simple;
	bh=4Mvj4ALeZCvtL9k4MmaTxHXLk2a8ZTMsnSvKtWNuvkY=;
	h=Date:To:From:Subject:Message-Id; b=XheIQxfBsDOxLoJ3gJgfzL35NJ/FQ3WmiyLQat91aFJW4MONG4kVuC9AFgml3kJqdQ4dCLZigrqjBDYOq83ODTo8RtS527snChzTk3k3kigEFtEfG2Y10a23D2RlDNNEvWbB0BEMWLsEEPy8S5IKWU9uR9ZMqXk2UdrHia2jItg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KyNP2GCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KyNP2GCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32815C4CEE9;
	Tue, 11 Mar 2025 03:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741663618;
	bh=4Mvj4ALeZCvtL9k4MmaTxHXLk2a8ZTMsnSvKtWNuvkY=;
	h=Date:To:From:Subject:From;
	b=KyNP2GCnMGswG684F0xT39qqyUGS5rolMTBIeMgz3eimOGE28qpAvI5cBWqXMvDm/
	 ZXnppvnZVxHkUpat/o48qxoDR9eK6frOuBttndUUyyJEd/y9o1nwtUp1FnKTf4YNgY
	 DksI1L4x5/fvd8Il4n0+Bn5jTi21i/rhwKvlu0VM=
Date: Mon, 10 Mar 2025 20:26:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-drain-obj-stock-on-cpu-hotplug-teardown.patch added to mm-hotfixes-unstable branch
Message-Id: <20250311032658.32815C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: drain obj stock on cpu hotplug teardown
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-drain-obj-stock-on-cpu-hotplug-teardown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-drain-obj-stock-on-cpu-hotplug-teardown.patch

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
Subject: memcg: drain obj stock on cpu hotplug teardown
Date: Mon, 10 Mar 2025 16:09:34 -0700

Currently on cpu hotplug teardown, only memcg stock is drained but we
need to drain the obj stock as well otherwise we will miss the stats
accumulated on the target cpu as well as the nr_bytes cached. The stats
include MEMCG_KMEM, NR_SLAB_RECLAIMABLE_B & NR_SLAB_UNRECLAIMABLE_B. In
addition we are leaking reference to struct obj_cgroup object.

Link: https://lkml.kernel.org/r/20250310230934.2913113-1-shakeel.butt@linux.dev
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc:
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memcontrol.c~memcg-drain-obj-stock-on-cpu-hotplug-teardown
+++ a/mm/memcontrol.c
@@ -1921,9 +1921,18 @@ void drain_all_stock(struct mem_cgroup *
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
 	struct memcg_stock_pcp *stock;
+	struct obj_cgroup *old;
+	unsigned long flags;
 
 	stock = &per_cpu(memcg_stock, cpu);
+
+	/* drain_obj_stock requires stock_lock */
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
+	old = drain_obj_stock(stock);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+
 	drain_stock(stock);
+	obj_cgroup_put(old);
 
 	return 0;
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-drain-obj-stock-on-cpu-hotplug-teardown.patch
memcg-add-hierarchical-effective-limits-for-v2.patch
memcg-dont-call-propagate_protected_usage-for-v1.patch
page_counter-track-failcnt-only-for-legacy-cgroups.patch
page_counter-reduce-struct-page_counter-size.patch
memcg-bypass-root-memcg-check-for-skmem-charging.patch

