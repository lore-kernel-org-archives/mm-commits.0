Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537118;
	b=tocZJ3NRj3Pbb3bR+K7nFkrRZEN2XY7ZLnxX5/Fm/oc3X/a67KzStw4YdkITD7nsUxma
	 /4IK1fyEPczEaDjYNIw3+o08SYC0k4vZcnMK/ehHGnPbGIcDAxFscz5yap1gZo8lw46P8
	 HgNFM8CJfkmANIoEzOgq+bSCGvwMxg8Paqp99sls08Yi24hrgwHpX+TOj7opSBRI4oCqZ
	 o0Vc1sIMT+u2PZ9umSZiS9R5Zum0Bz36h99gSWqF6gLdrGWZ3YQRTQgeennZR22txIkWl
	 TKNUxvxn9Xm16dMX+4vWKIgQtYmw/20lcuF7/7m+hANY18M6ZK3yg3SDso2nNZj+HEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537118;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=FEhuUM7mHNHAS11xNQ44m+0BU6+qI7JwmoONMHAlb+k=;
	b=ACiTozItb6/1oX1sfHgb7GVGKQJmTfSgqtRcXOGd31NPkr/c92NJCZLmYUI5Lh5VoHt9
	 vDtBr7aNRA7D5r1SdEp50GbgeCVBvi60gfwvNkUD86+avteewiwZ5bKFE7d/FRNFQ6aCy
	 JDaEwr0Dri00PZatgeGlzdP4GSXE1cqdr7125dRv5FjNoY5gi2wqkrK/KAts4FMZGwGhP
	 Md6XtFZmbTfxkTgVIveCqerdX7FYoKewjQ/B0k5jre7qRn6z9NZNUsvkHb0b1bVGPV2Tx
	 gw8xGLgjeiPfLvguLFn2qkxy5Gj4nbX4gPsTzl2VBbvKf7fjEm/vgOeiCfkmIGNoNaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xIDho9no;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E8E606A326;
	Tue, 24 Nov 2026 16:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xIDho9no
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0565C1F000D2;
	Tue, 24 Nov 2026 16:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795537118;
	bh=FEhuUM7mHNHAS11xNQ44m+0BU6+qI7JwmoONMHAlb+k=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=xIDho9nowtpwlDWbc7KEX04Wft6pMM0kIkOeSRtgwz29WXJskjdBtPhrPWiy7/lSg
	 +E5t6ml25YNHeiJGPYNSpFQKI/Bfvd35fXiSwKMcV7qecWv7ZALZtbmGqqK4rIRP0d
	 t1E99TwREkmwQwFsEd5NWP2MOL/juDugnDLkprN0=
Date: Tue, 24 Nov 2026 08:18:37 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yu-cheng.yu@intel.com,
	ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,
	usama.arif@linux.dev,tj@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,
	rick.p.edgecombe@intel.com,pfalcato@suse.de,peng.fan@nxp.com,
	nphamcs@gmail.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,
	liam@infradead.org,kasong@tencent.com,kas@kernel.org,joshua.hahnjy@gmail.com,
	jglisse@redhat.com,jbacik@fb.com,jannh@google.com,jack@suse.cz,
	hannes@cmpxchg.org,gourry@gourry.net,dennisszhou@gmail.com,dennis@kernel.org,
	david@kernel.org,dave.hansen@linux.intel.com,cl@gentwo.org,
	chris@chrisdown.name,byungchul@sk.com,broonie@kernel.org,bp@alien8.de,
	balbirs@nvidia.com,apopple@nvidia.com,mason@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-2-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-2-50a2ed382b61@kernel.org>
Subject: + mm-cachestat-count-each-page-only-once.patch added to mm-unstable branch
Message-Id: <20261124161838.0565C1F000D2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: cachestat: count each page only once
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cachestat-count-each-page-only-once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cachestat-count-each-page-only-once.patch

