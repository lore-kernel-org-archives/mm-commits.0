Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465373;
	b=DWMi/VM+4ngVn28EfjVMxhC+qQNj3xzIOC/6YLOADBtAHnsNpXUMT7Ey605SZr+D2yc5
	 AsGPBnDUnWbGrCF1SSQ0dHP+9RMTKCAAltrjFONQ4WqCPxlYPAGS+vdM2jcAnecfTdmbV
	 YZNVDzvOBxJGKOIQti/C/J6DiLSDM4ObvsEvSqqaL2JUK15O7Tjli6jSsBAeJO1K+OFLT
	 eR2yzviBm3dinMvS/tBf1B114c4rC8mIT+Ut6O8VgPt7NkBS06eue6L/ds12GgpZ4L9rl
	 KWk5uOPnZfX4fJVgWnmxuU+VMbznys7p9uqN/7uu3QpJyhLNxN2ZbMTEjDCS3FcTCzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465373;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=GqRW3E9W7olJT5kvUHZdedv2muJR410HaQFRbhzUIUM=;
	b=cjlzm+h2oscum21FJ344AQKsuXbdpXNws8LTXsKn/2f0/NVGuPAZnkYCZ+5UClVFAxr9
	 LELqSh/XgNr/fwGUknoTBZJSzns+A/48+BTBk5SSLmHRApoF7Lnr+LRoTblKK0dXiMeXq
	 ne2+JIdDiJov5MXVmCarF0kYXrNp8JD3V8SL2soFiwmotch9RSGPqY7KDtMPgc3VKzJNH
	 ARJZrdPJtc6xS3wa2pzR84Q/PQi06WMJ+z6xztty8sAO3eyTDqIf7B7e1uLElwJH6mGEn
	 6WjEzsayi+LWdqSAYOJP9irKX2qcmYsqisjwk5Ol5JGuie/ehVoStzE3WwtQ4c6ATRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LspD0fEZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08712606A321
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 20:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LspD0fEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6BE1F000D0;
	Mon, 23 Nov 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795465372;
	bh=GqRW3E9W7olJT5kvUHZdedv2muJR410HaQFRbhzUIUM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=LspD0fEZWlokqcRsDHL7oHPbTRluSqzHTMNlntftuXGWxQyiQrlv2tl+8c9NiQnis
	 bgeUuKvzOFd+t5Dc0j5mitO/WvUtghkbEzfyGEkS6LPIx1foBNB3uO8bA+5Xbnz8DB
	 JgPlSbmbZxn5G1UI2SwxMr3zV4rNJtozH5EeqrYo=
Date: Mon, 23 Nov 2026 12:22:51 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
Subject: + mm-memcontrol-allow-update-of-lru-statistic-without-holding-lru-lock.patch added to mm-new branch
Message-Id: <20261123202252.1D6BE1F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memcontrol: allow update of LRU statistic without holding LRU lock
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-allow-update-of-lru-statistic-without-holding-lru-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-allow-update-of-lru-statistic-without-holding-lru-lock.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/memcontrol: allow update of LRU statistic without holding LRU lock
Date: Tue, 24 Nov 2026 02:52:54 +0800

To enable moving file pages in folio_mark_accessed directly and lazily
for MGLRU, allow updating the LRU statistic atomically without holding a
lock. It may cause temporary counter underflow, which should be fine as
the counter is eventually consistent and only serves as an estimate.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Xiang Liu <liuxiang.277@bytedance.com>
Cc: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: Tianyi Chen <hi@tychen.cc>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Harry Yoo <harry@kernel.org>

 include/linux/mm_inline.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/mm_inline.h~mm-memcontrol-allow-update-of-lru-statistic-without-holding-lru-lock
+++ a/include/linux/mm_inline.h
@@ -47,12 +47,11 @@ static __always_inline void __update_lru
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
 	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
-	__mod_zone_page_state(&pgdat->node_zones[zid],
-				NR_ZONE_LRU_BASE + lru, nr_pages);
+	mod_zone_page_state(&pgdat->node_zones[zid],
+			    NR_ZONE_LRU_BASE + lru, nr_pages);
 }
 
 static __always_inline void update_lru_size(struct lruvec *lruvec,
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch
mm-memcontrol-allow-update-of-lru-statistic-without-holding-lru-lock.patch
mm-memcontrol-avoid-potential-counter-leak-when-reparenting-local-stats.patch
mm-mglru-make-generation-page-counters-atomic.patch
mm-memcg-add-folio-based-lruvec-live-helper.patch
mm-mglru-frequency-guided-workingset-promotion-mglru-fg.patch
mm-mglru-make-folio-lru-referenced-times-count-a-generic-api.patch
mm-mglru-move-add-del-lru-size-accounting-out-of-lru_gen_update_size.patch
mm-mglru-gup-mark-folios-referenced-via-a-fast-helper.patch
mm-mglru-smaps-convert-to-lru-refs-based-operations-for-mglru.patch
mm-damon-convert-to-lru-refs-based-operations-for-mglru.patch
mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru.patch
mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch
mm-huge_memory-mark-folio-as-accessed-more-accurately-on-split.patch
mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch
mm-mglru-folio-lru-refs-based-active-inactive-number-accounting.patch
mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

