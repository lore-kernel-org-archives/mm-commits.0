Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80763DDC7
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 19:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715025325; cv=none; b=g3lQpl40PENsJ62e3aT6ieSWpeozYZ9NE5tvmZU8+ax1QbKNA9hz9dlYcM9Ue6MqNORoQjs1ds0LlOIHtDF1U1vqu1SV4FDhMy2cxoxvbu1LYa+EwOavEcd3XB2upB+iqhE93p4RX4ckmv0OL+RLGxqBxk2vOZwt9Jgo2f7GUhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715025325; c=relaxed/simple;
	bh=pwrv2rG6zKtx54ly2gGuC4OGzpBecyMWJBOmqUs2dzA=;
	h=Date:To:From:Subject:Message-Id; b=sgRFZrEOjAEgEiII5eV1PLHBJsnMAtv9TjTV3ilwUxa/tTzO7Yl6+RyGbvkuvESkRwAgCe4DxQKO1Fofer16ckgh5lV2Iv759Ej6Vgu3ccqHtkO++LN0rCyz/hQJHF7H4vwrVTSgaBU8Xf0Afiqn5vBtL3JOSq3KRrBdAJ5SKKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a4khxqXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a4khxqXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AD0C4AF63;
	Mon,  6 May 2024 19:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715025324;
	bh=pwrv2rG6zKtx54ly2gGuC4OGzpBecyMWJBOmqUs2dzA=;
	h=Date:To:From:Subject:From;
	b=a4khxqXJeqM0VuqOvujoNUazSApMkKhm9iWQCJ/6J95WJBFzHRAOJzJ+E2K/Xxkk7
	 3ZXwlqV2n9DgJTYjPVHRgWN6Lga5etZcvhoXoXWNHRP2PtADLAO1aW1uMfLFGT8B3M
	 nDBhnlRaLZgwtOHhOfnj9Qp80pOgYJpc5Px+ONdw=
Date: Mon, 06 May 2024 12:55:23 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-update-memcg-stats-for-nr_file-shmem_pmdmapped.patch added to mm-unstable branch
Message-Id: <20240506195523.E6AD0C4AF63@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: do not update memcg stats for NR_{FILE/SHMEM}_PMDMAPPED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-do-not-update-memcg-stats-for-nr_file-shmem_pmdmapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-update-memcg-stats-for-nr_file-shmem_pmdmapped.patch

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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

mm-do-not-update-memcg-stats-for-nr_file-shmem_pmdmapped.patch

