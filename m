Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA95E13C918
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854700; cv=none; b=Fg641bWF13ytusZeo2XboNaM+Bg8wvU+2xiO77U7V1QYL5V1t4RW5hvMtuK/kdH5NhYU2dlfOoVJntaGDJvF2NI+hFBemlj6YdxTFKrQZmc5UhEIKP85b0B2PdXxEs5P4RR7WYXu5i/xbEVNVvNI9JqzFOyvzTRXE/9niHItTs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854700; c=relaxed/simple;
	bh=sZ7y9CmRvspgCA9kDpHdM2PGAZeWVcqg3r3onhSrLCk=;
	h=Date:To:From:Subject:Message-Id; b=NADzq2xvY+0QxI2t9mksWgwxxPT1vwx54wCBHQPKBCBgwzbzdfAROYnJGN7YGPDXSXFUH/fHHFnKQCYsN7p2ufcEJ3qcQmmU6NhIm7i0P6UCfuQt7rZPh11KNVJ74OLUNObKaHl6irQ3KGdSOhN+KK5G+GayLCR9of8pkZwqi/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J+6ppIHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J+6ppIHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61076C4CED1;
	Wed,  6 Nov 2024 00:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854700;
	bh=sZ7y9CmRvspgCA9kDpHdM2PGAZeWVcqg3r3onhSrLCk=;
	h=Date:To:From:Subject:From;
	b=J+6ppIHaJ9qZL2Bo72vRhE17/XNfRohiTlgRZoqK69tvskplIX07xE3EFwldZalr+
	 jecSaFaKUq3uCQFJwIAEzC4FYHfOueSpnG8IdQGFUF6PDBxAbej3fLk4ZBvYItB/1i
	 x5JeW6EQVhEWcJGkdS9sVLrwPSSSTTKFLvQlJUIg=
Date: Tue, 05 Nov 2024 16:58:19 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,linuszeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter.patch removed from -mm tree
Message-Id: <20241106005820.61076C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: add per-memcg pgpgin/pswpin counter
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jingxiang Zeng <linuszeng@tencent.com>
Subject: mm/memcontrol: add per-memcg pgpgin/pswpin counter
Date: Fri, 30 Aug 2024 16:22:44 +0800

In proactive memory reclamation scenarios, it is necessary to estimate the
pswpin and pswpout metrics of the cgroup to determine whether to continue
reclaiming anonymous pages in the current batch.  This patch will collect
these metrics and expose them.

[linuszeng@tencent.com: v2]
  Link: https://lkml.kernel.org/r/20240830082244.156923-1-jingxiangzeng.cas@gmail.com
Li  nk: https://lkml.kernel.org/r/20240913084453.3605621-1-jingxiangzeng.cas@gmail.com
Link: https://lkml.kernel.org/r/20240830082244.156923-1-jingxiangzeng.cas@gmail.com
Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 mm/page_io.c    |    4 ++++
 2 files changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter
+++ a/mm/memcontrol.c
@@ -418,6 +418,8 @@ static const unsigned int memcg_vm_event
 	PGPGIN,
 	PGPGOUT,
 #endif
+	PSWPIN,
+	PSWPOUT,
 	PGSCAN_KSWAPD,
 	PGSCAN_DIRECT,
 	PGSCAN_KHUGEPAGED,
--- a/mm/page_io.c~mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter
+++ a/mm/page_io.c
@@ -290,6 +290,7 @@ static inline void count_swpout_vm_event
 	}
 	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
 #endif
+	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
 
@@ -485,6 +486,7 @@ static void sio_read_complete(struct kio
 		for (p = 0; p < sio->pages; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
 
+			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
 		}
@@ -570,6 +572,7 @@ static void swap_read_folio_bdev_sync(st
 	 * attempt to access it in the page fault retry time check.
 	 */
 	get_task_struct(current);
+	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 	count_vm_events(PSWPIN, folio_nr_pages(folio));
 	submit_bio_wait(&bio);
 	__end_swap_bio_read(&bio);
@@ -585,6 +588,7 @@ static void swap_read_folio_bdev_async(s
 	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_read;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
+	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 	count_vm_events(PSWPIN, folio_nr_pages(folio));
 	submit_bio(bio);
 }
_

Patches currently in -mm which might be from linuszeng@tencent.com are

mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom.patch

