Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225061EB180
	for <mm-commits@vger.kernel.org>; Mon, 21 Apr 2025 18:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745261671; cv=none; b=gKga4BSfgIXEYyHZAVOIelG+pQvzlH/LmtWj4ugif2BmhiXIydJyb2oVIxbIHQ0TCHMkYOPbpRkGRv4mBinNfhqfdjTmjd8igo4dQuTGY3A9atqFPWA/06BJUgI/J0zMLcytVVekG+jFwU2WURvvYTzscJXVA4D2M3HaN4H4JH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745261671; c=relaxed/simple;
	bh=45jTyniKzWIdDlQvi96anlylPIS0vHeD1mVGHlOWPS4=;
	h=Date:To:From:Subject:Message-Id; b=hNhz4ONhGira0/0CNSxHYQ7c5sk507fEaoCAiZ2Dwls/8yB27NlbKlgTUgbe8V2XGdvSV8ST1wQfgZjkEZAVCyML3srrvEZytrHd9OADEbr0Tiws7cpm4IurQIRHESXWkYqXjihmwEYDNmIABMBQfNqkyn49XiaL6/vVlKFz40A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IGgKHhTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IGgKHhTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73A5C4CEE4;
	Mon, 21 Apr 2025 18:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745261670;
	bh=45jTyniKzWIdDlQvi96anlylPIS0vHeD1mVGHlOWPS4=;
	h=Date:To:From:Subject:From;
	b=IGgKHhTj4ALfRrizYMhY14GdtAJVz5wYBL1N8HTp05zm/a4RDqy04V6vDlnpgm0G8
	 4XEjgdL2ngIqBY/UQtZv8SOuS6FBg/63Crpd4DCnp3p3eGJQvSYkOBzRdeBblhO5nh
	 62kV2pZWM2waFn/9bHUIiWALwDTTrQvp3eZfmMJk=
Date: Mon, 21 Apr 2025 11:54:30 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch added to mm-new branch
Message-Id: <20250421185430.D73A5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add max swappiness arg to lru_gen for anonymous memory only
has been added to the -mm mm-new branch.  Its filename is
     mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: add max swappiness arg to lru_gen for anonymous memory only
Date: Mon, 21 Apr 2025 17:13:30 +0800

MGLRU already supports reclaiming only from anonymous memory via the
/sys/kernel/debug/lru_gen interface.  Now, memory.reclaim also supports
the swappiness=max parameter to enable reclaiming solely from anonymous
memory.  To unify the semantics of proactive reclaiming from anonymous
folios, the max parameter is introduced.

Link: https://lkml.kernel.org/r/65181f7745d657d664d833c26d8a94cae40538b9.1745225696.git.hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/multigen_lru.rst |    5 +++--
 mm/vmscan.c                                   |   15 ++++++++++++---
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/multigen_lru.rst~mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only
+++ a/Documentation/admin-guide/mm/multigen_lru.rst
@@ -151,8 +151,9 @@ generations less than or equal to ``min_
 ``min_gen_nr`` should be less than ``max_gen_nr-1``, since
 ``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged (equivalent to
 the active list) and therefore cannot be evicted. ``swappiness``
-overrides the default value in ``/proc/sys/vm/swappiness``.
-``nr_to_reclaim`` limits the number of pages to evict.
+overrides the default value in ``/proc/sys/vm/swappiness`` and the valid
+range is [0-200, max], with max being exclusively used for the reclamation
+of anonymous memory. ``nr_to_reclaim`` limits the number of pages to evict.
 
 A typical use case is that a job scheduler runs this command before it
 tries to land a new job on a server. If it fails to materialize enough
--- a/mm/vmscan.c~mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only
+++ a/mm/vmscan.c
@@ -5587,7 +5587,7 @@ static ssize_t lru_gen_seq_write(struct
 	while ((cur = strsep(&next, ",;\n"))) {
 		int n;
 		int end;
-		char cmd;
+		char cmd, swap_string[5];
 		unsigned int memcg_id;
 		unsigned int nid;
 		unsigned long seq;
@@ -5598,13 +5598,22 @@ static ssize_t lru_gen_seq_write(struct
 		if (!*cur)
 			continue;
 
-		n = sscanf(cur, "%c %u %u %lu %n %u %n %lu %n", &cmd, &memcg_id, &nid,
-			   &seq, &end, &swappiness, &end, &opt, &end);
+		n = sscanf(cur, "%c %u %u %lu %n %4s %n %lu %n", &cmd, &memcg_id, &nid,
+			   &seq, &end, swap_string, &end, &opt, &end);
 		if (n < 4 || cur[end]) {
 			err = -EINVAL;
 			break;
 		}
 
+		/* set by userspace for anonymous memory only */
+		if (!strncmp("max", swap_string, sizeof("max"))) {
+			swappiness = SWAPPINESS_ANON_ONLY;
+		} else {
+			err = kstrtouint(swap_string, 0, &swappiness);
+			if (err)
+				break;
+		}
+
 		err = run_cmd(cmd, memcg_id, nid, seq, &sc, swappiness, opt);
 		if (err)
 			break;
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim.patch
mm-vmscan-add-more-comments-about-cache_trim_mode.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch
mm-using-swappiness_anon_only-in-mglru.patch

