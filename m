Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640345;
	b=hVUfHhbnAgdsto/7POID+sYRhuthf0pMpR6NCGB/P7BjY+tpK9owFmeYFG3OqGMY2hHQ
	 v+82Y9CtFj7MgbpOl350druCJ85cwRKChPPWjmTkvoM7bf1UIxZJQlF6M74grkYtWW1k4
	 /eTeQXBpDSN8tN7ey2RS9laxscjVhMxi06QJuliDkc3ldJhV0rnWaASQXlE0/ceXJNNRf
	 4iYtO8ODG8OSj+bzkOcE1owCJgnk34aS/DKJNBgNC9+YlXFdTBR1wEt+8RIeGwSdFaHJi
	 gaT8OHJu7H5Hn4Jdb9ydZeT5oE3f072F++BcwAK19gZJt1Hebemtl78sU7vQlVZJ4JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640345;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7IDwUVs1CFTq6bF7VSijwKTlaTD6XaNkfkGwbRy2IW4=;
	b=Su4f1s5IZH/JYXSyAgn/Zfxs2+s2s0KW7AVRBU9Qs5f/plo4TX/l9bn7VO1xqzjoluHq
	 p5bMQcQQQ31idiSZSesnBlQxYn8smKEya6XNnaI3kehOMQ1uNdOvU3SB84g6wqnhK4gbK
	 i96JoTM31YGVHQkfzcMDDR9WiYFszUXGy8eRCjxbAM1iPjAAuqXsTa2I5xttc/PUcfn0o
	 wyCjCqVhp8RrBjAaiXYdCTsD0dEYYikiZEAHcf1TTKlePg3lW663KPrgYOy8AHC6rc6VQ
	 xV/nvCTCcNz80npDl0ZrAPz3+5sqEYZg1P0rMpCC5jllgG0H4E8/anZIOP2uFqRKg/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QcINnQAg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF256606A329
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QcINnQAg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DFE1F00A17;
	Mon,  2 Nov 2026 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640344;
	bh=7IDwUVs1CFTq6bF7VSijwKTlaTD6XaNkfkGwbRy2IW4=;
	h=Date:To:From:Subject;
	b=QcINnQAgNpUtzhZ1YsHDZZxqTffYbXjGTGjWfTvk4wNll6EUShM+YAtFGXLzWPr0I
	 P3EVZ7EOo4ZlrzaCmWFetgH7q9amsKPnhO9spMh4uFxxuqCcL5P+aRtmOjF1VvYTEv
	 UMWpSBiUo1hdRebgLyRvePjG/NJuNVJo+RrXnKjo=
Date: Mon, 02 Nov 2026 09:25:38 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,corbet@lwn.net,adrianhuang0701@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-fix-various-typos.patch added to mm-new branch
Message-Id: <20261102172544.B9DFE1F00A17@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon: fix various typos
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-fix-various-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-fix-various-typos.patch

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
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: Docs/admin-guide/mm/damon: fix various typos
Date: Mon, 02 Nov 2026 07:28:45 -0800

Patch series "Docs/admin-guide/mm/damon: minor fixes", v2.

Docs/admin-guide/mm/damon: minor fixes

This small patch series fixes various typos, copy-paste mistakes, and an
incorrect command syntax in the DAMON documentation files.


This patch (of 3):

Fix several spelling mistakes found while reading the DAMON
documentation:
  * trusworthy -> trustworthy
  * DAMON_RCLAIM -> DAMON_RECLAIM
  * charget -> charge
  * hetmap -> heatmap
  * colun -> column
  * evelenth -> eleventh
  * idlee -> idle

Link: https://lore.kernel.org/20261102152849.96057-1-sj@kernel.org
Link: https://lore.kernel.org/20261102152849.96057-2-sj@kernel.org
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    2 +-
 Documentation/admin-guide/mm/damon/reclaim.rst  |    4 ++--
 Documentation/admin-guide/mm/damon/start.rst    |    6 +++---
 Documentation/admin-guide/mm/damon/stat.rst     |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-fix-various-typos
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -7,7 +7,7 @@ DAMON-based LRU-lists Sorting
 DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel module that
 aims to be used for proactive and lightweight data access pattern based
 (de)prioritization of pages on their LRU-lists for making LRU-lists a more
-trusworthy data access pattern source.
+trustworthy data access pattern source.
 
 Where Proactive LRU-lists Sorting is Required?
 ==============================================
--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-fix-various-typos
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -55,7 +55,7 @@ enabled
 
 Enable or disable DAMON_RECLAIM.
 
-You can enable DAMON_RCLAIM by setting the value of this parameter as ``Y``.
+You can enable DAMON_RECLAIM by setting the value of this parameter as ``Y``.
 Setting it as ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could do
 no real monitoring and reclamation due to the watermarks-based activation
 condition.  Refer to below descriptions for the watermarks parameter for this.
@@ -125,7 +125,7 @@ quota_reset_interval_ms
 
 The time/size quota charge reset interval in milliseconds.
 
-The charget reset interval for the quota of time (quota_ms) and size
+The charge reset interval for the quota of time (quota_ms) and size
 (quota_sz).  That is, DAMON_RECLAIM does not try reclamation for more than
 quota_ms milliseconds or quota_sz bytes within quota_reset_interval_ms
 milliseconds.
--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-fix-various-typos
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -69,16 +69,16 @@ monitored access pattern of the process
 human readable format.
 
 The first line of the output shows the relative access temperature (hotness) of
-the regions in a single row hetmap format.  Each column on the heatmap
+the regions in a single row heatmap format.  Each column on the heatmap
 represents regions of same size on the monitored virtual address space.  The
-position of the colun on the row and the number on the column represents the
+position of the column on the row and the number on the column represents the
 relative location and access temperature of the region.  ``[...]`` means
 unmapped huge regions on the virtual address spaces.  The second line shows
 additional information for better understanding the heatmap.
 
 Each line of the output from the third line shows which virtual address range
 (``addr XX size XX``) of the process is how frequently (``access XX %``)
-accessed for how long time (``age XX``).  For example, the evelenth region of
+accessed for how long time (``age XX``).  For example, the eleventh region of
 ~9.5 MiB size is being most frequently accessed for last 3.7 seconds.  Finally,
 the fourth command stops DAMON.
 
--- a/Documentation/admin-guide/mm/damon/stat.rst~docs-admin-guide-mm-damon-fix-various-typos
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -81,7 +81,7 @@ Per-byte idle time (milliseconds) percen
 DAMON_STAT calculates how long each byte of the memory was not accessed until
 now (idle time), based on the current DAMON results snapshot.  For regions
 having access frequency (nr_accesses) larger than zero, how long the current
-access frequency level was kept multiplied by ``-1`` becomes the idlee time of
+access frequency level was kept multiplied by ``-1`` becomes the idle time of
 every byte of the region.  If a region has zero access frequency (nr_accesses),
 how long the region was keeping the zero access frequency (age) becomes the
 idle time of every byte of the region.  Then, DAMON_STAT exposes the
_

Patches currently in -mm which might be from adrianhuang0701@gmail.com are

mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx.patch
docs-admin-guide-mm-damon-fix-various-typos.patch
docs-admin-guide-mm-damon-lru_sort-fix-copy-paste-mistakes.patch
docs-admin-guide-mm-damon-usage-fix-incorrect-option-syntax-in-perf-example.patch

