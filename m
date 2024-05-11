Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EB03399F
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467339; cv=none; b=Ag7PiDvBB+uGOYPN8ISsxP5PIOTqqXIpbV+hv4F2Cl5u0g7UkJU6jXgaXl5Zd/cThp65BN+HphCzgN96NHY0LMSWIZGPDlA43oAO0pFyzWJZ1obNSIk2ceTy6+3Af+Kh5tREhBzKqsFPkZrZKxA8LwrsfKhb50R62Fs2cdMVkng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467339; c=relaxed/simple;
	bh=b7E9cXKYznC1tJsJs+xZS3XDg+xkD0/jblJabhpUUp0=;
	h=Date:To:From:Subject:Message-Id; b=pAM/yHu4SB0pIw6j5XQuZ5vTKNVTJjbCXbJXRltEZEOwt9ZrzoMhWCJX9KGNn1Ipp8yifVvksXyS7GsVdtmLqxk+3T4GX8Z2nCokW/quRlFKc4k8JP77VpQNLcViB89KQZbORB0/PfbfjiOHsARCYc+6j2oI37iBq6iLZzQiApw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GilDHN1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GilDHN1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A088C32781;
	Sat, 11 May 2024 22:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467339;
	bh=b7E9cXKYznC1tJsJs+xZS3XDg+xkD0/jblJabhpUUp0=;
	h=Date:To:From:Subject:From;
	b=GilDHN1ZDBLkB1q9hIc0gh3QW1i7n3pELCox1Uf6AqQNr4RVSbPUDzBzo1v/kbpk4
	 bSBFpwf0eX/0WCTLq2HT89rRd0Kcx9sH4fcPCAl+ssK7g76n+ikzzWDAsmIBORyJbf
	 xxYjURPucXJRcxyTyfwRqmoBIHWDraNxN48ud4T8=
Date: Sat, 11 May 2024 15:42:18 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-do-not-update-memcg-stats-for-nr_file-shmem_pmdmapped.patch removed from -mm tree
Message-Id: <20240511224219.3A088C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: do not update memcg stats for NR_{FILE/SHMEM}_PMDMAPPED
has been removed from the -mm tree.  Its filename was
     mm-do-not-update-memcg-stats-for-nr_file-shmem_pmdmapped.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: do not update memcg stats for NR_{FILE/SHMEM}_PMDMAPPED
Date: Mon, 6 May 2024 19:29:24 +0000

Previously, all NR_VM_EVENT_ITEMS stats were maintained per-memcg,
although some of those fields are not exposed anywhere. Commit
14e0f6c957e39 ("memcg: reduce memory for the lruvec and memcg stats")
changed this such that we only maintain the stats we actually expose
per-memcg via a translation table.

Additionally, commit 514462bbe927b ("memcg: warn for unexpected events
and stats") added a warning if a per-memcg stat update is attempted for
a stat that is not in the translation table. The warning started firing
for the NR_{FILE/SHMEM}_PMDMAPPED stat updates in the rmap code. These
stats are not maintained per-memcg, and hence are not in the translation
table.

Do not use __lruvec_stat_mod_folio() when updating NR_FILE_PMDMAPPED and
NR_SHMEM_PMDMAPPED. Use __mod_node_page_state() instead, which updates
the global per-node stats only.

Link: https://lkml.kernel.org/r/20240506192924.271999-1-yosryahmed@google.com
Fixes: 514462bbe927 ("memcg: warn for unexpected events and stats")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reported-by: syzbot+9319a4268a640e26b72b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/0000000000001b9d500617c8b23c@google.com
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/rmap.c~mm-do-not-update-memcg-stats-for-nr_file-shmem_pmdmapped
+++ a/mm/rmap.c
@@ -1435,13 +1435,14 @@ static __always_inline void __folio_add_
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum rmap_level level)
 {
+	pg_data_t *pgdat = folio_pgdat(folio);
 	int nr, nr_pmdmapped = 0;
 
 	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
 
 	nr = __folio_add_rmap(folio, page, nr_pages, level, &nr_pmdmapped);
 	if (nr_pmdmapped)
-		__lruvec_stat_mod_folio(folio, folio_test_swapbacked(folio) ?
+		__mod_node_page_state(pgdat, folio_test_swapbacked(folio) ?
 			NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED, nr_pmdmapped);
 	if (nr)
 		__lruvec_stat_mod_folio(folio, NR_FILE_MAPPED, nr);
@@ -1493,6 +1494,7 @@ static __always_inline void __folio_remo
 		enum rmap_level level)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
+	pg_data_t *pgdat = folio_pgdat(folio);
 	int last, nr = 0, nr_pmdmapped = 0;
 	bool partially_mapped = false;
 	enum node_stat_item idx;
@@ -1540,13 +1542,14 @@ static __always_inline void __folio_remo
 	}
 
 	if (nr_pmdmapped) {
+		/* NR_{FILE/SHMEM}_PMDMAPPED are not maintained per-memcg */
 		if (folio_test_anon(folio))
-			idx = NR_ANON_THPS;
-		else if (folio_test_swapbacked(folio))
-			idx = NR_SHMEM_PMDMAPPED;
+			__lruvec_stat_mod_folio(folio, NR_ANON_THPS, -nr_pmdmapped);
 		else
-			idx = NR_FILE_PMDMAPPED;
-		__lruvec_stat_mod_folio(folio, idx, -nr_pmdmapped);
+			__mod_node_page_state(pgdat,
+					folio_test_swapbacked(folio) ?
+					NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED,
+					-nr_pmdmapped);
 	}
 	if (nr) {
 		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
_

Patches currently in -mm which might be from yosryahmed@google.com are


