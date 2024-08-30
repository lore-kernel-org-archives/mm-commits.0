Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECDC165F0B
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725058258; cv=none; b=ux3sNzopEHP8O2qlseYLLlXk+IVeQIAZv1SPSEt5bDKZruSD4/UbL0tGA8KLcHrKLqyQOkEKQPsyWS81I/RGCBaAmjq2bn1rBn9Dw6na4wchLaxiqpl08isRNyI/2SyQJVBdaRr5BIvOI+i+j0y6KVvJ58oGwD9rKEWySrvmW7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725058258; c=relaxed/simple;
	bh=1XvpaRZk9IxjR8K+I9KVfkzeujQi+zeAcrfeYuBwCDs=;
	h=Date:To:From:Subject:Message-Id; b=TJvVAdlWJD//l736JGqlM05XL57VzoedMrfHo8nqPP2Udvu2nKkG7FN8B/XFJ+4j4HIUiPrMDeO1YBH3Cm8RjuTh5p2B5jYH9xs51Tscjnav6L/a6CU5y83b9iOq6LbBKGzmNbsXtsFvVVpW01WNHRRSuyoqlZ7hIgAb+gUzzk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vMQyEXwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vMQyEXwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6267EC4CEC2;
	Fri, 30 Aug 2024 22:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725058257;
	bh=1XvpaRZk9IxjR8K+I9KVfkzeujQi+zeAcrfeYuBwCDs=;
	h=Date:To:From:Subject:From;
	b=vMQyEXwaQkr1y1Und+BYzsvrjwzUiOgwKCkJI6ZIjrfvXtNSeNXI/+60gYN/je+QY
	 rFI3OVI2WxNkgjFkulHG75R1G6DLGc8TCrzEWu6ZBtta7Yp//587U7o6eFMz/3CF7h
	 HsjJRbuy8m6Ia5nXT5+No3rGR3OlLqwVub9M0Lhw=
Date: Fri, 30 Aug 2024 15:50:56 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,linuszeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter.patch added to mm-unstable branch
Message-Id: <20240830225057.6267EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: add per-memcg pgpgin/pswpin counter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter.patch

This patch will later appear in the mm-unstable branch at
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
From: Jingxiang Zeng <linuszeng@tencent.com>
Subject: mm/memcontrol: add per-memcg pgpgin/pswpin counter
Date: Fri, 30 Aug 2024 16:22:44 +0800

In proactive memory reclamation scenarios, it is necessary to estimate the
pswpin and pswpout metrics of the cgroup to determine whether to continue
reclaiming anonymous pages in the current batch.  This patch will collect
these metrics and expose them.

Link: https://lkml.kernel.org/r/20240830082244.156923-1-jingxiangzeng.cas@gmail.com
Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    2 ++
 mm/memcontrol.c    |    2 ++
 mm/page_io.c       |    4 ++++
 3 files changed, 8 insertions(+)

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
--- a/mm/memcontrol-v1.c~mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter
+++ a/mm/memcontrol-v1.c
@@ -2729,6 +2729,8 @@ static const char *const memcg1_stat_nam
 static const unsigned int memcg1_events[] = {
 	PGPGIN,
 	PGPGOUT,
+	PSWPIN,
+	PSWPOUT,
 	PGFAULT,
 	PGMAJFAULT,
 };
--- a/mm/page_io.c~mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter
+++ a/mm/page_io.c
@@ -310,6 +310,7 @@ static inline void count_swpout_vm_event
 	}
 	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
 #endif
+	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
 
@@ -505,6 +506,7 @@ static void sio_read_complete(struct kio
 		for (p = 0; p < sio->pages; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
 
+			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
 		}
@@ -588,6 +590,7 @@ static void swap_read_folio_bdev_sync(st
 	 * attempt to access it in the page fault retry time check.
 	 */
 	get_task_struct(current);
+	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 	count_vm_event(PSWPIN);
 	submit_bio_wait(&bio);
 	__end_swap_bio_read(&bio);
@@ -603,6 +606,7 @@ static void swap_read_folio_bdev_async(s
 	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_read;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
+	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 	count_vm_event(PSWPIN);
 	submit_bio(bio);
 }
_

Patches currently in -mm which might be from linuszeng@tencent.com are

mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter.patch

