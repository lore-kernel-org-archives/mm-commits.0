Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C881C695
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498474; cv=none; b=BBUVeuGIRn/Cf/Zq74XbBxld4Uy1o0/MQrFyO/E96Wr3JKzx9PpEcEV1jqF7XbPAu9yVJq4s/V72otAofYwjETgzgFNmo9FiRy44soaBkVoa8yU8alG13v8GJ2JJQ68yrGGR5/9rHJ5gOAOv+M3TVSnMAk6L7qCyOVw1Flwxnws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498474; c=relaxed/simple;
	bh=hwvrfIbe9eNq2mCXZxssGUw52nW092e1uJbJIdU+ALU=;
	h=Date:To:From:Subject:Message-Id; b=NpR0nmBNYGKM/Q/fhQVuOOMEWwAshAC9eNrE8gXhcErLymvp1HNVjPMQ5wzqiE/mWCXQvGjSgSBkkyYWaP7fuBuowiEZI0iUBKjuoHKdIXofngHUnWKczVOIrKLkcSgioGsIefu+0lmvg/vDyRuJ6GWR8BAuqq/1GXKujmOWZ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WRxxYn7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRxxYn7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39EEC19424;
	Sat, 18 Apr 2026 07:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498474;
	bh=hwvrfIbe9eNq2mCXZxssGUw52nW092e1uJbJIdU+ALU=;
	h=Date:To:From:Subject:From;
	b=WRxxYn7iMFb/DAXKiA4OM58ySbQsLOU3nWD2zNuYkmKACJcejH04LVVhhBtaWkNDa
	 79npcSmIliTe6f4TOart/zaC9l1PzR3km3JDhxas2O1lIOVfwVa7NXOz7/GTlaxjDk
	 DjwUZPthV466d5Zn3oWjkHMmDPyJUMQo7xARYjzs=
Date: Sat, 18 Apr 2026 00:47:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-prepare-for-the-refactoring-the-move_folios_to_lru.patch removed from -mm tree
Message-Id: <20260418074753.C39EEC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: prepare for the refactoring the move_folios_to_lru()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-prepare-for-the-refactoring-the-move_folios_to_lru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: vmscan: prepare for the refactoring the move_folios_to_lru()
Date: Thu, 5 Mar 2026 19:52:22 +0800

Once we refactor move_folios_to_lru(), its callers will no longer have to
hold the lruvec lock; For shrink_inactive_list(), shrink_active_list() and
evict_folios(), IRQ disabling is only needed for __count_vm_events() and
__mod_node_page_state().

To avoid using local_irq_disable() on the PREEMPT_RT kernel, let's make
all callers of move_folios_to_lru() use IRQ-safed count_vm_events() and
mod_node_page_state().

Link: https://lore.kernel.org/b3a202f1787b0857bb6cbe059fffb8edefaf67b7.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-prepare-for-the-refactoring-the-move_folios_to_lru
+++ a/mm/vmscan.c
@@ -2021,7 +2021,7 @@ static unsigned long shrink_inactive_lis
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
@@ -2167,10 +2167,10 @@ static void shrink_active_list(unsigned
 	nr_activate = move_folios_to_lru(lruvec, &l_active);
 	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
 
-	__count_vm_events(PGDEACTIVATE, nr_deactivate);
+	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