This patch will later appear in the mm-unstable branch at
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
From: Chris Mason <mason@kernel.org>
Subject: mm: cachestat: count each page only once
Date: Fri, 13 Nov 2026 21:45:20 +0000

It turns out that filemap_cachestat() can unwittingly return incorrect
page counts, if large folios are present.

This can occur due to underflow - nr_cache is nearly 2^64 on a 64-bit
kernel if the input range starts more than 64 pages into a folio that is
split during the call.

It can also occur due to pages after a large folio being skipped if the
range starts in its second or later XArray slot and the call reschedules at
that folio.

Finally it can be caused by pages being counted twice due to folios in the
range being split or collapsed during the call.

filemap_cachestat() walks the page cache under the RCU read lock only,
and for each entry it counts the pages that lie in the range. It does
not track how far it has counted, so the counts are only right if the
walk returns each index once.

But a large folio can be split during the walk, or small folios can be
collapsed into a large one, and the next entries then cover indices that
were already counted.

Resolve the issue by tracking the current index as one past the last index
in the folio, and explicitly using xas_set() to set the current position in
the XArray.

Additionally, add a check for folio_last_index reaching or exceeding
last_index and break out of the loop if so.

[ljs@kernel.org: updated to use curr_index, fixed comments, updated commit message]
Link: https://patch.msgid.link/20261113-mason-migrate-et-al-fixes-v2-2-50a2ed382b61@kernel.org
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
  Link: https://lore.kernel.org/20261114115635.8346206195d50372@chrisdown.name
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Yu, Yu-cheng <yu-cheng.yu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Dennis Zhou (Facebook) <dennisszhou@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>

 mm/filemap.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-cachestat-count-each-page-only-once
+++ a/mm/filemap.c
@@ -4665,6 +4665,7 @@ static void filemap_cachestat(struct add
 {
 	XA_STATE(xas, &mapping->i_pages, first_index);
 	struct folio *folio;
+	pgoff_t curr_index = first_index;
 
 	/* Flush stats (and potentially sleep) outside the RCU read section. */
 	mem_cgroup_flush_stats_ratelimited(NULL);
@@ -4694,13 +4695,19 @@ static void filemap_cachestat(struct add
 		folio_first_index = round_down(xas.xa_index, 1 << order);
 		folio_last_index = folio_first_index + nr_pages - 1;
 
+		/* Skip already counted entries, e.g. after a split/collapse. */
+		if (folio_last_index < curr_index)
+			goto resched;
+
 		/* Folios might straddle the range boundaries, only count covered pages */
-		if (folio_first_index < first_index)
-			nr_pages -= first_index - folio_first_index;
+		if (folio_first_index < curr_index)
+			nr_pages -= curr_index - folio_first_index;
 
 		if (folio_last_index > last_index)
 			nr_pages -= folio_last_index - last_index;
 
+		curr_index = folio_last_index + 1;
+
 		if (xa_is_value(folio)) {
 			/* page is evicted */
 			void *shadow = (void *)folio;
@@ -4748,8 +4755,11 @@ static void filemap_cachestat(struct add
 			cs->nr_writeback += nr_pages;
 
 resched:
+		if (folio_last_index >= last_index)
+			break;
+
 		if (need_resched()) {
-			xas_pause(&xas);
+			xas_set(&xas, curr_index);
 			cond_resched_rcu();
 		}
 	}
_

Patches currently in -mm which might be from mason@kernel.org are

mm-swap-fix-large-swap-in-across-swap-file-extents.patch
hugetlbfs-do-not-grow-a-sealed-file-in-mmap.patch
mm-hugetlb-keep-surplus-folios-that-are-reserved.patch
mm-hugetlb-fix-reservation-leak-on-min_size=-mounts.patch
mm-cachestat-count-each-page-only-once.patch
mm-cachestat-restart-the-walk-after-each-entry.patch
percpu-queue-the-balance-work-on-an-unbound-workqueue.patch

